import 'dart:io';
import 'location_model.dart';

class SignUpBodyModel {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phone;
  LocationModel? location;
  String? country;
  String? city;
  String? language;
  File? profilePicture;
  bool? isNotify;
  String? fcmToken;

  SignUpBodyModel({
    this.email,
    this.password,
    this.phone,
    this.profilePicture,
    this.isNotify,
    this.firstName,
    this.lastName,
    this.location,
    this.country,
    this.city,
    this.language,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (isNotify != null) data['is_notify'] = isNotify;
    if (phone != null) data['phone'] = phone;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (location != null) data['location'] = location!.toJson(); // GeoJSON format
    if (country != null) data['country'] = country;
    if (city != null) data['city'] = city;
    if (language != null) data['language'] = language;
    if (fcmToken != null) data['fcmToken'] = fcmToken;

    // Note: profilePicture is handled separately in multipart request, not included here

    return data;
  }

  factory SignUpBodyModel.fromJson(Map<String, dynamic> json) {
    return SignUpBodyModel(
      email: json['email'],
      password: json['password'],
      isNotify: json['is_notify'],
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      country: json['country'],
      city: json['city'],
      language: json['language'],
      fcmToken: json['fcmToken'],
      location: json['location'] != null ? LocationModel.fromJson(json['location']) : null,
      profilePicture: json['profileImage'] != null ? File(json['profileImage']) : null,
    );
  }
}
