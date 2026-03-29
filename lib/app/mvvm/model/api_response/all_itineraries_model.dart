import 'dart:convert';

import 'package:flutter/foundation.dart';

class AllItineraryModel {
  final bool success;
  final String message;
  final String timestamp;
  final Data data;
  AllItineraryModel({
    required this.success,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  AllItineraryModel copyWith({
    bool? success,
    String? message,
    String? timestamp,
    Data? data,
  }) {
    return AllItineraryModel(
      success: success ?? this.success,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'timestamp': timestamp,
      'data': data.toMap(),
    };
  }

  factory AllItineraryModel.fromMap(Map<String, dynamic> map) {
    return AllItineraryModel(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? '',
      data: Data.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AllItineraryModel.fromJson(String source) => AllItineraryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AllItineraryModel(success: $success, message: $message, timestamp: $timestamp, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AllItineraryModel &&
      other.success == success &&
      other.message == message &&
      other.timestamp == timestamp &&
      other.data == data;
  }

  @override
  int get hashCode {
    return success.hashCode ^
      message.hashCode ^
      timestamp.hashCode ^
      data.hashCode;
  }
}

class Data {
  final List<LastTripCitie> lastTripCities;
  final int totalCount;
  Data({
    required this.lastTripCities,
    required this.totalCount,
  });

  Data copyWith({
    List<LastTripCitie>? lastTripCities,
    int? totalCount,
  }) {
    return Data(
      lastTripCities: lastTripCities ?? this.lastTripCities,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastTripCities': lastTripCities.map((x) => x.toMap()).toList(),
      'totalCount': totalCount,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      lastTripCities: List<LastTripCitie>.from(map['lastTripCities']?.map((x) => LastTripCitie.fromMap(x))),
      totalCount: map['totalCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source));

  @override
  String toString() => 'Data(lastTripCities: $lastTripCities, totalCount: $totalCount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Data &&
      listEquals(other.lastTripCities, lastTripCities) &&
      other.totalCount == totalCount;
  }

  @override
  int get hashCode => lastTripCities.hashCode ^ totalCount.hashCode;
}

class LastTripCitie {
  final String id;
  final String startDate;
  final String endDate;
  final String budget;
  final String travelStyle;
  final int numberOfTravelers;
  final String createdAt;
  final String updatedAt;
  final bool isFavoritedByMe;
  final City city;
  LastTripCitie({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.travelStyle,
    required this.numberOfTravelers,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavoritedByMe,
    required this.city,
  });

  LastTripCitie copyWith({
    String? id,
    String? startDate,
    String? endDate,
    String? budget,
    String? travelStyle,
    int? numberOfTravelers,
    String? createdAt,
    String? updatedAt,
    bool? isFavoritedByMe,
    City? city,
  }) {
    return LastTripCitie(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      travelStyle: travelStyle ?? this.travelStyle,
      numberOfTravelers: numberOfTravelers ?? this.numberOfTravelers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavoritedByMe: isFavoritedByMe ?? this.isFavoritedByMe,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDate': startDate,
      'endDate': endDate,
      'budget': budget,
      'travelStyle': travelStyle,
      'numberOfTravelers': numberOfTravelers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isFavoritedByMe': isFavoritedByMe,
      'city': city.toMap(),
    };
  }

  factory LastTripCitie.fromMap(Map<String, dynamic> map) {
    return LastTripCitie(
      id: map['id'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      budget: map['budget'] ?? '',
      travelStyle: map['travelStyle'] ?? '',
      numberOfTravelers: map['numberOfTravelers']?.toInt() ?? 0,
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      isFavoritedByMe: map['isFavoritedByMe'] ?? false,
      city: City.fromMap(map['city']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LastTripCitie.fromJson(String source) => LastTripCitie.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LastTripCitie(id: $id, startDate: $startDate, endDate: $endDate, budget: $budget, travelStyle: $travelStyle, numberOfTravelers: $numberOfTravelers, createdAt: $createdAt, updatedAt: $updatedAt, isFavoritedByMe: $isFavoritedByMe, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LastTripCitie &&
      other.id == id &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.budget == budget &&
      other.travelStyle == travelStyle &&
      other.numberOfTravelers == numberOfTravelers &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.isFavoritedByMe == isFavoritedByMe &&
      other.city == city;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      budget.hashCode ^
      travelStyle.hashCode ^
      numberOfTravelers.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isFavoritedByMe.hashCode ^
      city.hashCode;
  }
}

class City {
  final String id;
  final String name;
  final String country;
  final String description;
  final List<String> image;
  final Location location;
  final String timezone;
  final String language;
  final CityStats cityStats;
  City({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.image,
    required this.location,
    required this.timezone,
    required this.language,
    required this.cityStats,
  });

  City copyWith({
    String? id,
    String? name,
    String? country,
    String? description,
    List<String>? image,
    Location? location,
    String? timezone,
    String? language,
    CityStats? cityStats,
  }) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      description: description ?? this.description,
      image: image ?? this.image,
      location: location ?? this.location,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      cityStats: cityStats ?? this.cityStats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'image': image,
      'location': location.toMap(),
      'timezone': timezone,
      'language': language,
      'cityStats': cityStats.toMap(),
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      description: map['description'] ?? '',
      image: List<String>.from(map['image']),
      location: Location.fromMap(map['location']),
      timezone: map['timezone'] ?? '',
      language: map['language'] ?? '',
      cityStats: CityStats.fromMap(map['cityStats']),
    );
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) => City.fromMap(json.decode(source));

  @override
  String toString() {
    return 'City(id: $id, name: $name, country: $country, description: $description, image: $image, location: $location, timezone: $timezone, language: $language, cityStats: $cityStats)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is City &&
      other.id == id &&
      other.name == name &&
      other.country == country &&
      other.description == description &&
      listEquals(other.image, image) &&
      other.location == location &&
      other.timezone == timezone &&
      other.language == language &&
      other.cityStats == cityStats;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      country.hashCode ^
      description.hashCode ^
      image.hashCode ^
      location.hashCode ^
      timezone.hashCode ^
      language.hashCode ^
      cityStats.hashCode;
  }
}

class Location {
  final Crs crs;
  final String type;
  final List<double> coordinates;
  Location({
    required this.crs,
    required this.type,
    required this.coordinates,
  });

  Location copyWith({
    Crs? crs,
    String? type,
    List<double>? coordinates,
  }) {
    return Location(
      crs: crs ?? this.crs,
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'crs': crs.toMap(),
      'type': type,
      'coordinates': coordinates,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      crs: Crs.fromMap(map['crs']),
      type: map['type'] ?? '',
      coordinates: List<double>.from(map['coordinates']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source));

  @override
  String toString() => 'Location(crs: $crs, type: $type, coordinates: $coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Location &&
      other.crs == crs &&
      other.type == type &&
      listEquals(other.coordinates, coordinates);
  }

  @override
  int get hashCode => crs.hashCode ^ type.hashCode ^ coordinates.hashCode;
}

class Crs {
  final String type;
  final Properties properties;
  Crs({
    required this.type,
    required this.properties,
  });

  Crs copyWith({
    String? type,
    Properties? properties,
  }) {
    return Crs(
      type: type ?? this.type,
      properties: properties ?? this.properties,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'properties': properties.toMap(),
    };
  }

  factory Crs.fromMap(Map<String, dynamic> map) {
    return Crs(
      type: map['type'] ?? '',
      properties: Properties.fromMap(map['properties']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Crs.fromJson(String source) => Crs.fromMap(json.decode(source));

  @override
  String toString() => 'Crs(type: $type, properties: $properties)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Crs &&
      other.type == type &&
      other.properties == properties;
  }

  @override
  int get hashCode => type.hashCode ^ properties.hashCode;
}

class Properties {
  final String name;
  Properties({
    required this.name,
  });

  Properties copyWith({
    String? name,
  }) {
    return Properties(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Properties.fromMap(Map<String, dynamic> map) {
    return Properties(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Properties.fromJson(String source) => Properties.fromMap(json.decode(source));

  @override
  String toString() => 'Properties(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Properties &&
      other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class CityStats {
  final int totalAttractions;
  final int totalRestaurants;
  final int totalAccommodations;
  CityStats({
    required this.totalAttractions,
    required this.totalRestaurants,
    required this.totalAccommodations,
  });

  CityStats copyWith({
    int? totalAttractions,
    int? totalRestaurants,
    int? totalAccommodations,
  }) {
    return CityStats(
      totalAttractions: totalAttractions ?? this.totalAttractions,
      totalRestaurants: totalRestaurants ?? this.totalRestaurants,
      totalAccommodations: totalAccommodations ?? this.totalAccommodations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalAttractions': totalAttractions,
      'totalRestaurants': totalRestaurants,
      'totalAccommodations': totalAccommodations,
    };
  }

  factory CityStats.fromMap(Map<String, dynamic> map) {
    return CityStats(
      totalAttractions: map['totalAttractions']?.toInt() ?? 0,
      totalRestaurants: map['totalRestaurants']?.toInt() ?? 0,
      totalAccommodations: map['totalAccommodations']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CityStats.fromJson(String source) => CityStats.fromMap(json.decode(source));

  @override
  String toString() => 'CityStats(totalAttractions: $totalAttractions, totalRestaurants: $totalRestaurants, totalAccommodations: $totalAccommodations)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CityStats &&
      other.totalAttractions == totalAttractions &&
      other.totalRestaurants == totalRestaurants &&
      other.totalAccommodations == totalAccommodations;
  }

  @override
  int get hashCode => totalAttractions.hashCode ^ totalRestaurants.hashCode ^ totalAccommodations.hashCode;
}