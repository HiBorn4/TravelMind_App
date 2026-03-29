import 'dart:convert';

import 'package:flutter/foundation.dart';

class NotificationModel {
  final bool success;
  final String message;
  final String timestamp;
  final Data data;
  NotificationModel({required this.success, required this.message, required this.timestamp, required this.data});

  NotificationModel copyWith({bool? success, String? message, String? timestamp, Data? data}) {
    return NotificationModel(
      success: success ?? this.success,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {'success': success, 'message': message, 'timestamp': timestamp, 'data': data.toMap()};
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? '',
      data: Data.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(success: $success, message: $message, timestamp: $timestamp, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
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
  final List<Notification> notifications;
  final int totalCount;
  final int unreadCount;
  Data({required this.notifications, required this.totalCount, required this.unreadCount});

  Data copyWith({List<Notification>? notifications, int? totalCount, int? unreadCount}) {
    return Data(
      notifications: notifications ?? this.notifications,
      totalCount: totalCount ?? this.totalCount,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notifications': notifications.map((x) => x.toMap()).toList(),
      'totalCount': totalCount,
      'unreadCount': unreadCount,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      notifications: List<Notification>.from(map['notifications']?.map((x) => Notification.fromMap(x))),
      totalCount: map['totalCount']?.toInt() ?? 0,
      unreadCount: map['unreadCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source));

  @override
  String toString() => 'Data(notifications: $notifications, totalCount: $totalCount, unreadCount: $unreadCount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Data &&
        listEquals(other.notifications, notifications) &&
        other.totalCount == totalCount &&
        other.unreadCount == unreadCount;
  }

  @override
  int get hashCode => notifications.hashCode ^ totalCount.hashCode ^ unreadCount.hashCode;
}

class Notification {
  final String id;
  final String userId;
  final String? itineraryId;
  final String type;
  final String message;
  final bool isRead;
  final String sentAt;
  final String createdAt;
  final String updatedAt;
  final Itinerary? itinerary;
  Notification({
    required this.id,
    required this.userId,
    this.itineraryId,
    required this.type,
    required this.message,
    required this.isRead,
    required this.sentAt,
    required this.createdAt,
    required this.updatedAt,
    this.itinerary,
  });

  Notification copyWith({
    String? id,
    String? userId,
    String? itineraryId,
    String? type,
    String? message,
    bool? isRead,
    String? sentAt,
    String? createdAt,
    String? updatedAt,
    Itinerary? itinerary,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itineraryId: itineraryId ?? this.itineraryId,
      type: type ?? this.type,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      sentAt: sentAt ?? this.sentAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      itinerary: itinerary ?? this.itinerary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'itineraryId': itineraryId,
      'type': type,
      'message': message,
      'isRead': isRead,
      'sentAt': sentAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'itinerary': itinerary?.toMap(),
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      itineraryId: map['itineraryId'],
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      isRead: map['isRead'] ?? false,
      sentAt: map['sentAt'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      itinerary: map['itinerary'] != null ? Itinerary.fromMap(map['itinerary']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) => Notification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Notification(id: $id, userId: $userId, itineraryId: $itineraryId, type: $type, message: $message, isRead: $isRead, sentAt: $sentAt, createdAt: $createdAt, updatedAt: $updatedAt, itinerary: $itinerary)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notification &&
        other.id == id &&
        other.userId == userId &&
        other.itineraryId == itineraryId &&
        other.type == type &&
        other.message == message &&
        other.isRead == isRead &&
        other.sentAt == sentAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.itinerary == itinerary;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        itineraryId.hashCode ^
        type.hashCode ^
        message.hashCode ^
        isRead.hashCode ^
        sentAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        itinerary.hashCode;
  }
}

class Itinerary {
  final String id;
  final String startDate;
  final String endDate;
  final String? cityId;
  final City? city;
  final List<String>? image;
  Itinerary({
    required this.id,
    required this.startDate,
    required this.endDate,
    this.cityId,
    this.city,
    this.image,
  });

  Itinerary copyWith({String? id, String? startDate, String? endDate, String? cityId, City? city}) {
    return Itinerary(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cityId: cityId ?? this.cityId,
      city: city ?? this.city,
      image: image ?? image,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'startDate': startDate, 'endDate': endDate, 'cityId': cityId, 'city': city?.toMap()};
  }

  factory Itinerary.fromMap(Map<String, dynamic> map) {
    return Itinerary(
      id: map['id'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      cityId: map['cityId'],
      city: map['city'] != null ? City.fromMap(map['city']) : null,
      image: map['image'] != null ? List<String>.from(map['image']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Itinerary.fromJson(String source) => Itinerary.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Itinerary(id: $id, startDate: $startDate, endDate: $endDate, cityId: $cityId, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Itinerary &&
        other.id == id &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.cityId == cityId &&
        other.city == city;
  }

  @override
  int get hashCode {
    return id.hashCode ^ startDate.hashCode ^ endDate.hashCode ^ cityId.hashCode ^ city.hashCode;
  }
}

class City {
  final String id;
  final String name;
  final String country;
  City({required this.id, required this.name, required this.country});

  City copyWith({String? id, String? name, String? country}) {
    return City(id: id ?? this.id, name: name ?? this.name, country: country ?? this.country);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'country': country};
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(id: map['id'] ?? '', name: map['name'] ?? '', country: map['country'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) => City.fromMap(json.decode(source));

  @override
  String toString() => 'City(id: $id, name: $name, country: $country)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is City && other.id == id && other.name == name && other.country == country;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ country.hashCode;
}
