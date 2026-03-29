import 'dart:convert';

class CountriesResponse {
  final bool success;
  final String message;
  final String timestamp;
  final CountriesData data;

  CountriesResponse({
    required this.success,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  factory CountriesResponse.fromMap(Map<String, dynamic> map) {
    return CountriesResponse(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? '',
      data: CountriesData.fromMap(map['data'] ?? {}),
    );
  }

  factory CountriesResponse.fromJson(String source) =>
      CountriesResponse.fromMap(json.decode(source));
}

class CountriesData {
  final List<CountryModel> countries;
  final int total;

  CountriesData({
    required this.countries,
    required this.total,
  });

  factory CountriesData.fromMap(Map<String, dynamic> map) {
    return CountriesData(
      countries: map['countries'] != null
          ? List<CountryModel>.from(
              map['countries'].map((x) => CountryModel.fromMap(x)))
          : [],
      total: map['total']?.toInt() ?? 0,
    );
  }
}

class CountryModel {
  final String code;
  final String name;
  final String callingCode;

  CountryModel({
    required this.code,
    required this.name,
    required this.callingCode,
  });

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      callingCode: map['callingCode'] ?? '',
    );
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryModel && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
