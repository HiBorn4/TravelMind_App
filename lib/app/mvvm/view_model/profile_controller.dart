import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../repository/auth_repo/auth_repo.dart';
import '../../services/logger_service.dart';
import '../../services/shared_preferences_service.dart';
import '../model/api_response/api_response.dart';
import '../model/api_response/login_resp_model.dart';
import '../model/body_model/sign_up_body_model.dart';

class ProfileController extends GetxController {
  final ImagePicker picker = ImagePicker();
  Rx<File?> rXfile = Rx<File?>(null);
  RxBool pushNotificationsValue = false.obs;
  AppUser? user;
  RxBool isUserLoading = false.obs;
  TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  fncReadSp() async {
    isUserLoading.value = true;
    user = await SharedPreferencesService().readUserData();
  }

  Future<bool> fetchUserData() async {
    isUserLoading.value = true;
    try {
      await fncReadSp();
      ApiResponse<GetUserByIdResp> apiResponse = await AuthRepository().getUserByID();
      if (apiResponse.success != null && apiResponse.success!) {
        user = apiResponse.data?.user;
        firstNameController.text = user?.firstName ?? 'N/A';
        emailController.text = user?.email ?? 'N/A';
        lastNameController.text = user?.lastName ?? 'N/A';
        phoneNumberController.text = user?.phone ?? "N/A";
        nationalityController.text = user?.country ?? "N/A";
        cityController.text = user?.city ?? 'N/A';
        await SharedPreferencesService().saveUserData(user!);
        return true;
      } else {
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during fetching user data: $e', error: e, stackTrace: stack);
      return false;
    } finally {
      isUserLoading.value = false;
    }
  }

  Future<bool> deleteUserApi() async {
    try {
      ApiResponse<void> apiResponse = await AuthRepository().deleteUserApi(passwordController.text);
      if (apiResponse.success != null && apiResponse.success!) {
        SharedPreferencesService().clearAllPreferences();
        return true;
      } else {
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during fetching user data: $e', error: e, stackTrace: stack);
      return false;
    } finally {}
  }

  Future<bool> pickImageFromGallery() async {
    try {
      rXfile.value = null;
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        rXfile.value = File(pickedFile.path);
        print('Image path: ${rXfile.value?.path}');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error picking image: $e');
      return false;
    }
  }

  Future<bool> pickImageFromCamera() async {
    try {
      rXfile.value = null;
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        rXfile.value = File(pickedFile.path);

        print('Image path: ${rXfile.value?.path}');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error picking image: $e');
      return false;
    }
  }

  SignUpBodyModel createSignUpBodyModel() {
    return SignUpBodyModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      profilePicture: rXfile.value,
      city: cityController.text,
      country: nationalityController.text,
      phone: phoneNumberController.text,
    );
  }

  Future<bool> updateProfileApi() async {
    try {
      SignUpBodyModel signUpBodyModel = createSignUpBodyModel();
      ApiResponse<LoginResponseModel> apiResponse = await AuthRepository().updateProfileApi(signUpBodyModel);
      if (apiResponse.data != null) {
        user = apiResponse.data?.user;
        user = apiResponse.data?.user;
        firstNameController.text = user?.firstName ?? '';
        lastNameController.text = user?.lastName ?? '';
        emailController.text = user?.email ?? '';
        await SharedPreferencesService().saveUserData(user!);
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
}
