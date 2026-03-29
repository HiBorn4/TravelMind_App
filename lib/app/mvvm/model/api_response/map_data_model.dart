import 'dart:convert';

class MapDataModel {
  String? annotationId;
  String? title;
  String? address;
  String? imageUrl;
  double lat;
  double lng;
  String? categoryName;
  String? itemId; // backend ID
  String? itemType;
  String? city;
  MapDataModel({
    this.annotationId,
    this.title,
    this.address,
    this.imageUrl,
    required this.lat,
    required this.lng,
    this.categoryName,
    this.itemId,
    this.itemType,
    this.city,
  });

  MapDataModel copyWith({
    String? annotationId,
    String? title,
    String? address,
    String? imageUrl,
    double? lat,
    double? lng,
    String? categoryName,
    String? itemId,
    String? itemType,
    String? city,
  }) {
    return MapDataModel(
      annotationId: annotationId ?? this.annotationId,
      title: title ?? this.title,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      categoryName: categoryName ?? this.categoryName,
      itemId: itemId ?? this.itemId,
      itemType: itemType ?? this.itemType,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'annotationId': annotationId,
      'title': title,
      'address': address,
      'imageUrl': imageUrl,
      'lat': lat,
      'lng': lng,
      'categoryName': categoryName,
      'itemId': itemId,
      'itemType': itemType,
      'city': city,
    };
  }

  factory MapDataModel.fromMap(Map<String, dynamic> map) {
    return MapDataModel(
      annotationId: map['annotationId'],
      title: map['title'],
      address: map['address'],
      imageUrl: map['imageUrl'],
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
      categoryName: map['categoryName'],
      itemId: map['itemId'],
      itemType: map['itemType'],
      city: map['city'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MapDataModel.fromJson(String source) => MapDataModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MapDataModel(annotationId: $annotationId, title: $title, address: $address, imageUrl: $imageUrl, lat: $lat, lng: $lng, categoryName: $categoryName, itemId: $itemId, itemType: $itemType, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MapDataModel &&
      other.annotationId == annotationId &&
      other.title == title &&
      other.address == address &&
      other.imageUrl == imageUrl &&
      other.lat == lat &&
      other.lng == lng &&
      other.categoryName == categoryName &&
      other.itemId == itemId &&
      other.itemType == itemType &&
      other.city == city;
  }

  @override
  int get hashCode {
    return annotationId.hashCode ^
      title.hashCode ^
      address.hashCode ^
      imageUrl.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      categoryName.hashCode ^
      itemId.hashCode ^
      itemType.hashCode ^
      city.hashCode;
  }
}
