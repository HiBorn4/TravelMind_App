class GetPopularCitiesRespModel {
  List<PopularCities>? popularCities;
  int? totalCount;

  GetPopularCitiesRespModel({this.popularCities, this.totalCount});

  GetPopularCitiesRespModel.fromJson(Map<String, dynamic> json) {
    if (json['popularCities'] != null) {
      popularCities = <PopularCities>[];
      json['popularCities'].forEach((v) {
        popularCities!.add(PopularCities.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (popularCities != null) {
      data['popularCities'] = popularCities!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = totalCount;
    return data;
  }
}

class PopularCities {
  String? id;
  String? name;
  String? country;
  String? description;
  List<String>? image;
  Location? location;
  String? timezone;
  String? language;
  bool? isActive;
  String? createdAt;
  Popularity? popularity;

  PopularCities({
    this.id,
    this.name,
    this.country,
    this.description,
    this.image,
    this.location,
    this.timezone,
    this.language,
    this.isActive,
    this.createdAt,
    this.popularity,
  });

  PopularCities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    description = json['description'];

    // ✅ Safely handle null or wrong type for image
    if (json['image'] != null && json['image'] is List) {
      image = List<String>.from(json['image']);
    } else {
      image = [];
    }

    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    timezone = json['timezone'];
    language = json['language'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    popularity = json['popularity'] != null ? Popularity.fromJson(json['popularity']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country'] = country;
    data['description'] = description;
    data['image'] = image;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['timezone'] = timezone;
    data['language'] = language;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    if (popularity != null) {
      data['popularity'] = popularity!.toJson();
    }
    return data;
  }
}

class Location {
  Crs? crs;
  String? type;
  List<double>? coordinates;

  Location({this.crs, this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    crs = json['crs'] != null ? Crs.fromJson(json['crs']) : null;
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (crs != null) {
      data['crs'] = crs!.toJson();
    }
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Crs {
  String? type;
  Properties? properties;

  Crs({this.type, this.properties});

  Crs.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    properties = json['properties'] != null ? Properties.fromJson(json['properties']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties!.toJson();
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

class Popularity {
  int? totalItineraries;
  int? recentItineraries;
  int? totalAttractions;
  int? totalRestaurants;
  int? totalAccommodations;
  int? popularityScore;

  Popularity({this.totalItineraries, this.recentItineraries, this.totalAttractions, this.totalRestaurants, this.totalAccommodations, this.popularityScore});

  Popularity.fromJson(Map<String, dynamic> json) {
    totalItineraries = json['totalItineraries'];
    recentItineraries = json['recentItineraries'];
    totalAttractions = json['totalAttractions'];
    totalRestaurants = json['totalRestaurants'];
    totalAccommodations = json['totalAccommodations'];
    popularityScore = json['popularityScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItineraries'] = totalItineraries;
    data['recentItineraries'] = recentItineraries;
    data['totalAttractions'] = totalAttractions;
    data['totalRestaurants'] = totalRestaurants;
    data['totalAccommodations'] = totalAccommodations;
    data['popularityScore'] = popularityScore;
    return data;
  }
}
