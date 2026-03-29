import 'dart:developer';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/map_data_model.dart';
import '../../repository/iternity_repo/iternity_repo.dart';
import '../../services/logger_service.dart';
import '../../services/shared_preferences_service.dart';
import '../model/api_response/api_response.dart';
import '../model/api_response/categoires_cities_repsonemodel.dart';
import '../model/api_response/cities_respmodel.dart';
import '../model/map_resp_model.dart';

class AppMapController extends GetxController
    implements OnPointAnnotationClickListener {
  // ------------------- STATES -------------------
  final RxBool isLoading = false.obs;
  final RxBool isCategoriesLoading = false.obs;
  final RxBool isMapLoading = false.obs;
  // final RxBool isMarkersLoading = false.obs; // Loading state for markers
  final RxBool isLight = true.obs;

  final RxBool isHotelVisible = false.obs;
  RxBool fabShow = false.obs;
  RxBool showIcon = true.obs;
  final Rxn<List<CityModel>> citiesList = Rxn<List<CityModel>>();
  final RxList<CityModel> filteredCities = <CityModel>[].obs;
  final Rxn<CityDataMapDataModel> mapData = Rxn<CityDataMapDataModel>();
  final RxList<Map<String, dynamic>> markerDataList =
      <Map<String, dynamic>>[].obs;
  final RxList<PointAnnotation> annotations = <PointAnnotation>[].obs;
  final TextEditingController searchQueryController = TextEditingController();
  final Rxn<CityModel> selectedCity = Rxn<CityModel>();
  String? selectedCityId;
  final RxList<MapDataModel> annotionasDisplayed = <MapDataModel>[].obs;
  Rx<MapDataModel> selectedAnnotation = MapDataModel(lat: 0, lng: 0).obs;
  final SharedPreferencesService _prefs = SharedPreferencesService();

  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;
  Uint8List? customMarkerBytes;

  // Carousel page controller for syncing with marker selection
  final RxInt currentCarouselIndex = 0.obs;

  final Rxn<List<CategoryModel>> cityCategoriesList =
      Rxn<List<CategoryModel>>();
  final Rx<CategoryModel?> selectedCategory = Rxn<CategoryModel>();
  final RxList<PointAnnotation> visibleAnnotations = <PointAnnotation>[].obs;
  // Filled once when the map data is loaded
  final Map<String, List<PointAnnotation>> _categoryToAnnotations = {};

  setSelectedAnnotation(MapDataModel mapData) {
    selectedAnnotation.value = mapData;
  }

  /// Move map camera to a specific location
  /// Set [animate] to false for instant camera move (used on initial load)
  Future<void> animateToLocation(double lat, double lng, {double? zoom, bool animate = true}) async {
    if (_mapboxMap == null) return;
    try {
      final cameraOptions = CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: zoom ?? 14.0,
      );

      if (animate) {
        await _mapboxMap!.flyTo(
          cameraOptions,
          MapAnimationOptions(duration: 800, startDelay: 0),
        );
      } else {
        await _mapboxMap!.setCamera(cameraOptions);
      }
    } catch (e) {
      LoggerService.e('Error moving camera: $e');
    }
  }

  /// Get index of annotation in the list by its ID
  int getAnnotationIndex(String? annotationId) {
    if (annotationId == null) return 0;
    final index = annotionasDisplayed.indexWhere(
      (item) => item.annotationId == annotationId,
    );
    return index >= 0 ? index : 0;
  }

  /// Track the currently highlighted marker INDEX (more reliable than ID)
  int _currentlyHighlightedIndex = -1;

  /// Guard to prevent re-entrant calls during selection
  bool _isSelectingAnnotation = false;

  /// Select annotation by index and animate to its location
  Future<void> selectAnnotationByIndex(int index) async {
    // Prevent re-entrant calls (feedback loop from carousel onPageChanged)
    if (_isSelectingAnnotation) {
      debugPrint(
        '[MARKER] Already selecting, ignoring duplicate call for index: $index',
      );
      return;
    }

    // Skip if same index already selected
    if (_currentlyHighlightedIndex == index) {
      debugPrint('[MARKER] Same index already selected, skipping');
      return;
    }

    debugPrint('[MARKER] selectAnnotationByIndex called with index: $index');

    if (index < 0 || index >= annotionasDisplayed.length) {
      debugPrint('[MARKER] Invalid index, returning early');
      return;
    }

    _isSelectingAnnotation = true;

    try {
      final annotation = annotionasDisplayed[index];
      selectedAnnotation.value = annotation;
      currentCarouselIndex.value = index;

      // Update marker icons
      await _highlightSelectedMarkerByIndex(index);

      // Animate to the marker location
      await animateToLocation(annotation.lat, annotation.lng, zoom: 14.0);
    } finally {
      _isSelectingAnnotation = false;
    }
  }

  /// Highlights the selected marker by INDEX and resets the previous one
  Future<void> _highlightSelectedMarkerByIndex(int newIndex) async {
    debugPrint(
      '[MARKER] _highlightSelectedMarkerByIndex called with newIndex: $newIndex',
    );

    if (_annotationManager == null) {
      debugPrint(
        '[MARKER] ERROR: _annotationManager is null, cannot highlight',
      );
      return;
    }
    if (newIndex < 0 || newIndex >= markerDataList.length) {
      debugPrint(
        '[MARKER] ERROR: Invalid newIndex: $newIndex, markerDataList.length: ${markerDataList.length}',
      );
      return;
    }

    final int oldIndex = _currentlyHighlightedIndex;
    debugPrint(
      '[MARKER] Highlighting marker: oldIndex=$oldIndex -> newIndex=$newIndex',
    );

    try {
      // Update the previously selected marker (deselect it)
      if (oldIndex >= 0 &&
          oldIndex < markerDataList.length &&
          oldIndex != newIndex) {
        debugPrint('[MARKER] DESELECTING marker at index: $oldIndex');
        await _updateMarkerIcon(oldIndex, isSelected: false);
        debugPrint('[MARKER] DONE deselecting marker at index: $oldIndex');
      } else {
        debugPrint(
          '[MARKER] Skipping deselect: oldIndex=$oldIndex, markerDataList.length=${markerDataList.length}',
        );
      }

      // Update the newly selected marker (select it)
      debugPrint('[MARKER] SELECTING marker at index: $newIndex');
      await _updateMarkerIcon(newIndex, isSelected: true);
      debugPrint('[MARKER] DONE selecting marker at index: $newIndex');

      _currentlyHighlightedIndex = newIndex;
      debugPrint(
        '[MARKER] Successfully updated _currentlyHighlightedIndex to: $newIndex',
      );
    } catch (e, stack) {
      debugPrint('[MARKER] ERROR in _highlightSelectedMarkerByIndex: $e');
      LoggerService.e(
        'Error highlighting marker: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Helper to update a marker's icon by its index
  Future<void> _updateMarkerIcon(int index, {required bool isSelected}) async {
    debugPrint(
      '[MARKER] _updateMarkerIcon called: index=$index, isSelected=$isSelected',
    );

    if (_annotationManager == null) {
      debugPrint(
        '[MARKER] ERROR: _annotationManager is null in _updateMarkerIcon',
      );
      return;
    }
    if (index < 0 || index >= markerDataList.length) {
      debugPrint('[MARKER] ERROR: Invalid index in _updateMarkerIcon: $index');
      return;
    }

    final markerData = markerDataList[index];
    final PointAnnotation? marker = markerData['marker'] as PointAnnotation?;

    if (marker == null) {
      debugPrint('[MARKER] ERROR: marker is null at index: $index');
      return;
    }

    final String? priceLevel = markerData['priceLevel']?.toString();
    debugPrint('[MARKER] priceLevel for index $index: $priceLevel');

    // Determine the base icon name
    String level = 'economic'; // default
    if (priceLevel != null && priceLevel.isNotEmpty) {
      final lowerLevel = priceLevel.toLowerCase();
      if (lowerLevel == 'economic' ||
          lowerLevel == 'moderate' ||
          lowerLevel == 'luxury') {
        level = lowerLevel;
      }
    }

    final String iconName = isSelected
        ? "price-$level-selected"
        : "price-$level";
    debugPrint(
      '[MARKER] Changing marker[$index] to icon: $iconName (id: ${marker.id})',
    );

    // Update marker icon in-place instead of delete+create
    try {
      marker.iconImage = iconName;
      await _annotationManager!.update(marker);
      debugPrint(
        '[MARKER] Successfully updated marker[$index] to icon: $iconName',
      );
    } catch (e) {
      debugPrint('[MARKER] Error updating marker[$index]: $e');
      // Fallback: try delete+create approach
      debugPrint('[MARKER] Attempting fallback delete+create...');
      try {
        final geometry = marker.geometry;
        try {
          await _annotationManager!.delete(marker);
        } catch (_) {
          // Ignore delete errors
        }
        final newMarker = await _annotationManager!.create(
          PointAnnotationOptions(
            geometry: geometry,
            iconImage: iconName,
            iconSize: 1.0,
            iconAnchor: IconAnchor.BOTTOM,
          ),
        );
        markerData['marker'] = newMarker;
        if (index < annotionasDisplayed.length) {
          annotionasDisplayed[index].annotationId = newMarker.id;
        }
        debugPrint(
          '[MARKER] Fallback succeeded: marker[$index] recreated with id: ${newMarker.id}',
        );
      } catch (fallbackError) {
        debugPrint('[MARKER] Fallback also failed: $fallbackError');
      }
    }
  }

  Future<bool> getCityCategories() async {
    try {
      isCategoriesLoading.value = true;

      final ApiResponse<CitestsCategoriesDataModel> apiResponse =
          await IternityRepoRepository().getCityCategories();

      if (apiResponse.data != null) {
        // ✅ Get only attraction-type data safely from map
        final List<CategoryModel> interestData =
            apiResponse.data?.categories ?? [];
        for (var cat in interestData) {
          log('${cat.name ?? 'No Name'} ${cat.type ?? 'No type'}');
        }
        if (selectedCategory.value == null) {
          selectedCategory.value = interestData[0];
        }
        cityCategoriesList.value = interestData;
        LoggerService.i('Interests fetched: ${interestData.length}');
        return true;
      } else {
        LoggerService.w('Interest response is null');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e(
        'Error during getInterest: $e',
        error: e,
        stackTrace: stack,
      );
      return false;
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCities();
    searchQueryController.addListener(_filterCities);
  }

  // ------------------- MAP INITIALIZATION -------------------
  Future<void> onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    LoggerService.i("Map initialized successfully");

    _annotationManager = await _mapboxMap!.annotations
        .createPointAnnotationManager();
    try {
      await _mapboxMap?.style.setStyleImportConfigProperty(
        "basemap",
        "lightPreset",
        isLight.value ? "day" : "night",
      );
    } catch (e) {
      // Basemap import may not exist for non-Standard styles
      LoggerService.w("Could not set basemap config: $e");
    }
    // if (selectedCity.value == null) {
    //   await Get.toNamed(AppRoutes.searchOnMapView);
    // }
    await _createCustomMarkerIcon();
    // await getMapDataApi(selectedCityId); // can be replaced with getMapDataApi()
    _annotationManager?.tapEvents(
      onTap: (anotation) {
        debugPrint('[MARKER] Marker tapped with id: ${anotation.id}');

        // Find the index of tapped marker
        final tappedIndex = markerDataList.indexWhere(
          (data) => (data['marker'] as PointAnnotation).id == anotation.id,
        );

        debugPrint('[MARKER] Tapped marker found at index: $tappedIndex');
        debugPrint(
          '[MARKER] Current highlighted index: $_currentlyHighlightedIndex',
        );

        if (tappedIndex >= 0 && tappedIndex < annotionasDisplayed.length) {
          // Small delay to let tap event complete and prevent flicker
          Future.delayed(const Duration(milliseconds: 50), () {
            selectAnnotationByIndex(tappedIndex);
          });
        } else {
          debugPrint(
            '[MARKER] ERROR: Tapped marker not found in markerDataList',
          );
        }
      },
    );
  }

  Future<void> _createCustomMarkerIcon() async {
    final pictureRecorder = PictureRecorder();
    // ignore: unused_local_variable
    final canvas = Canvas(pictureRecorder);
    const size = 50.0;

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    customMarkerBytes = byteData!.buffer.asUint8List();

    if (_mapboxMap != null && customMarkerBytes != null) {
      await _mapboxMap!.style.addStyleImage(
        "custom-marker",
        2.0,
        MbxImage(
          width: size.toInt(),
          height: size.toInt(),
          data: customMarkerBytes!,
        ),
        false,
        [],
        [],
        null,
      );
    }

    // Create the 3 price level markers once
    await _createPriceLevelMarkers();
  }

  /// Creates all 3 price level marker images once during map initialization
  /// Loads pre-designed images from assets/map folder
  Future<void> _createPriceLevelMarkers() async {
    if (_mapboxMap == null) return;

    // Scale factor for all markers - adjust this to change marker size
    const double markerScale = 2.0;

    const priceLevels = ['economic', 'moderate', 'luxury'];
    const assetNames = ['dollar_1', 'dollar_2', 'dollar_3'];

    for (int i = 0; i < priceLevels.length; i++) {
      try {
        // Load normal marker (no border) from assets
        final markerBytes = await rootBundle.load(
          'assets/map/${assetNames[i]}_no_border.png',
        );
        final markerData = markerBytes.buffer.asUint8List();
        final codec = await ui.instantiateImageCodec(markerData);
        final frame = await codec.getNextFrame();
        final img = frame.image;

        await _mapboxMap!.style.addStyleImage(
          "price-${priceLevels[i]}",
          markerScale,
          MbxImage(width: img.width, height: img.height, data: markerData),
          false,
          [],
          [],
          null,
        );

        // Load selected marker (with border) from assets
        final selectedBytes = await rootBundle.load(
          'assets/map/${assetNames[i]}_border.png',
        );
        final selectedData = selectedBytes.buffer.asUint8List();
        final selectedCodec = await ui.instantiateImageCodec(selectedData);
        final selectedFrame = await selectedCodec.getNextFrame();
        final selectedImg = selectedFrame.image;

        await _mapboxMap!.style.addStyleImage(
          "price-${priceLevels[i]}-selected",
          markerScale,
          MbxImage(
            width: selectedImg.width,
            height: selectedImg.height,
            data: selectedData,
          ),
          false,
          [],
          [],
          null,
        );
      } catch (e) {
        LoggerService.e('Failed to create marker for ${priceLevels[i]}: $e');
      }
    }
    log(
      'Price level markers loaded from assets: economic(\$), moderate(\$\$), luxury(\$\$\$) + selected versions',
    );
  }

  setShowIcon(bool value) {
    showIcon.value = value;
  }

  // ------------------- API INTEGRATION -------------------
  Future<void> getCities() async {
    try {
      isLoading.value = true;
      final ApiResponse<CitiesData> apiResponse = await IternityRepoRepository()
          .getCities();

      if (apiResponse.data?.cities != null) {
        citiesList.value = apiResponse.data!.cities!;
        filteredCities.assignAll(apiResponse.data!.cities!);
        LoggerService.i(apiResponse.message ?? 'Cities loaded successfully');

        // Get.toNamed(AppRoutes.searchOnMapView);
      } else {
        LoggerService.w('Cities response is null');
      }
    } catch (e, stack) {
      LoggerService.e('Error fetching cities: $e', error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> getMapDataApi(String? selectedCity) async {
    try {
      if (selectedCity == null || selectedCity.trim().isEmpty) {
        LoggerService.w('No city selected - skipping API call');
        return false;
      }
      isMapLoading.value = true;
      // isMarkersLoading.value = true;

      final ApiResponse<CityDataMapDataModel> apiResponse =
          await IternityRepoRepository().getMapData(
            selectedCity,
            selectedCategory.value?.name,
          );

      if (apiResponse.data == null) {
        LoggerService.w('Map data response is null');
        return false;
      }

      mapData.value = apiResponse.data;
      log(
        '${(apiResponse.data?.attractions?.length ?? 0).toString()} attractions loaded',
      );
      log(
        '${(apiResponse.data?.restaurants?.length ?? 0).toString()} restaurants loaded',
      );
      log(
        '${(apiResponse.data?.accommodations?.length ?? 0).toString()} accommodations loaded',
      );
      // apiResponse.data?.priceLevel?.forEach((level) {
      //   log('Price level available: $level');
      // });
      LoggerService.i(apiResponse.message ?? 'Map loaded successfully');

      final city = apiResponse.data?.city;

      // --- Collect all marker data first ---
      final List<_MarkerData> allMarkerData = [];

      // Add city marker
      // if (coords != null && coords.length == 2) {
      //   allMarkerData.add(
      //     _MarkerData(
      //       lng: coords[0],
      //       lat: coords[1],
      //       address: city.region ?? '',
      //       cityName: city.name ?? '',
      //       title: '',
      //       imageUrl: _getImageUrl(city),
      //       itemId: city.id?.toString(),
      //       itemType: 'city',
      //       categoryName: 'City',
      //     ),
      //   );
      // }

      // Collect subcategory markers
      const categories = ['attractions', 'accommodations', 'restaurants'];
      for (final cat in categories) {
        final items = apiResponse.data?.toJson()[cat] ?? [];
        for (final item in items) {
          final loc = item['location']?['coordinates'];
          if (loc == null || loc.length != 2) continue;

          String? categoryName;
          switch (cat) {
            case 'attractions':
              categoryName =
                  item['category']?['name']?.toString() ?? 'Attraction';
              break;
            case 'accommodations':
              categoryName =
                  item['type']?['name'].toString() ?? 'Accommodation';
              break;
            case 'restaurants':
              categoryName = item['type']?['name'].toString() ?? 'Restaurant';
              break;
          }

          // Extract priceLevel from item
          final String? priceLevel = item['priceLevel']?.toString();
          log("Price Level: $priceLevel");
          allMarkerData.add(
            _MarkerData(
              lng: loc[0],
              lat: loc[1],
              address: item['address'] ?? '',
              cityName: city?.name ?? city?.country ?? '',
              title: item['name'],
              imageUrl: _getImageUrl(item),
              itemId: item['_id']?.toString() ?? item['id']?.toString(),
              itemType: cat,
              categoryName: categoryName,
              priceLevel: priceLevel,
            ),
          );
        }
      }

      // --- Clear existing markers and create all at once ---
      // Reset highlight state
      _currentlyHighlightedIndex = -1;

      // Clear all marker data lists BEFORE creating new markers
      markerDataList.clear();
      annotionasDisplayed.clear();
      annotations.clear();
      debugPrint(
        '[MARKER] Cleared markerDataList, annotionasDisplayed, annotations',
      );

      // Safely delete all annotations with error handling for channel issues
      if (_annotationManager != null && _mapboxMap != null) {
        try {
          await _annotationManager!.deleteAll();
        } catch (e) {
          LoggerService.e('Error deleting annotations: $e');
          // Continue execution - annotations may already be cleared
        }
      }

      // Create all markers with price level icons
      // First marker is created with selected state
      for (int i = 0; i < allMarkerData.length; i++) {
        final data = allMarkerData[i];
        await _addMarker(
          data.lng,
          data.lat,
          data.address,
          data.cityName,
          data.title,
          imageUrl: data.imageUrl,
          categoryName: data.categoryName,
          itemId: data.itemId,
          itemType: data.itemType,
          priceLevel: data.priceLevel,
          isSelected: i == 0, // First marker is selected
        );
      }

      debugPrint('[MARKER] All ${allMarkerData.length} markers created');
      debugPrint('[MARKER] markerDataList.length: ${markerDataList.length}');

      // Set the first marker as selected and move camera to it
      if (annotionasDisplayed.isNotEmpty) {
        final firstAnnotation = annotionasDisplayed.first;
        selectedAnnotation.value = firstAnnotation;
        currentCarouselIndex.value = 0;
        _currentlyHighlightedIndex = 0; // First marker is highlighted

        // Small delay to ensure markers are rendered
        await Future.delayed(const Duration(milliseconds: 300));

        // Set camera to first marker's location (no animation on initial load)
        await animateToLocation(
          firstAnnotation.lat,
          firstAnnotation.lng,
          zoom: 14.0,
          animate: false,
        );
      }
      return true;
    } catch (e, stack) {
      LoggerService.e(
        'Error fetching map data: $e',
        error: e,
        stackTrace: stack,
      );
      return false;
    } finally {
      isMapLoading.value = false;
      // isMarkersLoading.value = false;
    }
  }

  /// Helper class to hold marker data for batch processing

  String? _getImageUrl(dynamic data) {
    try {
      if (data['images'] != null &&
          data['images'] is List &&
          data['images'].isNotEmpty) {
        return data['images'].first;
      }
      if (data['media'] != null &&
          data['media'] is List &&
          data['media'].isNotEmpty) {
        return data['media'][0]['url'];
      }
    } catch (_) {}
    return null;
  }

  // ------------------- MAP FETCH MARKERS -------------------

  Future<void> selectCategory(CategoryModel? category) async {
    selectedCategory.value = category;
    annotionasDisplayed.clear();
    annotations.clear();
    selectedAnnotation.value.annotationId = null;
    visibleAnnotations.clear();
    markerDataList.clear();
    setSelectedAnnotation(MapDataModel(lat: 0, lng: 0));
    setShowIcon(true);
    annotionasDisplayed.clear();
    // pageController.value = PageController(initialPage: 0, viewportFraction: .9);
    fabShow.value = true;
    _categoryToAnnotations.clear();
    await getMapDataApi(selectedCityId);
    // Note: _applyFilter() removed - getMapDataApi already filters by selectedCategory
  }

  Future<void> clearCategory() async {
    selectedCategory.value = null;
    annotations.clear();
    visibleAnnotations.clear();
    selectedAnnotation.value.annotationId = null;
    annotionasDisplayed.clear();
    markerDataList.clear();
    _categoryToAnnotations.clear();
    await getMapDataApi(selectedCityId);
    // Note: _applyFilter() removed - getMapDataApi already handles all markers
  }

  // ------------------- MARKERS -------------------
  Future<void> _addMarker(
    double lng,
    double lat,
    String address,
    String city,
    String? title, {
    String? imageUrl,
    String? categoryName, // category name (display)
    String? itemId, // actual backend ID
    String?
    itemType, // e.g. attractions, accommodations, restaurants, festivals
    String? priceLevel, // economic, moderate, luxury
    bool isSelected = false, // whether this marker should be selected initially
  }) async {
    if (_annotationManager == null) return;

    // Use pre-created price level marker (price-economic, price-moderate, price-luxury)
    String level = 'economic'; // default fallback
    if (priceLevel != null && priceLevel.isNotEmpty) {
      final lowerLevel = priceLevel.toLowerCase();
      if (lowerLevel == 'economic' ||
          lowerLevel == 'moderate' ||
          lowerLevel == 'luxury') {
        level = lowerLevel;
      }
    }

    // Use selected icon if this is the initially selected marker
    final String iconImageId = isSelected
        ? "price-$level-selected"
        : "price-$level";

    try {
      final annotation = await _annotationManager!.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
          iconImage: iconImageId,
          iconSize: 1.0,
          iconAnchor: IconAnchor.BOTTOM,
        ),
      );

      // ✅ Store complete marker metadata
      final markerData = {
        "marker": annotation,
        "title": title,
        "image": imageUrl,
        "lat": lat,
        "lng": lng,
        "address": address,
        "category": categoryName,
        "id": itemId, // backend ID
        "type": itemType, // marker type
        "priceLevel": priceLevel,
      };
      annotionasDisplayed.add(
        MapDataModel(
          lat: lat,
          lng: lng,
          annotationId: annotation.id,
          city: city,
          categoryName: categoryName,
          imageUrl: imageUrl,
          address: address,
          itemId: itemId,
          itemType: itemType,
          title: title,
        ),
      );
      annotations.add(annotation);
      markerDataList.add(markerData);

      if (categoryName != null && categoryName.isNotEmpty) {
        _categoryToAnnotations
            .putIfAbsent(categoryName, () => [])
            .add(annotation);
      }
    } catch (e) {
      LoggerService.e('Error creating point annotation: $e');
    }
  }

  final Rxn<Map<String, dynamic>> selectedMarker = Rxn<Map<String, dynamic>>();

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    final marker = markerDataList.firstWhereOrNull(
      (e) => e["marker"].id == annotation.id,
    );
    if (marker != null) {
      // Fetch city & country dynamically
      final lat = marker["lat"];
      final lng = marker["lng"];

      getCityCountryFromLatLng(lat, lng).then((location) {
        marker['city'] = location['city'];
        marker['country'] = location['country'];
        marker['address'] = location['address'];
        selectedMarker.value = marker; // Trigger tile update
      });
    }
    return true;
  }

  Future<Map<String, String>> getCityCountryFromLatLng(
    double lat,
    double lng,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.subAdministrativeArea ?? "Unknown";
        final country = place.country ?? "Unknown";
        final address =
            "${place.name ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
        return {"city": city, "country": country, "address": address};
      }
    } catch (e) {
      LoggerService.e('Error converting lat/lng to city/country: $e');
    }
    return {"city": "Unknown", "country": "Unknown", "address": "Unknown"};
  }

  // Optional: clear selection
  void clearSelectedMarker() {
    selectedMarker.value = null;
  }

  void _filterCities() {
    final query = searchQueryController.text.toLowerCase();
    if (query.isEmpty) {
      filteredCities.assignAll(citiesList.value ?? []);
    } else {
      filteredCities.assignAll(
        (citiesList.value ?? []).where((city) {
          final cityName = city.name?.toLowerCase() ?? '';
          final country = city.country?.toLowerCase() ?? '';
          return cityName.contains(query) || country.contains(query);
        }).toList(),
      );
    }
  }

  Future<void> selectCity(String selectedCity) async {
    selectedCityId = selectedCity;

    // ✅ Save selected city to SharedPreferences
    await _prefs.saveSelectedCity(selectedCity);

    // CLEAR EVERYTHING FIRST
    annotations.clear();
    visibleAnnotations.clear();
    annotionasDisplayed.clear();
    selectedAnnotation.value.annotationId = null;
    markerDataList.clear();
    _categoryToAnnotations.clear();

    // Auto-select first category before loading data
    if (cityCategoriesList.value != null &&
        cityCategoriesList.value!.isNotEmpty) {
      selectedCategory.value = cityCategoriesList.value![0];
      LoggerService.i(
        'Auto-selected category: ${selectedCategory.value?.name}',
      );
    }

    // Load new map data (will filter by selectedCategory)
    await getMapDataApi(selectedCity);
  }

  final Rxn<Point> selectedLatLngFromMap = Rxn<Point>();

  /// ✅ Save location when tapped on map
  void setSelectedLocation(Point tappedPoint) {
    selectedLatLngFromMap.value = tappedPoint;
    LoggerService.i(
      "Selected Location => Lat: ${tappedPoint.coordinates.lat}, "
      "Lng: ${tappedPoint.coordinates.lng}",
    );
  }
}

/// Helper class to hold marker data for batch processing
class _MarkerData {
  final double lng;
  final double lat;
  final String address;
  final String cityName;
  final String? title;
  final String? imageUrl;
  final String? categoryName;
  final String? itemId;
  final String? itemType;
  final String? priceLevel;

  _MarkerData({
    required this.lng,
    required this.lat,
    required this.address,
    required this.cityName,
    this.title,
    this.imageUrl,
    this.categoryName,
    this.itemId,
    this.itemType,
    this.priceLevel,
  });
}
