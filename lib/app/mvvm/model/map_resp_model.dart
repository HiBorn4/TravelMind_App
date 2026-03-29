// Generated models for city data API response
// All classes end with MapDataModel
// All fields nullable
// Each class has fromJson / toJson

// class CityDataResponseMapDataModel {
//   bool? success;
//   String? message;
//   String? timestamp;
//   CityDataMapDataModel? data;
//
//   CityDataResponseMapDataModel({
//     this.success,
//     this.message,
//     this.timestamp,
//     this.data,
//   });
//
//   factory CityDataResponseMapDataModel.fromJson(Map<String, dynamic> json) {
//     return CityDataResponseMapDataModel(
//       success: json['success'] as bool?,
//       message: json['message'] as String?,
//       timestamp: json['timestamp'] as String?,
//       data: json['data'] != null
//           ? CityDataMapDataModel.fromJson(json['data'])
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'timestamp': timestamp,
//       'data': data?.toJson(),
//     };
//   }
// }


// Add this helper at the top of your file or in a utils file
String? parseString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is List && value.isNotEmpty) {
    return value.first.toString();
  }
  return value.toString();
}

List<String>? parseStringList(dynamic value) {
  if (value == null) return null;
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  if (value is String) {
    return [value];
  }
  return [value.toString()];
}

class CityDataMapDataModel {
  CityDetailsMapDataModel? city;
  List<AttractionMapDataModel>? attractions;
  List<AccommodationMapDataModel>? accommodations;
  List<RestaurantMapDataModel>? restaurants;
  List<FestivalMapDataModel>? festivals;
  FiltersMapDataModel? filters;

  CityDataMapDataModel({
    this.city,
    this.attractions,
    this.accommodations,
    this.restaurants,
    this.festivals,
    this.filters,
  });

