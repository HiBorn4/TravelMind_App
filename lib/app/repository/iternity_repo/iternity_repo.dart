import 'dart:convert';
import 'dart:developer';

import '../../config/app_urls.dart';
import '../../mvvm/model/api_response/acc_inter_responsemodel.dart';
import '../../mvvm/model/api_response/api_response.dart';
import '../../mvvm/model/api_response/categoires_cities_repsonemodel.dart';
import '../../mvvm/model/api_response/cities_respmodel.dart';
import '../../mvvm/model/api_response/iternitiy_resp_model.dart';
import '../../mvvm/model/body_model/iternity_bodymodel.dart';
import '../../mvvm/model/map_resp_model.dart';
import '../../services/api_response_handler.dart';
import '../../services/https_calls.dart';

class IternityRepoRepository {
  // final HttpsCalls _httpsCalls = HttpsCalls();

  Future<ApiResponse<IterneityResponseModel>> createIternity(ItineraryBodyModel itineraryBodyModel) async {
    try {
      String jsonString = json.encode(itineraryBodyModel.toJson());
      String? endPoint = AppUrls.createItinery;
      final response = await HttpsCalls().postApiHits(endPoint, utf8.encode(jsonString));
      log(response.body);
      return await ApiResponseHandler.process(
        response,
        endPoint,
        (dataJson) => IterneityResponseModel.fromJson(dataJson),
      );
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<AccommodationInterestData>> getAccommodation() async {
    try {
      String? endPoint = AppUrls.getAccommodation;
      final response = await HttpsCalls().getApiHits(endPoint);
      return await ApiResponseHandler.process(
        response,
        endPoint,
        (dataJson) => AccommodationInterestData.fromJson(dataJson),
      );
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<AccommodationInterestData>> getInterest() async {
    try {
      String? endPoint = AppUrls.getInterest;
      final response = await HttpsCalls().getApiHits(endPoint);
      return await ApiResponseHandler.process(
        response,
        endPoint,
        (dataJson) => AccommodationInterestData.fromJson(dataJson),
      );
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<AccommodationInterestData>> getRestaurantCategories() async {
    try {
      String? endPoint = AppUrls.getRestaurantCategories;
      final response = await HttpsCalls().getApiHits(endPoint);
      return await ApiResponseHandler.process(
        response,
        endPoint,
        (dataJson) => AccommodationInterestData.fromJson(dataJson),
      );
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<CitestsCategoriesDataModel>> getCityCategories() async {
    try {
      String? endPoint = AppUrls.citiesCategoriesNew;
      final response = await HttpsCalls().getApiHits(endPoint);
      return await ApiResponseHandler.process(
        response,
        endPoint,
        (dataJson) => CitestsCategoriesDataModel.fromJson(dataJson),
      );
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<CitiesData>> getCities() async {
    try {
      String? endPoint = AppUrls.getCities;
      final response = await HttpsCalls().getApiHits(endPoint);
      return await ApiResponseHandler.process(response, endPoint, (dataJson) => CitiesData.fromJson(dataJson));
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<CityDataMapDataModel>> getMapData(String? cityId, String? category) async {
    try {
      log(
        category?.isNotEmpty ?? true
            ? '${AppUrls.getCities}/$cityId/filtered?categoryIds=$category'
            : '${AppUrls.getCities}/$cityId/filtered',
      );

      final String endPoint = category?.isNotEmpty ?? true
          ? '${AppUrls.getCities}/$cityId/filtered?categoryIds=$category'
          : '${AppUrls.getCities}/$cityId/filtered';

      final response = await HttpsCalls().getApiHits(endPoint);
      print(response.body);
      return await ApiResponseHandler.process(
        response,
        endPoint,
        (dataJson) => CityDataMapDataModel.fromJson(dataJson),
      );
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  /// Reorder slots within a day
  /// [itineraryId] - The itinerary ID
  /// [slotIds] - List of slot IDs in the new desired order (must include ALL slots from that day)
  Future<ApiResponse<IterneityResponseModel>> reorderSlots(String itineraryId, List<String> slotIds) async {
    try {
      final String endPoint = '${AppUrls.reorderSlots}/$itineraryId/slots/reorder';
      final body = json.encode({'slotIds': slotIds});
      final response = await HttpsCalls().patchApiHits(endPoint, utf8.encode(body));
      log('Reorder slots response: ${response.body}');
      return await ApiResponseHandler.process(
        response,
        endPoint,
        (dataJson) => IterneityResponseModel.fromJson(dataJson),
      );
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }
}
