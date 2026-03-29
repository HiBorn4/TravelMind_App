import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlad_ai/app/config/app_urls.dart';
import 'package:vlad_ai/app/mvvm/model/body_model/countries_model.dart';
import 'package:vlad_ai/app/mvvm/model/body_model/location_model.dart';
import 'package:vlad_ai/app/services/https_calls.dart';

import '../../repository/auth_repo/auth_repo.dart';
import '../../services/logger_service.dart';
import '../model/body_model/sign_up_body_model.dart';

class SignUpController extends GetxController {
  final ImagePicker picker = ImagePicker();
  Rx<File?> rXfile = Rx<File?>(null);
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  RxString completePhoneNumber = ''.obs;
  RxBool isVisible = false.obs;
  RxBool showError = false.obs;
  RxBool isVisibleConfirmPassword = false.obs;
  RxBool acceptedTerms = false.obs;
  RxBool acceptedPrivacyPolicy = false.obs;

  // Countries dropdown
  RxList<CountryModel> countriesList = <CountryModel>[].obs;
  Rx<CountryModel?> selectedNationality = Rx<CountryModel?>(null);
  RxBool isLoadingCountries = false.obs;

  bool get canSignUp => acceptedTerms.value && acceptedPrivacyPolicy.value;

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      isLoadingCountries.value = true;
      final response = await HttpsCalls().getApiHits(AppUrls.getCountries);
      if (response.statusCode == 200) {
        final countriesResponse = CountriesResponse.fromJson(response.body);
        countriesList.value = countriesResponse.data.countries;
        LoggerService.i('Loaded ${countriesList.length} countries');
      }
    } catch (e) {
      LoggerService.e('Error fetching countries: $e');
    } finally {
      isLoadingCountries.value = false;
    }
  }

  void updateCompletePhoneNumber() {
    if (phoneNumberController.text.isNotEmpty) {
      completePhoneNumber.value = '+${selectedCountry.value.phoneCode} ${phoneNumberController.text.trim()}';
    } else {
      completePhoneNumber.value = phoneNumberController.text.trim();
    }
  }

  Future<bool> pickImageFromGallery() async {
    try {
      rXfile.value = null;
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        rXfile.value = File(pickedFile.path);
        if (kDebugMode) {
          print('Image path: ${rXfile.value?.path}');
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
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

  Rx<Country> selectedCountry = Country(
    phoneCode: '40',
    countryCode: 'RO',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Romania',
    example: '712 345 678',
    displayName: 'Romania (+40)',
    displayNameNoCountryCode: 'Romania',
    e164Key: '40-RO',
  ).obs;

  // --------------------- SignUp Body ---------------------
  SignUpBodyModel createSignUpBodyModel(String? fcmToken) {
    return SignUpBodyModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      password: passwordController.text,
      profilePicture: rXfile.value,
      email: emailController.text,
      phone: completePhoneNumber.value,
      isNotify: true,
      country: selectedNationality.value?.name ?? '',
      city: cityController.text,
      location: LocationModel(
        coordinates: [-74.006, 40.7128], // ✅ will auto send {"type":"Point"}
      ),
      language: "en",
      fcmToken: fcmToken,
    );
  }

  // --------------------- Signup API ---------------------
  Future<bool> signUp(String? fcmToken) async {
    try {
      showError.value = false;
      final signUpBodyModel = createSignUpBodyModel(fcmToken);
      final apiResponse = await AuthRepository().signUpApi(signUpBodyModel);
      if (apiResponse.data != null) {
        LoggerService.i(apiResponse.message ?? 'Signup success');
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

  void clearData() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    lastNameController.clear();
    firstNameController.clear();
    countryController.clear();
    cityController.clear();
    phoneNumberController.clear();
    completePhoneNumber.value = '';
    rXfile.value = null;
    acceptedTerms.value = false;
    acceptedPrivacyPolicy.value = false;
    selectedNationality.value = null;
  }
}
