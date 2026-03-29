class CitiesData {
  final List<CityModel>? cities;
  final int? totalCount;
  final int? currentPage;
  final int? totalPages;

  CitiesData({this.cities, this.totalCount, this.currentPage, this.totalPages});

  factory CitiesData.fromJson(Map<String, dynamic> json) {
    return CitiesData(
      cities: (json['cities'] as List?)?.map((e) => CityModel.fromJson(e)).toList(),
      totalCount: json['totalCount'] as int?,
      currentPage: json['currentPage'] as int?,
      totalPages: json['totalPages'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cities': cities?.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}

/// ===============================
/// ✅ City Model
/// ===============================
class CityModel {
  final String? id;
  final String? name;
  final String? country;
  final String? region;
  final String? description;
  final List<String>? image;
  final LocationModel? location;
  final String? timezone;
  final String? language;
  final bool? isActive;
  final String? createdAt;

  CityModel({
    this.id,
    this.name,
    this.country,
    this.description,
    this.image,
    this.location,
    this.timezone,
    this.region,
    this.language,
    this.isActive,
    this.createdAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      country: json['country'] as String?,
      description: json['description'] as String?,
      image: (json['image'] as List?)?.map((e) => e.toString()).toList(),
      location: json['location'] != null ? LocationModel.fromJson(json['location']) : null,
      timezone: json['timezone'] as String?,
      region: json['region'] as String?,
      language: json['language'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'image': image,
      'location': location?.toJson(),
      'timezone': timezone,
      'language': language,
      'isActive': isActive,
      "region": region,
      'createdAt': createdAt,
    };
  }
}

/// ===============================
/// ✅ Location Model
/// ===============================
class LocationModel {
  final CRSModel? crs;
  final String? type;
  final List<double>? coordinates;

  LocationModel({this.crs, this.type, this.coordinates});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      crs: json['crs'] != null ? CRSModel.fromJson(json['crs']) : null,
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List?)?.map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'crs': crs?.toJson(), 'type': type, 'coordinates': coordinates};
  }
}

/// ===============================
/// ✅ CRS Model
/// ===============================
class CRSModel {
  final String? type;
  final CRSProperties? properties;

  CRSModel({this.type, this.properties});

  factory CRSModel.fromJson(Map<String, dynamic> json) {
    return CRSModel(
      type: json['type'] as String?,
      properties: json['properties'] != null ? CRSProperties.fromJson(json['properties']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'properties': properties?.toJson()};
  }
}

/// ===============================
/// ✅ CRS Properties Model
/// ===============================
class CRSProperties {
  final String? name;

  CRSProperties({this.name});

  factory CRSProperties.fromJson(Map<String, dynamic> json) {
    return CRSProperties(name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
