class AccommodationInterestData {
  List<AccommodationCategory>? categories;
  Map<String, List<AccommodationCategory>>? categoriesByType;
  int? totalCount;

  AccommodationInterestData({this.categories, this.categoriesByType, this.totalCount});

  AccommodationInterestData.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = List<AccommodationCategory>.from(json['categories'].map((x) => AccommodationCategory.fromJson(x)));
    }

    if (json['categoriesByType'] != null) {
      categoriesByType = {};
      (json['categoriesByType'] as Map<String, dynamic>).forEach((key, value) {
        categoriesByType![key] = List<AccommodationCategory>.from(value.map((x) => AccommodationCategory.fromJson(x)));
      });
    }

    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (categories != null) {
      map['categories'] = categories!.map((x) => x.toJson()).toList();
    }
    if (categoriesByType != null) {
      map['categoriesByType'] = categoriesByType!.map(
        (key, value) => MapEntry(key, value.map((x) => x.toJson()).toList()),
      );
    }
    map['totalCount'] = totalCount;
    return map;
  }

  /// ✅ Helper getter: safely fetch categories by type
  List<AccommodationCategory> getByType(String type) {
    if (categoriesByType == null) return [];
    return categoriesByType?[type.toLowerCase()] ?? [];
  }
}

class AccommodationCategory {
  String? id;
  String? name;
  String? description;
  String? type;
  String? createdAt;

  AccommodationCategory({this.id, this.name, this.description, this.type, this.createdAt});

  AccommodationCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['type'] = type;
    map['createdAt'] = createdAt;
    return map;
  }
}
