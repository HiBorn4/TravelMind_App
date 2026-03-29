import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/map_data_model.dart';

import '../config/app_colors.dart';
import '../config/app_routes.dart';
import '../config/utils.dart';
import '../mvvm/view_model/map_controller.dart';
import '../mvvm/view_model/suggest_place_controller.dart';
import '../services/logger_service.dart';
import '../services/shared_preferences_service.dart';
import 'custom_dialog_location.dart';
import 'custom_loader.dart';
import 'custom_snackbar/custom_snackbar.dart';
import 'hotel_tile.dart';

class ProjectionMapWidget extends StatefulWidget {
  final AppMapController controller;
  final String from;

  const ProjectionMapWidget({
    super.key,
    required this.controller,
    required this.from,
  });

  @override
  State<ProjectionMapWidget> createState() => _ProjectionMapWidgetState();
}

class _ProjectionMapWidgetState extends State<ProjectionMapWidget> {
  final SuggestPlaceController suggestController = Get.put(
    SuggestPlaceController(),
  );
  Point? _currentPoint;
  bool _isLoading = true;
  final bool _isDarkMode = false;
  // ignore: unused_field
  MapboxMap? _mapboxMap;

  // Carousel PageController
  late PageController _pageController;

  /// True when page change is initiated programmatically (from marker tap or controller)
  /// Used to prevent onPageChanged from triggering selectAnnotationByIndex during programmatic changes
  bool _isProgrammaticPageChange = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);

    // Listen to carousel index changes from controller (when marker is tapped or initial load)
    ever(widget.controller.currentCarouselIndex, (index) {
      if (_pageController.hasClients) {
        // Set flag BEFORE animating to prevent onPageChanged from triggering selection
        _isProgrammaticPageChange = true;

        // If index is 0 and we're at the start, jump immediately (initial load)
        if (index == 0 && (_pageController.page ?? 0) < 0.5) {
          _pageController.jumpToPage(0);
          // Reset flag after a short delay
          Future.delayed(const Duration(milliseconds: 100), () {
            _isProgrammaticPageChange = false;
          });
        } else {
          _pageController
              .animateToPage(
                index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              )
              .then((_) {
                // Reset flag after animation completes
                _isProgrammaticPageChange = false;
              });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeCurrentLocation();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeCurrentLocation() async {
    try {
      final SharedPreferencesService prefs = SharedPreferencesService();
      await widget.controller.getCityCategories();
      // 🔹 CASE 1: Check if a selected city exists in SP
      // final savedCityId = await prefs.readSelectedCity();
      // if (savedCityId != null && savedCityId.isNotEmpty) {
      // Load mapData for the saved city
      // await widget.controller.getMapDataApi(savedCityId);
      // widget.controller.selectCity(savedCityId);

      // final cityCoords = widget.controller.mapData.value?.city?.location?.coordinates;
      // if (cityCoords != null && cityCoords.length == 2) {
      //   setState(() {
      //     _currentPoint = Point(coordinates: Position(cityCoords[0], cityCoords[1]));
      //     _isLoading = false;
      //   });
      //   LoggerService.i('🌆 Loaded mapData for selected city from SP');
      //   return; // ✅ Exit after using saved city
      // }
      // }

      // 🔹 CASE 2: If mapData already has city coordinates from API
      final apiCityCoords =
          widget.controller.mapData.value?.city?.location?.coordinates;
      if (apiCityCoords != null && apiCityCoords.length == 2) {
        if (!mounted) return;
        setState(() {
          _currentPoint = Point(
            coordinates: Position(apiCityCoords[0], apiCityCoords[1]),
          );
          _isLoading = false;
        });
        LoggerService.i('🌆 Using existing mapData coordinates (API)');
        return;
      }

      // 🔹 CASE 3: No API coordinates → use default location (Romania)
      if (!mounted) return;
      setState(() {
        _currentPoint = Point(coordinates: Position(24.6622, 47.6533));
        _isLoading = false;
      });
      LoggerService.i('Using default map location (Romania)');
    } catch (e, _) {
      debugPrint('Error initializing map: $e');
      if (!mounted) return;
      setState(() {
        _currentPoint = Point(coordinates: Position(24.6622, 47.6533));
        _isLoading = false;
      });
    }
  }

  // Future<void> _toggleMapTheme() async {
  //   if (_mapboxMap == null) return;
  //   setState(() => _isDarkMode = !_isDarkMode);
  //   final styleUri = _isDarkMode ? MapboxStyles.DARK : MapboxStyles.LIGHT;
  //   await _mapboxMap!.loadStyleURI(styleUri);
  // }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CustomLoader());

    if (_currentPoint == null) {
      return const Center(child: Text("Unable to fetch current location"));
    }

    return Stack(
      children: [
        MapWidget(
          key: const ValueKey("mapWidget"),
          cameraOptions: CameraOptions(center: _currentPoint, zoom: 13.0),
          styleUri: _isDarkMode ? MapboxStyles.DARK : MapboxStyles.LIGHT,
          textureView: true,
          onMapCreated: (mapboxMap) async {
            _mapboxMap = mapboxMap;
            // Disable compass
            await mapboxMap.compass.updateSettings(
              CompassSettings(enabled: false),
            );
          },
          onStyleLoadedListener: (styleLoadedEventData) async {
            if (_mapboxMap != null) {
              await widget.controller.onMapCreated(_mapboxMap!);
            }
          },

          onTapListener: (MapContentGestureContext mapContext) async {
            final Point tappedPoint = mapContext.point;
            final double lat = tappedPoint.coordinates.lat.toDouble();
            final double lng = tappedPoint.coordinates.lng.toDouble();
            try {
              final List<Placemark> placemarks = await placemarkFromCoordinates(
                lat,
                lng,
              );
              if (placemarks.isEmpty) {
                CustomSnackbar.show(
                  iconData: Icons.info,
                  title: "Coordinates Selected",
                  message:
                      "No readable address found. Lat: ${lat.toStringAsFixed(5)}, Lng: ${lng.toStringAsFixed(5)}",
                  textColor: Colors.black,
                  backgroundColor: AppColors.white,
                  iconColor: Colors.black,
                  borderColor: Colors.black,
                  messageText: [
                    "Lat: ${lat.toStringAsFixed(5)}, Lng: ${lng.toStringAsFixed(5)}",
                  ],
                );
                return;
              }
              final place = placemarks.first;
              final city =
                  place.locality ??
                  place.subAdministrativeArea ??
                  "Unknown city";
              final country = place.country ?? "Unknown country";
              final address =
                  "${place.name ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

              widget.controller.setSelectedLocation(tappedPoint);
              suggestController.lat.value = lat;
              suggestController.long.value = lng;
              suggestController.cityName.value = city;
              suggestController.countryName.value = country;

              /// 🧠 Always check mounted context before showing UI
              if (!mounted) return;

              if (widget.from == 'suggest') {
                // ✅ Show Minimal Cupertino Dialog
                Utils.showCustomDialog(
                  context: context,
                  child: CupertinoLocationInfoDialog(
                    city: city,
                    country: country,
                    address: address,
                  ),
                );
              } else {
                // ✅ Otherwise show custom snackbar
                // CustomSnackbar.show(
                //   iconData: Icons.check_circle,
                //   title: "Location Selected",
                //   message: "City: $city\nCountry: $country\n📍 $address",
                //   textColor: AppColors.positiveGreen,
                //   backgroundColor: AppColors.white,
                //   iconColor: Colors.green,
                //   borderColor: AppColors.positiveGreen,
                //   messageText: ["City: $city\nCountry: $country\n📍 $address"],
                // );
              }
            } catch (e) {
              if (!mounted) return;

              CustomSnackbar.show(
                iconData: Icons.error,
                title: "Location Error",
                message:
                    "Could not retrieve address. Coordinates saved: Lat ${lat.toStringAsFixed(5)}, Lng ${lng.toStringAsFixed(5)}",
                textColor: AppColors.white,
                backgroundColor: AppColors.black,
                iconColor: AppColors.black,
                borderColor: AppColors.black,
                messageText: [
                  "Lat: ${lat.toStringAsFixed(5)}, Lng: ${lng.toStringAsFixed(5)}",
                ],
              );
            }
          },
        ),

        /// ✅ Carousel of marker cards
        Obx(() {
          final markers = widget.controller.annotionasDisplayed;
          if (markers.isEmpty) {
            return const SizedBox.shrink();
          }

          // Hide FAB icon when carousel is visible
          if (markers.isNotEmpty) {
            Future.delayed(
              const Duration(milliseconds: 100),
              () => widget.controller.setShowIcon(false),
            );
          }

          return Positioned(
            left: 0,
            right: 0,
            bottom: 15.h,
            height: 115.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: markers.length,
              physics:
                  const ClampingScrollPhysics(), // Prevent looping/bouncing
              onPageChanged: (index) {
                // Skip if this page change is from programmatic animation (marker tap, etc.)
                if (_isProgrammaticPageChange) return;

                // Only trigger selection when user manually scrolls the carousel
                widget.controller.selectAnnotationByIndex(index);
              },
              itemBuilder: (context, index) {
                final marker = markers[index];
                final isSleepCategory =
                    widget.controller.selectedCategory.value?.name
                        ?.toLowerCase()
                        .contains('sleep') ??
                    false;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: MainHotelTile(
                    categoryName: marker.categoryName ?? '',
                    images:
                        marker.imageUrl ??
                        "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
                    hotelTitle: marker.title ?? "Unknown",
                    address: marker.address,
                    location: isSleepCategory
                        ? marker.itemType?.capitalizeFirst ?? ''
                        : marker.city ?? "",
                    onClose: () {
                      widget.controller.selectedMarker.value = null;
                      widget.controller.setSelectedAnnotation(
                        MapDataModel(lat: 0, lng: 0),
                      );
                      widget.controller.setShowIcon(true);
                      widget.controller.fabShow.value = true;
                    },
                    onTap: () {
                      widget.controller.fabShow.value = true;
                      if (kDebugMode) {
                        print('Marker Actual ID: ${marker.itemId}');
                      }
                      // Navigate and pass only the ID
                      Get.toNamed(
                        AppRoutes.hotelDetailView,
                        arguments: marker.itemId ?? '',
                      );
                    },
                  ),
                );
              },
            ),
          );
        }),

        /// Toggle Button
        // Positioned(
        //   left: 16,
        //   bottom: 42,
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.white,
        //     shape: const CircleBorder(),
        //     elevation: 6.0,
        //     onPressed: _toggleMapTheme,
        //     child: Icon(_isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: Colors.black),
        //   ),
        // ),
      ],
    );
  }

  void _animateCameraToPosition(double lat, double lng, double zoom) async {
    if (_mapboxMap == null) return;

    await _mapboxMap!.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: 500, startDelay: 0),
    );
  }
}


