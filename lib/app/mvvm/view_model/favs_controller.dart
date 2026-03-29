import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vlad_ai/app/config/app_urls.dart';
import 'package:vlad_ai/app/mvvm/model/body_model/favourite_model.dart';
import 'package:vlad_ai/app/services/https_calls.dart';

class FavsController extends GetxController {
  RxBool isFavLoading = true.obs;
  Rx<FavouriteModel> favouriteModel = FavouriteModel(
    success: true,
    message: 'message',
    timestamp: 'timestamp',
    data: null,
  ).obs;
  Future<bool> getFavs(bool load) async {
    try {
      if (load) {
        isFavLoading.value = true;
      }
      String? endPoint = AppUrls.getFavsApi;
      final response = await HttpsCalls().getApiHits(endPoint);
      if (response.statusCode == 200) {
        favouriteModel.value = FavouriteModel.fromJson(response.body);
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
      if (load) {
        isFavLoading.value = false;
      }
    }
  }

  Future<bool> postFavs(String type, String id) async {
    try {
      String? endPoint = AppUrls.postFavsApi;
      final data = {"type": type};
      if (type == "restaurant") {
        data.addAll({"restaurantId": id});
      } else if (type == "accommodation") {
        data.addAll({"accommodationId": id});
      } else if (type == "attraction") {
        data.addAll({"attractionId": id});
      } else if (type == "itinerary") {
        data.addAll({"itineraryId": id});
      }
      String jsonString = json.encode(data);
      final response = await HttpsCalls().postApiHits(endPoint, utf8.encode(jsonString));
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['isFavorited'];
      } else {
        return false;
      }
    } catch (e, _) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
