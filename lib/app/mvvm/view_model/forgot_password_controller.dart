import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../repository/auth_repo/auth_repo.dart';
import '../../services/logger_service.dart';
import '../model/api_response/api_response.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isSendingOtp = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  /// Step 1: Send OTP for password reset
  Future<bool> forgotPassword() async {
    try {
      ApiResponse<void>? apiResponse = await AuthRepository().forgotPasswordApi(emailController.text);
      if (apiResponse.success != null && apiResponse.success!) {
        LoggerService.i(apiResponse.message ?? 'OTP sent successfully');
        return true;
      } else {
        LoggerService.w('Failed to send OTP');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error sending OTP: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Resend OTP for password reset
  Future<bool> resendOtp() async {
    try {
      isSendingOtp.value = true;
      ApiResponse<void>? apiResponse = await AuthRepository().forgotPasswordApi(emailController.text);
      if (apiResponse.success != null && apiResponse.success!) {
        LoggerService.i(apiResponse.message ?? 'OTP resent successfully');
        return true;
      } else {
        LoggerService.w('Failed to resend OTP');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error resending OTP: $e', error: e, stackTrace: stack);
      return false;
    } finally {
      isSendingOtp.value = false;
    }
  }

  /// Step 2 & 3: Reset password with OTP
  Future<bool> resetPassword() async {
    try {
      isLoading.value = true;
      ApiResponse<void>? apiResponse = await AuthRepository().resetPasswordApi(
        emailController.text,
        otpController.text,
        newPasswordController.text,
      );
      if (apiResponse.success != null && apiResponse.success!) {
        LoggerService.i(apiResponse.message ?? 'Password reset successfully');
        return true;
      } else {
        LoggerService.w('Failed to reset password');
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error resetting password: $e', error: e, stackTrace: stack);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearAllData() {
    emailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }
}
