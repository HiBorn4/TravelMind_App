import 'dart:convert';
import '../../config/app_urls.dart';
import '../../mvvm/model/api_response/api_response.dart';
import '../../mvvm/model/api_response/login_resp_model.dart';
import '../../mvvm/model/body_model/login_body_model.dart';
import '../../mvvm/model/body_model/sign_up_body_model.dart';
import '../../services/api_response_handler.dart';
import '../../services/https_calls.dart';
import '../../services/logger_service.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final HttpsCalls _httpsCalls = HttpsCalls();

  Future<ApiResponse<LoginResponseModel>> signUpApi(SignUpBodyModel signUpBodyModel) async {
    try {
      final endPoint = AppUrls.signUp;
      LoggerService.d('Initiating driver signup API call');
      final response = await _httpsCalls.signUpMultiPart(endPoint, signUpBodyModel);
      return await ApiResponseHandler.process(response, endPoint, (dataJson) => LoginResponseModel.fromJson(dataJson));
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<LoginResponseModel>> updateProfileApi(SignUpBodyModel signUpBodyModel) async {
    try {
      final endPoint = AppUrls.profile;
      LoggerService.d('Initiating profile update API call');
      final isOnlyIsNotifySet =
          (signUpBodyModel.email == null &&
          signUpBodyModel.password == null &&
          signUpBodyModel.firstName == null &&
          signUpBodyModel.lastName == null &&
          signUpBodyModel.profilePicture == null &&
          signUpBodyModel.city == null &&
          signUpBodyModel.country == null &&
          signUpBodyModel.phone == null);

      final http.Response response;

      if (isOnlyIsNotifySet) {
        LoggerService.i("Using simple JSON API for isNotify only");
        final jsonString = json.encode(signUpBodyModel.toJson());
        response = await _httpsCalls.postApiHits(endPoint, utf8.encode(jsonString));
      } else {
        LoggerService.i("Using multipart API for full profile update");
        response = await _httpsCalls.updateProfileMultiPart(endPoint, signUpBodyModel);
      }

      return await ApiResponseHandler.process(response, endPoint, (dataJson) => LoginResponseModel.fromJson(dataJson));
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<LoginResponseModel>> loginApi(LoginBodyModel loginBodyModel) async {
    try {
      String jsonString = json.encode(loginBodyModel.toJson());
      String? endPoint = AppUrls.login;
      final response = await HttpsCalls().postApiHits(endPoint, utf8.encode(jsonString));
      return await ApiResponseHandler.process(response, endPoint, (dataJson) => LoginResponseModel.fromJson(dataJson));
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<void>> resendOtpApi(String email) async {
    try {
      final data = {'email': email};
      String jsonString = json.encode(data);
      String? endPoint = AppUrls.resendOtp;
      final response = await HttpsCalls().postApiHits(endPoint, utf8.encode(jsonString));
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<void>> forgotPasswordApi(String email) async {
    try {
      final data = {'email': email};
      String jsonString = json.encode(data);
      String? endPoint = AppUrls.forgotPassword;
      final response = await HttpsCalls().postApiHits(endPoint, utf8.encode(jsonString));
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<void>> resetPasswordApi(String email, String otp, String newPassword) async {
    try {
      final data = {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      };
      String jsonString = json.encode(data);
      String? endPoint = AppUrls.resetPassword;
      final response = await HttpsCalls().postApiHits(endPoint, utf8.encode(jsonString));
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<void>> verifyOtpApi(String email, String otp) async {
    try {
      final data = {'email': email, 'otp': otp};
      String jsonString = json.encode(data);
      String? endPoint = AppUrls.verifyOtp;
      final response = await HttpsCalls().postApiHits(endPoint, utf8.encode(jsonString));
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  // Future<ApiResponse<void>> logoutApi() async {
  //   try {
  //     String? endPoint = AppUrls.logout;
  //     final response = await HttpsCalls().getApiHits(endPoint);
  //     return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
  //   } catch (e, stackTrace) {
  //     ApiResponseHandler.logUnhandledError(e, stackTrace);
  //     rethrow;
  //   }
  // }

  Future<ApiResponse<GetUserByIdResp>> getUserByID() async {
    // LoggerService.i('Fetching user data for ID: $id');
    try {
      // final body = {'user_id': id};
      // String jsonString = json.encode(body);
      String? endPoint = AppUrls.profile;
      final response = await HttpsCalls().getApiHits(endPoint);
      return await ApiResponseHandler.process(response, endPoint, (dataJson) => GetUserByIdResp.fromJson(dataJson));
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  // Future<ApiResponse<GetSettingsResp>> getSettings() async {
  //   try {
  //     String? endPoint = AppUrls.getAboutUs;
  //     final response = await HttpsCalls().getApiHits(endPoint);
  //     return await ApiResponseHandler.process(response, endPoint, (dataJson) => GetSettingsResp.fromJson(dataJson));
  //   } catch (e, stackTrace) {
  //     ApiResponseHandler.logUnhandledError(e, stackTrace);
  //     rethrow;
  //   }
  // }
  //
  Future<ApiResponse<void>> deleteUserApi(String? password) async {
    try {
      final Map<String, dynamic> requestBody = {'password': password, 'confirmDelete': "DELETE_MY_ACCOUNT"};
      String jsonString = json.encode(requestBody);
      String? endPoint = AppUrls.deleteAccount;
      final response = await HttpsCalls().deleteApiHits(endPoint, utf8.encode(jsonString));
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }
}
