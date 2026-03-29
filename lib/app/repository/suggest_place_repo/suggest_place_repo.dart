import 'dart:convert';
import 'package:vlad_ai/app/mvvm/model/body_model/suggest_place_body_model.dart';

import '../../config/app_urls.dart';
import '../../mvvm/model/api_response/api_response.dart';
import '../../mvvm/model/api_response/iternitiy_resp_model.dart';
import '../../services/api_response_handler.dart';
import '../../services/https_calls.dart';

class SuggestPlaceRepo {
  // final HttpsCalls _httpsCalls = HttpsCalls();

  Future<ApiResponse<void>> suggestPlaceApi(SuggestPlaceBodyModel suggestPlaceBodyModel) async {
    try {
      String jsonString = json.encode(suggestPlaceBodyModel.toJson());
      String? endPoint = AppUrls.suggestPlaceApi;
      final response = await HttpsCalls().postApiHits(endPoint, utf8.encode(jsonString));
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
