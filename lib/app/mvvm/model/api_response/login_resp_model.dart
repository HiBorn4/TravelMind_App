class LoginResponseModel {
  final AppUser? user;
  final String? token;

  LoginResponseModel({this.user, this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(user: json['user'] != null ? AppUser.fromJson(json['user']) : null, token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson(), 'token': token};
  }
}

class AppUser {
  final String? id;
  final bool? isActive;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? cityId;
  final String? language;
  final String? profileImage;
  final String? country;
  final String? city;
  final Location? location;
  final String? phone;
  final bool? isVerified;
  final String? fcmToken;
  final String? emailOtp;
  final DateTime? otpExpiresAt;
  final String? passwordResetOtp;
  final DateTime? passwordResetOtpExpiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastLogin;

  AppUser({
    this.id,
    this.isActive,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.cityId,
    this.language,
    this.profileImage,
    this.country,
    this.city,
    this.location,
    this.phone,
    this.isVerified,
    this.fcmToken,
    this.emailOtp,
    this.otpExpiresAt,
    this.passwordResetOtp,
    this.passwordResetOtpExpiresAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.lastLogin,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      isActive: json['isActive'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      cityId: json['cityId'],
      language: json['language'],
      profileImage: json['profileImage'],
      country: json['country'],
      city: json['city'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      phone: json['phone'],
      isVerified: json['isVerified'],
      fcmToken: json['fcmToken'],
      emailOtp: json['emailOtp'],
      otpExpiresAt: json['otpExpiresAt'] != null ? DateTime.tryParse(json['otpExpiresAt']) : null,
      passwordResetOtp: json['passwordResetOtp'],
      passwordResetOtpExpiresAt: json['passwordResetOtpExpiresAt'] != null ? DateTime.tryParse(json['passwordResetOtpExpiresAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null,
      lastLogin: json['lastLogin'] != null ? DateTime.tryParse(json['lastLogin']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isActive': isActive,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'cityId': cityId,
      'language': language,
      'profileImage': profileImage,
      'country': country,
      'city': city,
      'location': location?.toJson(),
      'phone': phone,
      'isVerified': isVerified,
      'fcmToken': fcmToken,
      'emailOtp': emailOtp,
      'otpExpiresAt': otpExpiresAt?.toIso8601String(),
      'passwordResetOtp': passwordResetOtp,
      'passwordResetOtpExpiresAt': passwordResetOtpExpiresAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;
  final Crs? crs;

  Location({this.type, this.coordinates, this.crs});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'] != null ? List<double>.from(json['coordinates'].map((x) => x.toDouble())) : null,
      crs: json['crs'] != null ? Crs.fromJson(json['crs']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates, 'crs': crs?.toJson()};
  }
}

class Crs {
  final String? type;
  final CrsProperties? properties;

  Crs({this.type, this.properties});

  factory Crs.fromJson(Map<String, dynamic> json) {
    return Crs(type: json['type'], properties: json['properties'] != null ? CrsProperties.fromJson(json['properties']) : null);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'properties': properties?.toJson()};
  }
}

class CrsProperties {
  final String? name;

  CrsProperties({this.name});

  factory CrsProperties.fromJson(Map<String, dynamic> json) {
    return CrsProperties(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}



class GetUserByIdResp {
  AppUser? user;

  GetUserByIdResp({this.user});

  GetUserByIdResp.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? AppUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Properties {
  String? name;

  Properties({this.name});

  Properties.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

