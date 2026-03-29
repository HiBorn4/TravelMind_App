import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../mvvm/model/api_response/cities_respmodel.dart';
import '../mvvm/model/api_response/login_resp_model.dart';
import 'logger_service.dart';

/// Service for managing local storage using SharedPreferences.
class SharedPreferencesService {
  // static const String _keyDataModel = 'data_model';
  static const String _keyUserData = 'user_data';
  static const String _deviceToken = 'deviceToken';
  static const String _apiToken = 'apiToken';
  // static const String _languageLocale = 'languageLocale';


  static const String _keySelectedCity = 'selected_city';

  Future<void> saveSelectedCity(String cityId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySelectedCity, cityId);
    LoggerService.i('✅ Saved selected city: $cityId');
  }

  Future<String?> readSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final cityId = prefs.getString(_keySelectedCity);
    LoggerService.d('📍 Read selected city: $cityId');
    return cityId;
  }

  static const String _keySelectedCityModel = 'selected_city_model';

  Future<void> saveSelectedCityModel(CityModel city) async {
    final prefs = await SharedPreferences.getInstance();
    final cityJson = json.encode(city.toJson()); // convert model to JSON string
    await prefs.setString(_keySelectedCityModel, cityJson);
    LoggerService.i('✅ Saved selected city: $cityJson');
  }

  Future<CityModel?> readSelectedCityModel() async {
    final prefs = await SharedPreferences.getInstance();
    final cityJson = prefs.getString(_keySelectedCityModel);
    LoggerService.d('📍 Read selected city: $cityJson');

    if (cityJson != null) {
      final Map<String, dynamic> cityMap = json.decode(cityJson);
      return CityModel.fromJson(cityMap);
    }
    return null;
  }



  static const String _keyMapData = 'map_data';

  Future<void> saveMapData(Map<String, dynamic> mapData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(mapData);
    await prefs.setString(_keyMapData, jsonData);
    LoggerService.i('✅ Saved map data to SharedPreferences');
  }

  Future<Map<String, dynamic>?> readMapData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyMapData);
    if (data != null) {
      LoggerService.d('📍 Map data loaded from SharedPreferences');
      return json.decode(data);
    }
    return null;
  }




  Future<void> saveDeviceToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceToken, token);
    LoggerService.i('Saved device token');
  }

  Future<String?> readDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_deviceToken);
    LoggerService.d('Read device token: $token');
    return token;
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiToken, token);
    LoggerService.i('Saved API token');
  }

  Future<String?> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_apiToken);
    LoggerService.d('Read API token: $token');
    return token;
  }

  Future<void> saveUserData(AppUser userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = json.encode(userData.toJson());
    await prefs.setString(_keyUserData, data);
  }

  Future<AppUser?> readUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyUserData);
    if (data != null) {
      Map<String, dynamic> jsonData = json.decode(data);
      return AppUser.fromJson(jsonData);
    }
    return null;
  }

  // static Future<void> saveLocaleLanguage(NinjaLangModel locale) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final data = json.encode(locale.toJson());
  //   await prefs.setString(_languageLocale, data);
  // }
  //
  // static Future<NinjaLangModel?> readLanguageLocale() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? data = prefs.getString(_languageLocale);
  //   if (data != null) {
  //     final jsonData = json.decode(data);
  //     return NinjaLangModel.fromJson(jsonData);
  //   }
  //   return null;
  // }

  Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.clear();
    if (result) {
      LoggerService.i('All SharedPreferences data cleared successfully');
    } else {
      LoggerService.e('Failed to clear SharedPreferences data');
    }
  }
}
