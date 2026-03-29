import 'dart:developer';

import 'package:vlad_ai/app/mvvm/model/api_response/all_itineraries_model.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/get_cities_details_resp_model.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/get_popular_cities_resp_model.dart';

import '../../config/app_urls.dart';
import '../../mvvm/model/api_response/api_response.dart';
import '../../services/api_response_handler.dart';
import '../../services/https_calls.dart';

class CitiesRepository {
  // final HttpsCalls _httpsCalls = HttpsCalls();

  Future<ApiResponse<GetPopularCitiesRespModel>> getPopularCities() async {
    try {
      String? endPoint = AppUrls.getPopularCities;
      final response = await HttpsCalls().getApiHits(endPoint);
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {
        log('Popular Cities Response JSON: $dataJson');
        return GetPopularCitiesRespModel.fromJson(dataJson);
      });
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<GetCitiesDetailFResponseModel>> getCityDetails(String id) async {
    try {
      String? endPoint = AppUrls.getCityDetails;
      String? dynamicUrl = "$endPoint/$id";
      final response = await HttpsCalls().getApiHits(dynamicUrl);

      log(response.body);
      return await ApiResponseHandler.process(
        response,
        endPoint,
        (dataJson) => GetCitiesDetailFResponseModel.fromJson(dataJson),
      );
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<AllItineraryModel?> getAllItineraries() async {
    try {
      String? endPoint = AppUrls.getCityLastTrips;
      final response = await HttpsCalls().getApiHits(endPoint);
      if (response.statusCode == 200) {
        return AllItineraryModel.fromJson(response.body);
      }
      return null;
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }
}