  factory CityDataMapDataModel.fromJson(Map<String, dynamic> json) {
    return CityDataMapDataModel(
      city: json['city'] != null
          ? CityDetailsMapDataModel.fromJson(json['city'])
          : null,
      attractions: (json['attractions'] as List<dynamic>?)
          ?.map((e) => AttractionMapDataModel.fromJson(e))
          .toList(),
      accommodations: (json['accommodations'] as List<dynamic>?)
          ?.map((e) => AccommodationMapDataModel.fromJson(e))
          .toList(),
      restaurants: (json['restaurants'] as List<dynamic>?)
          ?.map((e) => RestaurantMapDataModel.fromJson(e))
          .toList(),
      festivals: (json['festivals'] as List<dynamic>?)
          ?.map((e) => FestivalMapDataModel.fromJson(e))
          .toList(),
      filters: json['filters'] != null
          ? FiltersMapDataModel.fromJson(json['filters'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city?.toJson(),
      'attractions': attractions?.map((e) => e.toJson()).toList(),
      'accommodations':
      accommodations?.map((e) => e.toJson()).toList(),
      'restaurants': restaurants?.map((e) => e.toJson()).toList(),
      'festivals': festivals?.map((e) => e.toJson()).toList(),
      'filters': filters?.toJson(),
    };
  }
}

class CityDetailsMapDataModel {
  String? id;
  String? name;
  String? country;
  String? region;
  String? timezone;
  GeoLocationMapDataModel? location;
  String? description;
  String? image;
  bool? isActive;
  String? language;
  List<String>? bestMonthsToVisit;
  String? popularSeason;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? version;

  CityDetailsMapDataModel({
    this.id,
    this.name,
    this.country,
    this.region,
    this.timezone,
    this.location,
    this.description,
    this.image,
    this.isActive,
    this.language,
    this.bestMonthsToVisit,
    this.popularSeason,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.version,
  });

  factory CityDetailsMapDataModel.fromJson(Map<String, dynamic> json) {
    return CityDetailsMapDataModel(
      id: parseString(json['id']),
      name: parseString(json['name']),
      country: parseString(json['country']),
      region: parseString(json['region']), // Fixed: was crashing here
      timezone: parseString(json['timezone']),
      location: json['location'] != null
          ? GeoLocationMapDataModel.fromJson(json['location'])
          : null,
      description: parseString(json['description']),
      image: parseString(json['image']),
      isActive: json['isActive'] as bool?,
      language: parseString(json['language']),
      bestMonthsToVisit: parseStringList(json['bestMonthsToVisit']),
      popularSeason: parseString(json['popularSeason']),
      createdBy: parseString(json['createdBy']),
      updatedBy: parseString(json['updatedBy']),
      createdAt: parseString(json['createdAt']),
      updatedAt: parseString(json['updatedAt']),
      deletedAt: parseString(json['deletedAt']),
      version: json['version'] is int
          ? json['version'] as int?
          : json['version'] is double
          ? (json['version'] as double).toInt()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'region': region,
      'timezone': timezone,
      'location': location?.toJson(),
      'description': description,
      'image': image,
      'isActive': isActive,
      'language': language,
      'bestMonthsToVisit': bestMonthsToVisit,
      'popularSeason': popularSeason,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'version': version,
    };
  }
}
class GeoLocationMapDataModel {
  CrsMapDataModel? crs;
  String? type;
  List<double>? coordinates; // [lng, lat] usually

  GeoLocationMapDataModel({
    this.crs,
    this.type,
    this.coordinates,
  });

  factory GeoLocationMapDataModel.fromJson(Map<String, dynamic> json) {
    return GeoLocationMapDataModel(
      crs: json['crs'] != null
          ? CrsMapDataModel.fromJson(json['crs'])
          : null,
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) {
        if (e is num) return e.toDouble();
        return double.tryParse(e.toString()) ?? 0.0;
      })
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crs': crs?.toJson(),
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class CrsMapDataModel {
  String? type;
  CrsPropertiesMapDataModel? properties;

  CrsMapDataModel({
    this.type,
    this.properties,
  });

  factory CrsMapDataModel.fromJson(Map<String, dynamic> json) {
    return CrsMapDataModel(
      type: json['type'] as String?,
      properties: json['properties'] != null
          ? CrsPropertiesMapDataModel.fromJson(json['properties'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'properties': properties?.toJson(),
    };
  }
}

class CrsPropertiesMapDataModel {
  String? name;

  CrsPropertiesMapDataModel({
    this.name,
  });

  factory CrsPropertiesMapDataModel.fromJson(Map<String, dynamic> json) {
    return CrsPropertiesMapDataModel(
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class AttractionMapDataModel {
  String? id;
  String? name;
  String? description;
  String? shortDescription;
  String? cityId;
  String? categoryId;
  GeoLocationMapDataModel? location;
  String? address;
  int? durationMinutes;
  String? priceLevel;
  String? priceRange;
  List<String>? availableSeasons;
  bool? isWheelchairAccessible;
  List<String>? travelStyles;
  int? recommendationWeight;
  bool? isActive;
  List<String>? images;
  bool? includesMeal;
  bool? requiresReservation;
  int? maxGroupSize;
  int? minAge;
  String? ageRestrictionNote;
  int? difficultyLevel;
  String? difficultyLabel;
  String? bestTimeToVisit;
  String? phone;
  String? email;
  String? opensAt;
  String? closesAt;
  bool? reopens;
  String? reopensAt;
  String? closesAgainAt;
  String? googleMapUrl;
  String? specialNotes;
  String? additionalContact;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  CategoryMapDataModel? category;

  AttractionMapDataModel({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.cityId,
    this.categoryId,
    this.location,
    this.address,
    this.durationMinutes,
    this.priceLevel,
    this.priceRange,
    this.availableSeasons,
    this.isWheelchairAccessible,
    this.travelStyles,
    this.recommendationWeight,
    this.isActive,
    this.images,
    this.includesMeal,
    this.requiresReservation,
    this.maxGroupSize,
    this.minAge,
    this.ageRestrictionNote,
    this.difficultyLevel,
    this.difficultyLabel,
    this.bestTimeToVisit,
    this.phone,
    this.email,
    this.opensAt,
    this.closesAt,
    this.reopens,
    this.reopensAt,
    this.closesAgainAt,
    this.googleMapUrl,
    this.specialNotes,
    this.additionalContact,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.category,
  });

  factory AttractionMapDataModel.fromJson(Map<String, dynamic> json) {
    return AttractionMapDataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      cityId: json['cityId'] as String?,
      categoryId: json['categoryId'] as String?,
      location: json['location'] != null
          ? GeoLocationMapDataModel.fromJson(json['location'])
          : null,
      address: json['address'] as String?,
      durationMinutes: json['durationMinutes'] is int
          ? json['durationMinutes'] as int?
          : json['durationMinutes'] is double
          ? (json['durationMinutes'] as double).toInt()
          : null,
      priceLevel: json['priceLevel'] as String?,
      priceRange: json['priceRange'] as String?,
      availableSeasons: (json['availableSeasons'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      isWheelchairAccessible:
      json['isWheelchairAccessible'] as bool?,
      travelStyles: (json['travelStyles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      recommendationWeight: json['recommendationWeight'] is int
          ? json['recommendationWeight'] as int?
          : json['recommendationWeight'] is double
          ? (json['recommendationWeight'] as double).toInt()
          : null,
      isActive: json['isActive'] as bool?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      includesMeal: json['includesMeal'] as bool?,
      requiresReservation: json['requiresReservation'] as bool?,
      maxGroupSize: json['maxGroupSize'] is int
          ? json['maxGroupSize'] as int?
          : json['maxGroupSize'] is double
          ? (json['maxGroupSize'] as double).toInt()
          : null,
      minAge: json['minAge'] is int
          ? json['minAge'] as int?
          : json['minAge'] is double
          ? (json['minAge'] as double).toInt()
          : null,
      ageRestrictionNote: json['ageRestrictionNote'] as String?,
      difficultyLevel: json['difficultyLevel'] is int
          ? json['difficultyLevel'] as int?
          : json['difficultyLevel'] is double
          ? (json['difficultyLevel'] as double).toInt()
          : null,
      difficultyLabel: json['difficultyLabel'] as String?,
      bestTimeToVisit: json['bestTimeToVisit'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      opensAt: json['opensAt']?.toString(),
      closesAt: json['closesAt']?.toString(),
      reopens: json['reopens'] as bool?,
      reopensAt: json['reopensAt']?.toString(),
      closesAgainAt: json['closesAgainAt']?.toString(),
      googleMapUrl: json['googleMapUrl'] as String?,
      specialNotes: json['specialNotes']?.toString(),
      additionalContact: json['additionalContact']?.toString(),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt']?.toString(),
      category: json['category'] != null
          ? CategoryMapDataModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'cityId': cityId,
      'categoryId': categoryId,
      'location': location?.toJson(),
      'address': address,
      'durationMinutes': durationMinutes,
      'priceLevel': priceLevel,
      'priceRange': priceRange,
      'availableSeasons': availableSeasons,
      'isWheelchairAccessible': isWheelchairAccessible,
      'travelStyles': travelStyles,
      'recommendationWeight': recommendationWeight,
      'isActive': isActive,
      'images': images,
      'includesMeal': includesMeal,
      'requiresReservation': requiresReservation,
      'maxGroupSize': maxGroupSize,
      'minAge': minAge,
      'ageRestrictionNote': ageRestrictionNote,
      'difficultyLevel': difficultyLevel,
      'difficultyLabel': difficultyLabel,
      'bestTimeToVisit': bestTimeToVisit,
      'phone': phone,
      'email': email,
      'opensAt': opensAt,
      'closesAt': closesAt,
      'reopens': reopens,
      'reopensAt': reopensAt,
      'closesAgainAt': closesAgainAt,
      'googleMapUrl': googleMapUrl,
      'specialNotes': specialNotes,
      'additionalContact': additionalContact,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'category': category?.toJson(),
    };
  }
}

class AccommodationMapDataModel {
  String? id;
  String? name;
  String? description;
  String? shortDescription;
  String? cityId;
  String? categoryId;
  GeoLocationMapDataModel? location;
  String? address;
  String? priceLevel;
  int? pricePerNight;
  List<String>? amenities;
  bool? allowsFamilies;
  int? maxGuests;
  int? minimumNightsStay;
  bool? isPetFriendly;
  bool? isWheelchairAccessible;
  int? recommendationWeight;
  bool? isActive;
  List<String>? images;
  String? website;
  String? phone;
  String? googleMapUrl;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  CategoryMapDataModel? category;

  AccommodationMapDataModel({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.cityId,
    this.categoryId,
    this.location,
    this.address,
    this.priceLevel,
    this.pricePerNight,
    this.amenities,
    this.allowsFamilies,
    this.maxGuests,
    this.minimumNightsStay,
    this.isPetFriendly,
    this.isWheelchairAccessible,
    this.recommendationWeight,
    this.isActive,
    this.images,
    this.website,
    this.phone,
    this.googleMapUrl,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.category,
  });

  factory AccommodationMapDataModel.fromJson(Map<String, dynamic> json) {
    return AccommodationMapDataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      cityId: json['cityId'] as String?,
      categoryId: json['categoryId'] as String?,
      location: json['location'] != null
          ? GeoLocationMapDataModel.fromJson(json['location'])
          : null,
      address: json['address'] as String?,
      priceLevel: json['priceLevel'] as String?,
      pricePerNight: json['pricePerNight'] is int
          ? json['pricePerNight'] as int?
          : json['pricePerNight'] is double
          ? (json['pricePerNight'] as double).toInt()
          : null,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      allowsFamilies: json['allowsFamilies'] as bool?,
      maxGuests: json['maxGuests'] is int
          ? json['maxGuests'] as int?
          : json['maxGuests'] is double
          ? (json['maxGuests'] as double).toInt()
          : null,
      minimumNightsStay: json['minimumNightsStay'] is int
          ? json['minimumNightsStay'] as int?
          : json['minimumNightsStay'] is double
          ? (json['minimumNightsStay'] as double).toInt()
          : null,
      isPetFriendly: json['isPetFriendly'] as bool?,
      isWheelchairAccessible:
      json['isWheelchairAccessible'] as bool?,
      recommendationWeight: json['recommendationWeight'] is int
          ? json['recommendationWeight'] as int?
          : json['recommendationWeight'] is double
          ? (json['recommendationWeight'] as double).toInt()
          : null,
      isActive: json['isActive'] as bool?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      website: json['website'] as String?,
      phone: json['phone'] as String?,
      googleMapUrl: json['googleMapUrl'] as String?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt']?.toString(),
      category: json['category'] != null
          ? CategoryMapDataModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'cityId': cityId,
      'categoryId': categoryId,
      'location': location?.toJson(),
      'address': address,
      'priceLevel': priceLevel,
      'pricePerNight': pricePerNight,
      'amenities': amenities,
      'allowsFamilies': allowsFamilies,
      'maxGuests': maxGuests,
      'minimumNightsStay': minimumNightsStay,
      'isPetFriendly': isPetFriendly,
      'isWheelchairAccessible': isWheelchairAccessible,
      'recommendationWeight': recommendationWeight,
      'isActive': isActive,
      'images': images,
      'website': website,
      'phone': phone,
      'googleMapUrl': googleMapUrl,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'category': category?.toJson(),
    };
  }
}

class RestaurantMapDataModel {
  String? id;
  String? name;
  String? description;
  String? shortDescription;
  String? cityId;
  GeoLocationMapDataModel? location;
  String? address;
  String? priceLevel;
  dynamic averagePrice; // can be null
  List<String>? mealTypes;
  bool? isWheelchairAccessible;
  List<String>? travelStyles;
  int? recommendationWeight;
  bool? isActive;
  bool? requiresReservation;
  List<String>? images;
  String? website;
  String? phone;
  String? email;
  String? opensAt;
  String? closesAt;
  bool? reopens;
  String? reopensAt;
  String? closesAgainAt;
  WeeklyScheduleMapDataModel? weeklySchedule;
  SeasonalAvailabilityMapDataModel? seasonalAvailability;
  String? accessibilityInfo;
  String? googleMapUrl;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<CategoryMapDataModel>? categories;

  RestaurantMapDataModel({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.cityId,
    this.location,
    this.address,
    this.priceLevel,
    this.averagePrice,
    this.mealTypes,
    this.isWheelchairAccessible,
    this.travelStyles,
    this.recommendationWeight,
    this.isActive,
    this.requiresReservation,
    this.images,
    this.website,
    this.phone,
    this.email,
    this.opensAt,
    this.closesAt,
    this.reopens,
    this.reopensAt,
    this.closesAgainAt,
    this.weeklySchedule,
    this.seasonalAvailability,
    this.accessibilityInfo,
    this.googleMapUrl,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.categories,
  });

  factory RestaurantMapDataModel.fromJson(Map<String, dynamic> json) {
    return RestaurantMapDataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      cityId: json['cityId'] as String?,
      location: json['location'] != null
          ? GeoLocationMapDataModel.fromJson(json['location'])
          : null,
      address: json['address'] as String?,
      priceLevel: json['priceLevel'] as String?,
      averagePrice: json['averagePrice'],
      mealTypes: (json['mealTypes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      isWheelchairAccessible:
      json['isWheelchairAccessible'] as bool?,
      travelStyles: (json['travelStyles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      recommendationWeight: json['recommendationWeight'] is int
          ? json['recommendationWeight'] as int?
          : json['recommendationWeight'] is double
          ? (json['recommendationWeight'] as double).toInt()
          : null,
      isActive: json['isActive'] as bool?,
      requiresReservation: json['requiresReservation'] as bool?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      website: json['website'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      opensAt: json['opensAt']?.toString(),
      closesAt: json['closesAt']?.toString(),
      reopens: json['reopens'] as bool?,
      reopensAt: json['reopensAt']?.toString(),
      closesAgainAt: json['closesAgainAt']?.toString(),
      weeklySchedule: json['weeklySchedule'] != null
          ? WeeklyScheduleMapDataModel.fromJson(json['weeklySchedule'])
          : null,
      seasonalAvailability: json['seasonalAvailability'] != null
          ? SeasonalAvailabilityMapDataModel.fromJson(
        json['seasonalAvailability'],
      )
          : null,
      accessibilityInfo: json['accessibilityInfo']?.toString(),
      googleMapUrl: json['googleMapUrl'] as String?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt']?.toString(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryMapDataModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'cityId': cityId,
      'location': location?.toJson(),
      'address': address,
      'priceLevel': priceLevel,
      'averagePrice': averagePrice,
      'mealTypes': mealTypes,
      'isWheelchairAccessible': isWheelchairAccessible,
      'travelStyles': travelStyles,
      'recommendationWeight': recommendationWeight,
      'isActive': isActive,
      'requiresReservation': requiresReservation,
      'images': images,
      'website': website,
      'phone': phone,
      'email': email,
      'opensAt': opensAt,
      'closesAt': closesAt,
      'reopens': reopens,
      'reopensAt': reopensAt,
      'closesAgainAt': closesAgainAt,
      'weeklySchedule': weeklySchedule?.toJson(),
      'seasonalAvailability': seasonalAvailability?.toJson(),
      'accessibilityInfo': accessibilityInfo,
      'googleMapUrl': googleMapUrl,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'categories': categories?.map((e) => e.toJson()).toList(),
    };
  }
}

class WeeklyScheduleMapDataModel {
  DayScheduleMapDataModel? monday;
  DayScheduleMapDataModel? tuesday;
  DayScheduleMapDataModel? wednesday;
  DayScheduleMapDataModel? thursday;
  DayScheduleMapDataModel? friday;
  DayScheduleMapDataModel? saturday;
  DayScheduleMapDataModel? sunday;

  WeeklyScheduleMapDataModel({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory WeeklyScheduleMapDataModel.fromJson(Map<String, dynamic> json) {
    return WeeklyScheduleMapDataModel(
      monday: json['monday'] != null
          ? DayScheduleMapDataModel.fromJson(json['monday'])
          : null,
      tuesday: json['tuesday'] != null
          ? DayScheduleMapDataModel.fromJson(json['tuesday'])
          : null,
      wednesday: json['wednesday'] != null
          ? DayScheduleMapDataModel.fromJson(json['wednesday'])
          : null,
      thursday: json['thursday'] != null
          ? DayScheduleMapDataModel.fromJson(json['thursday'])
          : null,
      friday: json['friday'] != null
          ? DayScheduleMapDataModel.fromJson(json['friday'])
          : null,
      saturday: json['saturday'] != null
          ? DayScheduleMapDataModel.fromJson(json['saturday'])
          : null,
      sunday: json['sunday'] != null
          ? DayScheduleMapDataModel.fromJson(json['sunday'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monday': monday?.toJson(),
      'tuesday': tuesday?.toJson(),
      'wednesday': wednesday?.toJson(),
      'thursday': thursday?.toJson(),
      'friday': friday?.toJson(),
      'saturday': saturday?.toJson(),
      'sunday': sunday?.toJson(),
    };
  }
}

class DayScheduleMapDataModel {
  bool? isOpen;
  List<PeriodMapDataModel>? periods;

  DayScheduleMapDataModel({
    this.isOpen,
    this.periods,
  });

  factory DayScheduleMapDataModel.fromJson(Map<String, dynamic> json) {
    return DayScheduleMapDataModel(
      isOpen: json['isOpen'] as bool?,
      periods: (json['periods'] as List<dynamic>?)
          ?.map((e) => PeriodMapDataModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOpen': isOpen,
      'periods': periods?.map((e) => e.toJson()).toList(),
    };
  }
}

class PeriodMapDataModel {
  String? openTime;
  String? closeTime;

  PeriodMapDataModel({
    this.openTime,
    this.closeTime,
  });

  factory PeriodMapDataModel.fromJson(Map<String, dynamic> json) {
    return PeriodMapDataModel(
      openTime: json['openTime']?.toString(),
      closeTime: json['closeTime']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}

class SeasonalAvailabilityMapDataModel {
  List<String>? seasons;

  SeasonalAvailabilityMapDataModel({
    this.seasons,
  });

  factory SeasonalAvailabilityMapDataModel.fromJson(
      Map<String, dynamic> json) {
    return SeasonalAvailabilityMapDataModel(
      seasons: (json['seasons'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasons': seasons,
    };
  }
}

class FestivalMapDataModel {
  String? id;
  String? name;
  String? description;
  GeoLocationMapDataModel? location;
  String? cityId;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  bool? ticketRequired;
  bool? isActive;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  FestivalMapDataModel({
    this.id,
    this.name,
    this.description,
    this.location,
    this.cityId,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.ticketRequired,
    this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory FestivalMapDataModel.fromJson(Map<String, dynamic> json) {
    return FestivalMapDataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      location: json['location'] != null
          ? GeoLocationMapDataModel.fromJson(json['location'])
          : null,
      cityId: json['cityId'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startTime: json['startTime']?.toString(),
      endTime: json['endTime']?.toString(),
      ticketRequired: json['ticketRequired'] as bool?,
      isActive: json['isActive'] as bool?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location?.toJson(),
      'cityId': cityId,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'ticketRequired': ticketRequired,
      'isActive': isActive,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}

class FiltersMapDataModel {
  List<dynamic>? categoryIds;
  bool? appliedFilters;

  FiltersMapDataModel({
    this.categoryIds,
    this.appliedFilters,
  });

  factory FiltersMapDataModel.fromJson(Map<String, dynamic> json) {
    return FiltersMapDataModel(
      categoryIds: (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => e)
          .toList(),
      appliedFilters: json['appliedFilters'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryIds': categoryIds,
      'appliedFilters': appliedFilters,
    };
  }
}

class CategoryMapDataModel {
  String? id;
  String? name;
  String? type;
  String? description;

  CategoryMapDataModel({
    this.id,
    this.name,
    this.type,
    this.description,
  });

  factory CategoryMapDataModel.fromJson(Map<String, dynamic> json) {
    return CategoryMapDataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
    };
  }
}
