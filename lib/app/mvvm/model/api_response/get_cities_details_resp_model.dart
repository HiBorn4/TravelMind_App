import 'dart:convert';

GetCitiesDetailFResponseModel getCitiesDetailFResponseModelFromJson(String str) =>
    GetCitiesDetailFResponseModel.fromJson(json.decode(str));

String getCitiesDetailFResponseModelToJson(GetCitiesDetailFResponseModel data) => json.encode(data.toJson());

class GetCitiesDetailFResponseModel {
  final String? type;
  final AttractionItem? item;
  final List<SimilarItem>? similarItems;

  GetCitiesDetailFResponseModel({this.type, this.item, this.similarItems});

  factory GetCitiesDetailFResponseModel.fromJson(Map<String, dynamic> json) => GetCitiesDetailFResponseModel(
    type: json["type"],
    item: json["item"] == null ? null : AttractionItem.fromJson(json["item"]),
    similarItems: json["similarItems"] == null
        ? []
        : List<SimilarItem>.from(json["similarItems"].map((x) => SimilarItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "item": item?.toJson(),
    "similarItems": similarItems == null ? [] : List<dynamic>.from(similarItems!.map((x) => x.toJson())),
  };
}

class AttractionItem {
  final String? id;
  final String? name;
  final String? description;
  final String? shortDescription;
  final List<String>? images;
  final Location? location;
  final String? address;
  final String? priceLevel;
  final bool? isWheelchairAccessible;
  final bool? isActive;
  final int? durationMinutes;
  final List<String>? availableSeasons;
  final List<String>? travelStyles;
  final List<String>? amenities;
  final String? priceRange;
  final String? googleMapUrl;
  final String? phone;
  final int? recommendationWeight;
  bool? isFavoritedByMe;
  final Category? category;
  final City? city;
  final String? createdAt;
  final dynamic weeklySchedule;
  final String? updatedAt;

  AttractionItem({
    this.id,
    this.name,
    this.description,
    this.amenities,
    this.shortDescription,
    this.images,
    this.location,
    this.isFavoritedByMe,
    this.address,
    this.priceLevel,
    this.weeklySchedule,
    this.isWheelchairAccessible,
    this.isActive,
    this.durationMinutes,
    this.availableSeasons,
    this.travelStyles,
    this.priceRange,
    this.googleMapUrl,
    this.phone,
    this.recommendationWeight,
    this.category,
    this.city,
    this.createdAt,
    this.updatedAt,
  });

  factory AttractionItem.fromJson(Map<String, dynamic> json) => AttractionItem(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    shortDescription: json["shortDescription"],
    images: json["images"] == null ? [] : List<String>.from(json["images"].map((x) => x)),
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    address: json["address"],
    priceLevel: json["priceLevel"],
    isFavoritedByMe: json["isFavoritedByMe"] ?? false,
    isWheelchairAccessible: json["isWheelchairAccessible"],
    isActive: json["isActive"],
    durationMinutes: json["durationMinutes"],
    availableSeasons: json["availableSeasons"] == null ? [] : List<String>.from(json["availableSeasons"].map((x) => x)),
    travelStyles: json["travelStyles"] == null ? [] : List<String>.from(json["travelStyles"].map((x) => x)),
    priceRange: json["priceRange"],
    weeklySchedule: json["weeklySchedule"],
    googleMapUrl: json["googleMapUrl"],
    amenities: json["amenities"] == null ? [] : List<String>.from(json["amenities"].map((x) => x)),
    phone: json["phone"],
    recommendationWeight: json["recommendationWeight"],
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    city: json["city"] == null ? null : City.fromJson(json["city"]),
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "shortDescription": shortDescription,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "location": location?.toJson(),
    "address": address,
    "priceLevel": priceLevel,
    "isFavoritedByMe": isFavoritedByMe,
    "amenities": amenities == null ? [] : List<dynamic>.from(amenities!.map((x) => x)),
    "isWheelchairAccessible": isWheelchairAccessible,
    "isActive": isActive,
    "weeklySchedule": weeklySchedule,
    "durationMinutes": durationMinutes,
    "availableSeasons": availableSeasons == null ? [] : List<dynamic>.from(availableSeasons!.map((x) => x)),
    "travelStyles": travelStyles == null ? [] : List<dynamic>.from(travelStyles!.map((x) => x)),
    "priceRange": priceRange,
    "googleMapUrl": googleMapUrl,
    "phone": phone,
    "recommendationWeight": recommendationWeight,
    "category": category?.toJson(),
    "city": city?.toJson(),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class Category {
  final String? id;
  final String? name;
  final String? description;
  final String? type;

  Category({this.id, this.name, this.description, this.type});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json["id"], name: json["name"], description: json["description"], type: json["type"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "description": description, "type": type};
}

class City {
  final String? id;
  final String? name;
  final String? country;
  final List<String>? image;
  final String? description;

  City({this.id, this.name, this.country, this.image, this.description});

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    country: json["country"],
    image: json["image"] == null ? [] : List<String>.from(json["image"].map((x) => x)),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country": country,
    "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
    "description": description,
  };
}

class Location {
  final Crs? crs;
  final String? type;
  final List<double>? coordinates;

  Location({this.crs, this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    crs: json["crs"] == null ? null : Crs.fromJson(json["crs"]),
    type: json["type"],
    coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "crs": crs?.toJson(),
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class Crs {
  final String? type;
  final CrsProperties? properties;

  Crs({this.type, this.properties});

  factory Crs.fromJson(Map<String, dynamic> json) => Crs(
    type: json["type"],
    properties: json["properties"] == null ? null : CrsProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {"type": type, "properties": properties?.toJson()};
}

class CrsProperties {
  final String? name;

  CrsProperties({this.name});

  factory CrsProperties.fromJson(Map<String, dynamic> json) => CrsProperties(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

class SimilarItem {
  final String? id;
  final String? name;
  final String? shortDescription;
  final List<String>? images;
  final Location? location;
  final String? priceLevel;
  final int? durationMinutes;
  final Category? category;

  SimilarItem({
    this.id,
    this.name,
    this.shortDescription,
    this.images,
    this.location,
    this.priceLevel,
    this.durationMinutes,
    this.category,
  });

  factory SimilarItem.fromJson(Map<String, dynamic> json) => SimilarItem(
    id: json["id"],
    name: json["name"],
    shortDescription: json["shortDescription"],
    images: json["images"] == null ? [] : List<String>.from(json["images"].map((x) => x)),
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    priceLevel: json["priceLevel"],
    durationMinutes: json["durationMinutes"],
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "shortDescription": shortDescription,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "location": location?.toJson(),
    "priceLevel": priceLevel,
    "durationMinutes": durationMinutes,
    "category": category?.toJson(),
  };
}
