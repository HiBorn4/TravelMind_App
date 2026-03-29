// citests_categories_repo_model.dart

/// Root response model
library;

/// Data wrapper
class CitestsCategoriesDataModel {
  final List<CategoryModel>? categories;
  final Map<String, List<CategoryModel>>? categoriesByType;
  final int? totalCount;

  CitestsCategoriesDataModel({this.categories, this.categoriesByType, this.totalCount});

  factory CitestsCategoriesDataModel.fromJson(Map<String, dynamic> json) {
    // parse categories list
    final categoriesJson = json['categories'] as List<dynamic>?;
    final categories = categoriesJson?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();

    // parse categoriesByType map -> Map<String, List<CategoryModel>>
    Map<String, List<CategoryModel>>? categoriesByType;
    if (json['categoriesByType'] != null && json['categoriesByType'] is Map<String, dynamic>) {
      categoriesByType = <String, List<CategoryModel>>{};
      (json['categoriesByType'] as Map<String, dynamic>).forEach((key, value) {
        if (value is List) {
          categoriesByType![key] = value.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          categoriesByType![key] = [];
        }
      });
    }

    return CitestsCategoriesDataModel(
      categories: categories,
      categoriesByType: categoriesByType,
      totalCount: json['totalCount'] is int
          ? json['totalCount'] as int
          : (json['totalCount'] != null ? int.tryParse(json['totalCount'].toString()) : null),
    );
  }

  Map<String, dynamic> toJson() => {
    'categories': categories?.map((e) => e.toJson()).toList(),
    'categoriesByType': categoriesByType?.map((k, v) => MapEntry(k, v.map((cat) => cat.toJson()).toList())),
    'totalCount': totalCount,
  };
}

/// Category item
class CategoryModel {
  final String? id;
  final String? name;
  final String? description;
  final String? type;
  final DateTime? createdAt;

  CategoryModel({this.id, this.name, this.description, this.type, this.createdAt});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type,
    'createdAt': createdAt?.toIso8601String(),
  };
}
