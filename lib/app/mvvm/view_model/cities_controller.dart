import 'dart:developer';

import 'package:get/get.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/all_itineraries_model.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/get_popular_cities_resp_model.dart';
import 'package:vlad_ai/app/repository/cities_repo/cities_repo.dart';

import '../../services/logger_service.dart';
import '../model/api_response/api_response.dart';

class CitiesController extends GetxController {
  RxBool isPopularCitiesLoading = false.obs;
  RxBool isAllItinerariesLoading = false.obs;
  GetPopularCitiesRespModel? popularCitiesRespModel;
  AllItineraryModel? allItinerariesRespModel;

  Future<bool> getPopularCities() async {
    try {
      isPopularCitiesLoading.value = true;
      ApiResponse<GetPopularCitiesRespModel> apiResponse = await CitiesRepository().getPopularCities();
      if (apiResponse.data != null) {
        popularCitiesRespModel = apiResponse.data;
        LoggerService.i(apiResponse.message ?? 'No message from server');
        return true;
      } else {
        LoggerService.w('Signup response is null');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during signup: $e', error: e, stackTrace: stack);
      return false;
    } finally {
      isPopularCitiesLoading.value = false;
    }
  }

  // Future<void> fncReadSp() async {
  //   spUser.value = await SharedPreferencesService().readUserData();
  //   GlobalVariables.globalToken = await SharedPreferencesService().readToken() ?? "";
  //   LoggerService.i("User data read from SP: ${spUser.value?.name}");
  //   update(); // ✅ Force UI update if spUser is used in Obx
  // }

  Future<bool> getAllItineraries({bool? load}) async {
    try {
      if (load ?? true) {
        isAllItinerariesLoading.value = true;
      }
      AllItineraryModel? apiResponse = await CitiesRepository().getAllItineraries();
      if (apiResponse != null) {
        allItinerariesRespModel = apiResponse;
        log(allItinerariesRespModel?.data.totalCount.toString() ?? 'null');
        LoggerService.i(apiResponse.message);
        return true;
      } else {
        LoggerService.w('Signup response is null');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during signup: $e', error: e, stackTrace: stack);
      return false;
    } finally {
      if (load ?? true) {
        isAllItinerariesLoading.value = false;
      }
    }
  }
}
