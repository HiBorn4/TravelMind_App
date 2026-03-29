import 'dart:convert';

import 'package:flutter/foundation.dart';

class FavouriteModel {
  final bool success;
  final String message;
  final String timestamp;
  final Data? data;
  FavouriteModel({required this.success, required this.message, required this.timestamp, required this.data});

  FavouriteModel copyWith({bool? success, String? message, String? timestamp, Data? data}) {
    return FavouriteModel(
      success: success ?? this.success,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {'success': success, 'message': message, 'timestamp': timestamp, 'data': data?.toMap()};
  }

  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    return FavouriteModel(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? '',
      data: Data.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteModel.fromJson(String source) => FavouriteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FavouriteModel(success: $success, message: $message, timestamp: $timestamp, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavouriteModel &&
        other.success == success &&
        other.message == message &&
        other.timestamp == timestamp &&
        other.data == data;
  }

  @override
  int get hashCode {
    return success.hashCode ^ message.hashCode ^ timestamp.hashCode ^ data.hashCode;
  }
}

class Data {
  final Favorites favorites;
  Data({required this.favorites});

  Data copyWith({Favorites? favorites}) {
    return Data(favorites: favorites ?? this.favorites);
  }

  Map<String, dynamic> toMap() {
    return {'favorites': favorites.toMap()};
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(favorites: Favorites.fromMap(map['favorites']));
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source));

  @override
  String toString() => 'Data(favorites: $favorites)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Data && other.favorites == favorites;
  }

  @override
  int get hashCode => favorites.hashCode;
}

class Favorites {
  final List<Attraction> attractions;
  final List<Restaurant> restaurants;
  final List<Accommodation> accommodations;
  final List<dynamic> itineraries;
  Favorites({
    required this.attractions,
    required this.restaurants,
    required this.accommodations,
    required this.itineraries,
  });

  Favorites copyWith({
    List<Attraction>? attractions,
    List<Restaurant>? restaurants,
    List<Accommodation>? accommodations,
    List<dynamic>? itineraries,
  }) {
    return Favorites(
      attractions: attractions ?? this.attractions,
      restaurants: restaurants ?? this.restaurants,
      accommodations: accommodations ?? this.accommodations,
      itineraries: itineraries ?? this.itineraries,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'attractions': attractions.map((x) => x.toMap()).toList(),
      'restaurants': restaurants.map((x) => x.toMap()).toList(),
      'accommodations': accommodations.map((x) => x.toMap()).toList(),
      'itineraries': itineraries,
    };
  }

