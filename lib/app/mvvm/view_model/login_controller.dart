import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../repository/auth_repo/auth_repo.dart';
import '../../services/logger_service.dart';
import '../../services/shared_preferences_service.dart';
import '../model/api_response/api_response.dart';
import '../model/api_response/login_resp_model.dart';
import '../model/body_model/login_body_model.dart';

class LoginController extends GetxController {
  RxBool isVisible = false.obs;
  RxBool isSendingOtp = false.obs;
  RxBool showError = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  Future<LoginBodyModel> fncLoginBodyModel(String? token) async {
    // NotificationPermissions notificationPermissions = NotificationPermissions();
    // String? deviceTokens = await notificationPermissions.getDeviceToken();
    return LoginBodyModel(email: emailController.text, password: passwordController.text, deviceToken: token?? '');
  }
  Future<bool> login(String? token) async {
    try {
      showError.value = false;
      LoggerService.i('=== LOGIN REQUEST ===');
      LoggerService.i('FCM Token being sent: ${token ?? "NULL"}');
      LoggerService.i('FCM Token length: ${token?.length ?? 0}');
      LoginBodyModel loginBodyModel = await fncLoginBodyModel(token);
      LoggerService.i('Login body: ${loginBodyModel.toJson()}');
      ApiResponse<LoginResponseModel> apiResponse = await AuthRepository().loginApi(loginBodyModel);
      if (apiResponse.data != null) {
        await SharedPreferencesService().saveUserData(apiResponse.data?.user ?? AppUser());
        await SharedPreferencesService().saveToken(apiResponse.data?.token ?? "");
        LoggerService.i(apiResponse.message ?? 'No message from server');
        clearAllData();
        return true;
      } else {
        LoggerService.w('Signup response is null');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during signup: $e', error: e, stackTrace: stack);
      return false;
    } finally {
      showError.value = true;
    }
  }


  Future<bool> resendOtpApi(String email) async {
    try {
      isSendingOtp.value = true;
      ApiResponse<void> apiResponse = await AuthRepository().resendOtpApi(email);
      if (apiResponse.success != null && apiResponse.success == true) {
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
      isSendingOtp.value = false;
    }
  }

  Future<bool> verifyOtpApi(String email) async {
    try {
      ApiResponse<void> apiResponse = await AuthRepository().verifyOtpApi(email, otpController.text);
       
      if (apiResponse.success != null && apiResponse.success == true) {
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

  void clearAllData() {
    emailController.text = '';
    passwordController.text = '';
  }
}
