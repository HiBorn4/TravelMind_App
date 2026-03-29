import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/repository/iternity_repo/iternity_repo.dart';
import 'package:vlad_ai/app/services/https_calls.dart';
import '../../services/logger_service.dart';
import 'package:intl/intl.dart';

import '../model/api_response/acc_inter_responsemodel.dart';
import '../model/api_response/api_response.dart';
import '../model/api_response/cities_respmodel.dart';
import '../model/api_response/iternitiy_resp_model.dart';
import '../model/body_model/iternity_bodymodel.dart'; // For formatting dates

class PlanTripController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final PageController pageController = PageController();
  RxDouble sliderValue = 1.0.obs;
  RxBool isEditingLocation = true.obs;
  RxBool isLocationLoading = false.obs;
  RxBool isDataLoading = false.obs;
  RxBool isAccLoading = false.obs;
  RxBool isInterestLoading = false.obs;
  RxBool isPlanLoading = false.obs;
  RxBool isEditingDays = false.obs;
  RxBool isEditingTravelers = false.obs;
  RxBool isEditingBudget = false.obs;
  RxBool disabledPersonaValue = false.obs;
  RxBool petFriendlyValue = false.obs;
  RxInt childrenCount = 0.obs;
  RxInt adultsCount = 0.obs;
  RxInt petsCount = 0.obs;
  RxString budgetValue = 'Luxury'.obs;
  RxString groupValue = 'Friends'.obs;
  RxString placeValue = 'Hostel'.obs;
  RxString selectedAccommodation = ''.obs;

  final Rxn<List<CityModel>> citiesList = Rxn<List<CityModel>>();

  Rx<ItineraryItr>? itineraryIt = ItineraryItr().obs;
  double? latitude;
  double? longitude;

  RxString currentLocation = ''.obs; // Reactive variable for location
  RxString currentRegion = ''.obs; // Reactive variable for region

  // Reactive variables for start date, end date, and days
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxInt daysCount = 0.obs;

  void selectCity(CityModel city) {
    selectedCityId.value = city.id ?? "";
    currentLocation.value = city.name ?? '';
    currentRegion.value = city.region ?? '';
    isEditingLocation.value = false; // close list after selection
  }

  final RxList<CityModel> filteredCities = <CityModel>[].obs;
  final RxString selectedCityId = ''.obs;

  /// Call after getCities() success
  void initializeCities() {
    filteredCities.assignAll(citiesList.value ?? []);
  }

  /// Called on search input change
  void filterCities(String query) {
    if (query.isEmpty) {
      filteredCities.assignAll(citiesList.value ?? []);
    } else {
      final q = query.toLowerCase();
      filteredCities.assignAll(
        (citiesList.value ?? []).where(
          (c) => (c.name ?? '').toLowerCase().contains(q) || (c.country ?? '').toLowerCase().contains(q),
        ),
      );
      if (kDebugMode) {
        print(filteredCities.length);
      }
    }
  }

  /// Store selected city

  // Future<void> fetchUserLocation() async {
  //   try {
  //     isLocationLoading.value = true;
  //     final success = await locationService.getCurrentLocation();
  //     if (success) {
  //       latitude = locationService.latitude;
  //       longitude = locationService.longitude;
  //       currentLocation.value = locationService.currentLocation ?? 'Unknown';
  //       LoggerService.i('Current Location: ${currentLocation.value}');
  //     } else {
  //       LoggerService.w('Unable to fetch current location.');
  //       currentLocation.value = 'Unknown';
  //     }
  //   } finally {
  //     isLocationLoading.value = false;
  //   }
  // }

  Future<bool> updateSlot(String itenerayId, String slotId, String time) async {
    try {
      isDataLoading.value = true;
      final data = {
        "slots": [
          {"slotId": slotId, "time": time},
        ],
      };
      if (kDebugMode) {
        print(data);
      }
      String jsonString = json.encode(data);
      final response = await HttpsCalls().patchApiHits(
        '/v2/itineraries/:$itenerayId/slots/times',
        utf8.encode(jsonString),
      );
      if (kDebugMode) {
        log(response.body);
      }
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e, _) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      isDataLoading.value = false;
    }
  }

  /// Reorder slots within a day
  /// [itineraryId] - The itinerary ID
  /// [slotIds] - List of slot IDs in the new desired order (must include ALL slots from that day)
  Future<bool> reorderSlots(String itineraryId, List<String> slotIds) async {
    try {
      final response = await IternityRepoRepository().reorderSlots(itineraryId, slotIds);
      if (response.data != null) {
        // Update both data sources to keep them in sync
        iterneityResponseModel.value = response.data;
        itineraryIt?.value = response.data!.itinerary;
        LoggerService.i('Slots reordered successfully');
        return true;
      }
      return false;
    } catch (e, stack) {
      LoggerService.e('Error reordering slots: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  final RxList<String> selectedInterestIds = <String>[].obs;

  /// 🔹 Toggle selection
  void toggleSelection(String id) {
    if (selectedInterestIds.contains(id)) {
      selectedInterestIds.remove(id);
    } else {
      selectedInterestIds.add(id);
    }
  }

  void updateTripDates(DateTime? newStartDate, DateTime? newEndDate) {
    startDate.value = newStartDate;
    endDate.value = newEndDate;

    if (startDate.value != null && endDate.value != null) {
      daysCount.value = endDate.value!.difference(startDate.value!).inDays;
      if (daysCount.value < 0) {
        daysCount.value = 0;
        LoggerService.w('End date is before start date.');
      }
      sliderValue.value = daysCount.value.toDouble();
    } else {
      daysCount.value = 0;
      sliderValue.value = 1.0;
    }
  }

  // Format date for display
  String formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return DateFormat('MMM d, yyyy').format(date);
  }

  final List<String> items = ["Luxury", "Moderate", "Economic"];
  final List<String> groupList = ["Solo", "Couple", "Friends", "Family"];

  void incrementPage() {
    selectedIndex.value++;
  }

  void decrementPage() {
    selectedIndex.value--;
  }

  Future<void> initView() async {
    try {
      isPlanLoading.value = true;
      // await Future.wait([getCurrentLocation()]);
      await Future.wait([getAccommodation(), getInterest(), getCities()]);
    } catch (e, stack) {
      LoggerService.e('Error loading home data', error: e, stackTrace: stack);
    } finally {
      isPlanLoading.value = false;
    }
  }

  final Rxn<List<AccommodationCategory>> accommodationList = Rxn<List<AccommodationCategory>>();
  final Rxn<List<AccommodationCategory>> intrestList = Rxn<List<AccommodationCategory>>();

  Future<bool> getAccommodation() async {
    try {
      isAccLoading.value = true;
      final ApiResponse<AccommodationInterestData> apiResponse = await IternityRepoRepository().getAccommodation();
      if (apiResponse.data != null) {
        // ✅ Get only accommodation-type data safely from map
        final List<AccommodationCategory> accData = apiResponse.data!.getByType('accommodation');
        accommodationList.value = accData;
        selectedAccommodation.value = accData[0].id ?? '';
        LoggerService.i('Accommodation fetched: ${accData.length}');
        return true;
      } else {
        LoggerService.w('Accommodation response is null');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during getAccommodation: $e', error: e, stackTrace: stack);
      return false;
    } finally {
      isAccLoading.value = false;
    }
  }

  Future<bool> getInterest() async {
    try {
      isInterestLoading.value = true;
      final ApiResponse<AccommodationInterestData> apiResponse = await IternityRepoRepository().getInterest();
      if (apiResponse.data != null) {
        // ✅ Get only attraction-type data safely from map
        final List<AccommodationCategory> interestData = apiResponse.data!.getByType('attraction');
        intrestList.value = interestData;
        LoggerService.i('Interests fetched: ${interestData.length}');
        return true;
      } else {
        LoggerService.w('Interest response is null');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during getInterest: $e', error: e, stackTrace: stack);
      return false;
    } finally {
      isInterestLoading.value = false;
    }
  }

  getItineryById(String itineraryId) async {
    try {
      isDataLoading.value = true;
      String? endPoint = '/v2/itineraries/$itineraryId';
      final response = await HttpsCalls().getApiHits(endPoint);
      if (kDebugMode) {
        log(response.body);
      }
      if (response.statusCode == 200) {
        itineraryIt!.value = ItineraryItr.fromJson(jsonDecode(response.body)['data']['itinerary']);
        iterneityResponseModel.value = IterneityResponseModel(
          itinerary: itineraryIt!.value,
          festivals: null,
          helpfulThings: null,
        );
        // log(iterneityResponseModel. .toString());
        return true;
      } else {
        LoggerService.w('Signup response is null');
        return false;
      }
    } catch (e, _) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      isDataLoading.value = false;
    }
  }

  Future<bool> getCities() async {
    try {
      ApiResponse<CitiesData> apiResponse = await IternityRepoRepository().getCities();
      if (apiResponse.data != null) {
        citiesList.value = apiResponse.data?.cities;

        LoggerService.i(apiResponse.message ?? 'No message from server');
        return true;
      } else {
        LoggerService.w('Signup response is null');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during signup: $e', error: e, stackTrace: stack);
      return false;
    } finally {}
  }

  ItineraryBodyModel createItineraryBody() {
    return ItineraryBodyModel(
      cityId: selectedCityId.value,
      startDate: startDate.value != null ? DateFormat('yyyy-MM-dd').format(startDate.value!) : '',
      endDate: endDate.value != null ? DateFormat('yyyy-MM-dd').format(endDate.value!) : '',
      numberOfTravelers: (adultsCount.value + childrenCount.value),
      budget: budgetValue.value.isNotEmpty ? budgetValue.value.toLowerCase() : 'economic',
      travelStyle: groupValue.value.isNotEmpty ? groupValue.value.toLowerCase() : 'solo',
      accommodationCategoryId: selectedAccommodation.value,
      disabledPerson: disabledPersonaValue.value,
      userInterests: selectedInterestIds,
    );
  }

  Rxn<IterneityResponseModel> iterneityResponseModel = Rxn<IterneityResponseModel>();

  /// Creates a new itinerary and returns the created itinerary ID on success, null on failure
  Future<String?> craeteIterApi() async {
    try {
      isDataLoading.value = true;

      ItineraryBodyModel itineraryBodyModel = createItineraryBody();
      ApiResponse<IterneityResponseModel> apiResponse = await IternityRepoRepository().createIternity(
        itineraryBodyModel,
      );

      if (apiResponse.data != null) {
        iterneityResponseModel.value = apiResponse.data;

        LoggerService.i('****Model set successfully****: ${iterneityResponseModel.value?.itinerary.city?.name ?? ''}');
        LoggerService.i(apiResponse.message ?? 'No message from server');
        return apiResponse.data!.itinerary.id;
      } else {
        LoggerService.w('Response data is null');
        return null;
      }
    } catch (e, stack) {
      LoggerService.e('Error during API call: $e', error: e, stackTrace: stack);
      return null;
    } finally {
      isDataLoading.value = false;
    }
  }
}