// if (widget.controller.selectedAnnotation.value.annotationId != null) {
//             return Align(
//               alignment: AlignmentGeometry.bottomCenter,
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 250.h,
//                 child: PageView.builder(
//                   itemCount: widget.controller.annotionasDisplayed.length,
//                   onPageChanged: (index) {
//                     final item = widget.controller.annotionasDisplayed[index];
//                     widget.controller.setSelectedAnnotation(item, index);
//                     _animateCameraToPosition(item.lat, item.lng, 14);
//                   },
//                   controller: widget.controller.pageController.value,
//                   itemBuilder: (context, index) {
//                     final item = widget.controller.annotionasDisplayed[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: MainHotelTile(
//                         images: item.imageUrl ?? "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
//                         hotelTitle: item.title ?? "Unknown",
//                         address: item.address,
//                         location:
//                             widget.controller.selectedCategory.value?.name?.toLowerCase().contains('sleep') ?? false
//                             ? item.itemType?.capitalizeFirst ?? ''
//                             : item.city ?? "",
//                         onClose: () {
//                           widget.controller.setSelectedAnnotation(MapDataModel(lat: 0, lng: 0), index);
//                           widget.controller.setShowIcon(true);
//                           widget.controller.fabShow.value = true;
//                         },
//                         onTap: () {
//                           widget.controller.fabShow.value = true;
//                           if (kDebugMode) {
//                             print('Marker Actual ID: ');
//                           }
//                           Get.toNamed(AppRoutes.hotelDetailView, arguments: item.itemId ?? '');
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             );