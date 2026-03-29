class LoginBodyModel {
  final String? email;
  final String? password;
  final String? deviceToken;

  LoginBodyModel({this.password, this.deviceToken, this.email});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'fcmToken': deviceToken};
  }
}
