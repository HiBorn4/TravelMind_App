import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/acc_inter_responsemodel.dart';
import 'package:vlad_ai/app/mvvm/model/body_model/suggest_place_body_model.dart';
import 'package:vlad_ai/app/repository/suggest_place_repo/suggest_place_repo.dart';
import '../../repository/iternity_repo/iternity_repo.dart';
import '../../services/logger_service.dart';
import '../model/api_response/api_response.dart';
import '../model/api_response/cities_respmodel.dart';

class SuggestPlaceController extends GetxController {
  RxString selectedCategory = ''.obs;
  RxDouble sliderValue = 1.0.obs;
  RxBool showSeasonSelection = false.obs;
  RxList<String> selectedSeason = [''].obs;
  RxList<String> selectedLocationStyle = [''].obs;
  RxBool isCategoriesLoading = false.obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final RxList<String> selectedSubcategoriesIds = <String>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<List<CityModel>> citiesList = Rxn<List<CityModel>>();
  final RxList<CityModel> filteredCities = <CityModel>[].obs;
  final TextEditingController searchQueryController = TextEditingController();
  final Rxn<CityModel> selectedCity = Rxn<CityModel>();
  RxString selectedCityId = ''.obs;
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  RxString cityName = ''.obs;
  RxString countryName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCities();
    searchQueryController.addListener(_filterCities);
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

  void selectCity(CityModel city) {
    selectedCity.value = city;
    selectedCityId.value = city.id ?? '';

    LoggerService.i('Selected city: ${city.name} ($selectedCityId)');
    Get.back(result: city); // Pass city object back
  }

  Future<void> getCities() async {
    try {
      isLoading.value = true;
      final ApiResponse<CitiesData> apiResponse = await IternityRepoRepository().getCities();

      if (apiResponse.data?.cities != null) {
        citiesList.value = apiResponse.data!.cities!;
        filteredCities.assignAll(apiResponse.data!.cities!);
        LoggerService.i(apiResponse.message ?? 'Cities loaded successfully');
      } else {
        LoggerService.w('Cities response is null');
      }
    } catch (e, stack) {
      LoggerService.e('Error fetching cities: $e', error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Toggle selection
  void toggleSelection(String id) {
    if (selectedSubcategoriesIds.contains(id)) {
      selectedSubcategoriesIds.remove(id);
    } else {
      selectedSubcategoriesIds.add(id);
    }
  }

  final Rxn<List<AccommodationCategory>> subCategoriesList = Rxn<List<AccommodationCategory>>();

  Future<bool> getSubCategories() async {
    try {
      isCategoriesLoading.value = true;
      final ApiResponse<AccommodationInterestData> apiResponse = selectedCategory.value == "Restaurant"
          ? await IternityRepoRepository().getRestaurantCategories()
          : selectedCategory.value == "Touristic Attraction"
          ? await IternityRepoRepository().getInterest()
          : await IternityRepoRepository().getAccommodation();
      if (apiResponse.data != null) {
        // ✅ Get only accommodation-type data safely from map
        final List<AccommodationCategory> accData = selectedCategory.value == "Restaurant"
            ? apiResponse.data!.getByType('restaurant')
            : selectedCategory.value == "Touristic Attraction"
            ? apiResponse.data!.getByType('attraction')
            : apiResponse.data!.getByType('accommodation');
        subCategoriesList.value = accData;
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
      isCategoriesLoading.value = false;
    }
  }

  SuggestPlaceBodyModel createSuggestBodyModel() {
    selectedSeason.remove('');
    selectedLocationStyle.remove('');
    return SuggestPlaceBodyModel(
      title: titleController.text.trim(),
      address: addressController.text.trim(),
      cityId: selectedCityId.value,
      budget: sliderValue.value == 0
          ? 'economic'
          : sliderValue.value == 5
          ? 'moderate'
          : 'luxury',
      categoryIds: selectedSubcategoriesIds,
      location: Location(coordinates: [lat.value, long.value]),
      travelStyle: selectedLocationStyle.map((e) => e.toLowerCase()).toList(),
      popularSeasons: selectedSeason.map((e) => e.toLowerCase()).toList(),
    );
  }

  Future<bool> suggestPlaceApi() async {
    try {
      SuggestPlaceBodyModel suggestPlaceBodyModel = createSuggestBodyModel();
      ApiResponse<void> apiResponse = await SuggestPlaceRepo().suggestPlaceApi(suggestPlaceBodyModel);
      if (apiResponse.success != null && apiResponse.success!) {
        LoggerService.i(apiResponse.message ?? 'No message from server');
        return true;
      } else {
        LoggerService.w('Response data is null');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during API call: $e', error: e, stackTrace: stack);
      return false;
    } finally {}
  }
}