  factory Favorites.fromMap(Map<String, dynamic> map) {
    return Favorites(
      attractions: List<Attraction>.from(map['attractions']?.map((x) => Attraction.fromMap(x))),
      restaurants: List<Restaurant>.from(map['restaurants']?.map((x) => Restaurant.fromMap(x))),
      accommodations: List<Accommodation>.from(map['accommodations']?.map((x) => Accommodation.fromMap(x))),
      itineraries: List<dynamic>.from(map['itineraries']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Favorites.fromJson(String source) => Favorites.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Favorites(attractions: $attractions, restaurants: $restaurants, accommodations: $accommodations, itineraries: $itineraries)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Favorites &&
        listEquals(other.attractions, attractions) &&
        listEquals(other.restaurants, restaurants) &&
        listEquals(other.accommodations, accommodations) &&
        listEquals(other.itineraries, itineraries);
  }

  @override
  int get hashCode {
    return attractions.hashCode ^ restaurants.hashCode ^ accommodations.hashCode ^ itineraries.hashCode;
  }
}

class Attraction {
  final String favoriteId;
  final String createdAt;
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final String cityId;
  final String address;
  final Location location;
  final String priceLevel;
  final String priceRange;
  final int durationMinutes;
  final List<String> images;
  Attraction({
    required this.favoriteId,
    required this.createdAt,
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.cityId,
    required this.address,
    required this.location,
    required this.priceLevel,
    required this.priceRange,
    required this.durationMinutes,
    required this.images,
  });

  Attraction copyWith({
    String? favoriteId,
    String? createdAt,
    String? id,
    String? name,
    String? description,
    String? shortDescription,
    String? cityId,
    String? address,
    Location? location,
    String? priceLevel,
    String? priceRange,
    int? durationMinutes,
    List<String>? images,
  }) {
    return Attraction(
      favoriteId: favoriteId ?? this.favoriteId,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      cityId: cityId ?? this.cityId,
      address: address ?? this.address,
      location: location ?? this.location,
      priceLevel: priceLevel ?? this.priceLevel,
      priceRange: priceRange ?? this.priceRange,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'favoriteId': favoriteId,
      'createdAt': createdAt,
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'cityId': cityId,
      'address': address,
      'location': location.toMap(),
      'priceLevel': priceLevel,
      'priceRange': priceRange,
      'durationMinutes': durationMinutes,
      'images': images,
    };
  }

  factory Attraction.fromMap(Map<String, dynamic> map) {
    return Attraction(
      favoriteId: map['favoriteId'] ?? '',
      createdAt: map['createdAt'] ?? '',
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      cityId: map['cityId'] ?? '',
      address: map['address'] ?? '',
      location: Location.fromMap(map['location']),
      priceLevel: map['priceLevel'] ?? '',
      priceRange: map['priceRange'] ?? '',
      durationMinutes: map['durationMinutes']?.toInt() ?? 0,
      images: List<String>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Attraction.fromJson(String source) => Attraction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Attraction(favoriteId: $favoriteId, createdAt: $createdAt, id: $id, name: $name, description: $description, shortDescription: $shortDescription, cityId: $cityId, address: $address, location: $location, priceLevel: $priceLevel, priceRange: $priceRange, durationMinutes: $durationMinutes, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attraction &&
        other.favoriteId == favoriteId &&
        other.createdAt == createdAt &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.shortDescription == shortDescription &&
        other.cityId == cityId &&
        other.address == address &&
        other.location == location &&
        other.priceLevel == priceLevel &&
        other.priceRange == priceRange &&
        other.durationMinutes == durationMinutes &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return favoriteId.hashCode ^
        createdAt.hashCode ^
        id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        shortDescription.hashCode ^
        cityId.hashCode ^
        address.hashCode ^
        location.hashCode ^
        priceLevel.hashCode ^
        priceRange.hashCode ^
        durationMinutes.hashCode ^
        images.hashCode;
  }
}

class Location {
  final Crs crs;
  final String type;
  final List<double> coordinates;
  Location({required this.crs, required this.type, required this.coordinates});

  Location copyWith({Crs? crs, String? type, List<double>? coordinates}) {
    return Location(crs: crs ?? this.crs, type: type ?? this.type, coordinates: coordinates ?? this.coordinates);
  }

  Map<String, dynamic> toMap() {
    return {'crs': crs.toMap(), 'type': type, 'coordinates': coordinates};
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

    return other is Location && other.crs == crs && other.type == type && listEquals(other.coordinates, coordinates);
  }

  @override
  int get hashCode => crs.hashCode ^ type.hashCode ^ coordinates.hashCode;
}

class Crs {
  final String type;
  final Properties properties;
  Crs({required this.type, required this.properties});

  Crs copyWith({String? type, Properties? properties}) {
    return Crs(type: type ?? this.type, properties: properties ?? this.properties);
  }

  Map<String, dynamic> toMap() {
    return {'type': type, 'properties': properties.toMap()};
  }

  factory Crs.fromMap(Map<String, dynamic> map) {
    return Crs(type: map['type'] ?? '', properties: Properties.fromMap(map['properties']));
  }

  String toJson() => json.encode(toMap());

  factory Crs.fromJson(String source) => Crs.fromMap(json.decode(source));

  @override
  String toString() => 'Crs(type: $type, properties: $properties)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Crs && other.type == type && other.properties == properties;
  }

  @override
  int get hashCode => type.hashCode ^ properties.hashCode;
}

class Properties {
  final String name;
  Properties({required this.name});

  Properties copyWith({String? name}) {
    return Properties(name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory Properties.fromMap(Map<String, dynamic> map) {
    return Properties(name: map['name'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Properties.fromJson(String source) => Properties.fromMap(json.decode(source));

  @override
  String toString() => 'Properties(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Properties && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class Restaurant {
  final String favoriteId;
  final String createdAt;
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final String cityId;
  final String address;
  final Location location;
  final String priceLevel;
  final String averagePrice;
  final List<String> mealTypes;
  final List<String> images;
  final bool requiresReservation;
  Restaurant({
    required this.favoriteId,
    required this.createdAt,
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.cityId,
    required this.address,
    required this.location,
    required this.priceLevel,
    required this.averagePrice,
    required this.mealTypes,
    required this.images,
    required this.requiresReservation,
  });

  Restaurant copyWith({
    String? favoriteId,
    String? createdAt,
    String? id,
    String? name,
    String? description,
    String? shortDescription,
    String? cityId,
    String? address,
    Location? location,
    String? priceLevel,
    String? averagePrice,
    List<String>? mealTypes,
    List<String>? images,
    bool? requiresReservation,
  }) {
    return Restaurant(
      favoriteId: favoriteId ?? this.favoriteId,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      cityId: cityId ?? this.cityId,
      address: address ?? this.address,
      location: location ?? this.location,
      priceLevel: priceLevel ?? this.priceLevel,
      averagePrice: averagePrice ?? this.averagePrice,
      mealTypes: mealTypes ?? this.mealTypes,
      images: images ?? this.images,
      requiresReservation: requiresReservation ?? this.requiresReservation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'favoriteId': favoriteId,
      'createdAt': createdAt,
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'cityId': cityId,
      'address': address,
      'location': location.toMap(),
      'priceLevel': priceLevel,
      'averagePrice': averagePrice,
      'mealTypes': mealTypes,
      'images': images,
      'requiresReservation': requiresReservation,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      favoriteId: map['favoriteId'] ?? '',
      createdAt: map['createdAt'] ?? '',
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      cityId: map['cityId'] ?? '',
      address: map['address'] ?? '',
      location: Location.fromMap(map['location']),
      priceLevel: map['priceLevel'] ?? '',
      averagePrice: map['averagePrice'] ?? '',
      mealTypes: List<String>.from(map['mealTypes']),
      images: List<String>.from(map['images']),
      requiresReservation: map['requiresReservation'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Restaurant.fromJson(String source) => Restaurant.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Restaurant(favoriteId: $favoriteId, createdAt: $createdAt, id: $id, name: $name, description: $description, shortDescription: $shortDescription, cityId: $cityId, address: $address, location: $location, priceLevel: $priceLevel, averagePrice: $averagePrice, mealTypes: $mealTypes, images: $images, requiresReservation: $requiresReservation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Restaurant &&
        other.favoriteId == favoriteId &&
        other.createdAt == createdAt &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.shortDescription == shortDescription &&
        other.cityId == cityId &&
        other.address == address &&
        other.location == location &&
        other.priceLevel == priceLevel &&
        other.averagePrice == averagePrice &&
        listEquals(other.mealTypes, mealTypes) &&
        listEquals(other.images, images) &&
        other.requiresReservation == requiresReservation;
  }

  @override
  int get hashCode {
    return favoriteId.hashCode ^
        createdAt.hashCode ^
        id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        shortDescription.hashCode ^
        cityId.hashCode ^
        address.hashCode ^
        location.hashCode ^
        priceLevel.hashCode ^
        averagePrice.hashCode ^
        mealTypes.hashCode ^
        images.hashCode ^
        requiresReservation.hashCode;
  }
}

class Accommodation {
  final String favoriteId;
  final String createdAt;
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final String cityId;
  final String address;
  final Location location;
  final String priceLevel;
  final int pricePerNight;
  final List<String> amenities;
  final int maxGuests;
  final List<String> images;
  Accommodation({
    required this.favoriteId,
    required this.createdAt,
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.cityId,
    required this.address,
    required this.location,
    required this.priceLevel,
    required this.pricePerNight,
    required this.amenities,
    required this.maxGuests,
    required this.images,
  });

  Accommodation copyWith({
    String? favoriteId,
    String? createdAt,
    String? id,
    String? name,
    String? description,
    String? shortDescription,
    String? cityId,
    String? address,
    Location? location,
    String? priceLevel,
    int? pricePerNight,
    List<String>? amenities,
    int? maxGuests,
    List<String>? images,
  }) {
    return Accommodation(
      favoriteId: favoriteId ?? this.favoriteId,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      cityId: cityId ?? this.cityId,
      address: address ?? this.address,
      location: location ?? this.location,
      priceLevel: priceLevel ?? this.priceLevel,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      amenities: amenities ?? this.amenities,
      maxGuests: maxGuests ?? this.maxGuests,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'favoriteId': favoriteId,
      'createdAt': createdAt,
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'cityId': cityId,
      'address': address,
      'location': location.toMap(),
      'priceLevel': priceLevel,
      'pricePerNight': pricePerNight,
      'amenities': amenities,
      'maxGuests': maxGuests,
      'images': images,
    };
  }

  factory Accommodation.fromMap(Map<String, dynamic> map) {
    return Accommodation(
      favoriteId: map['favoriteId'] ?? '',
      createdAt: map['createdAt'] ?? '',
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      cityId: map['cityId'] ?? '',
      address: map['address'] ?? '',
      location: Location.fromMap(map['location']),
      priceLevel: map['priceLevel'] ?? '',
      pricePerNight: map['pricePerNight']?.toInt() ?? 0,
      amenities: List<String>.from(map['amenities']),
      maxGuests: map['maxGuests']?.toInt() ?? 0,
      images: List<String>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Accommodation.fromJson(String source) => Accommodation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Accommodation(favoriteId: $favoriteId, createdAt: $createdAt, id: $id, name: $name, description: $description, shortDescription: $shortDescription, cityId: $cityId, address: $address, location: $location, priceLevel: $priceLevel, pricePerNight: $pricePerNight, amenities: $amenities, maxGuests: $maxGuests, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Accommodation &&
        other.favoriteId == favoriteId &&
        other.createdAt == createdAt &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.shortDescription == shortDescription &&
        other.cityId == cityId &&
        other.address == address &&
        other.location == location &&
        other.priceLevel == priceLevel &&
        other.pricePerNight == pricePerNight &&
        listEquals(other.amenities, amenities) &&
        other.maxGuests == maxGuests &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return favoriteId.hashCode ^
        createdAt.hashCode ^
        id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        shortDescription.hashCode ^
        cityId.hashCode ^
        address.hashCode ^
        location.hashCode ^
        priceLevel.hashCode ^
        pricePerNight.hashCode ^
        amenities.hashCode ^
        maxGuests.hashCode ^
        images.hashCode;
  }
}
