import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  static const _langKey = 'selected_language';

  late Rx<Locale> selectedLocale;

  @override
  void onInit() {
    super.onInit();

    final savedLang = _box.read<String>(_langKey) ?? 'en';
    selectedLocale = Locale(savedLang).obs;

    Get.updateLocale(selectedLocale.value);
  }

  void changeLanguage(Locale locale) {
    selectedLocale.value = locale;
    _box.write(_langKey, locale.languageCode);
    Get.updateLocale(locale);
  }
}
