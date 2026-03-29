class GetAllItinerariesRespModel {
  List<Itineraries>? itineraries;

  GetAllItinerariesRespModel({this.itineraries});

  GetAllItinerariesRespModel.fromJson(Map<String, dynamic> json) {
    if (json['itineraries'] != null) {
      itineraries = <Itineraries>[];
      json['itineraries'].forEach((v) {
        itineraries!.add(Itineraries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (itineraries != null) {
      data['itineraries'] = itineraries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Itineraries {
  String? id;
  String? userId;
  String? cityId;
  String? startDate;
  String? endDate;
  int? numberOfTravelers;
  String? budget;
  String? travelStyle;
  String? accommodationCategoryId;
  bool? disabledPerson;
  List<String>? userInterests;
  ItineraryData? itineraryData;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  City? city;
  AccommodationCategory? accommodationCategory;

  Itineraries({
    this.id,
    this.userId,
    this.cityId,
    this.startDate,
    this.endDate,
    this.numberOfTravelers,
    this.budget,
    this.travelStyle,
    this.accommodationCategoryId,
    this.disabledPerson,
    this.userInterests,
    this.itineraryData,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.city,
    this.accommodationCategory,
  });

  Itineraries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    cityId = json['cityId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    numberOfTravelers = json['numberOfTravelers'];
    budget = json['budget'];
    travelStyle = json['travelStyle'];
    accommodationCategoryId = json['accommodationCategoryId'];
    disabledPerson = json['disabledPerson'];
    userInterests = json['userInterests'].cast<String>();
    itineraryData = json['itineraryData'] != null ? ItineraryData.fromJson(json['itineraryData']) : null;
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    accommodationCategory = json['accommodationCategory'] != null ? AccommodationCategory.fromJson(json['accommodationCategory']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['cityId'] = cityId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['numberOfTravelers'] = numberOfTravelers;
    data['budget'] = budget;
    data['travelStyle'] = travelStyle;
    data['accommodationCategoryId'] = accommodationCategoryId;
    data['disabledPerson'] = disabledPerson;
    data['userInterests'] = userInterests;
    if (itineraryData != null) {
      data['itineraryData'] = itineraryData!.toJson();
    }
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (accommodationCategory != null) {
      data['accommodationCategory'] = accommodationCategory!.toJson();
    }
    return data;
  }
}

class ItineraryData {
  Day1? day1;
  Day1? day2;
  Day1? day3;
  Day1? day4;

  ItineraryData({this.day1, this.day2, this.day3, this.day4});

  ItineraryData.fromJson(Map<String, dynamic> json) {
    day1 = json['day1'] != null ? Day1.fromJson(json['day1']) : null;
    day2 = json['day2'] != null ? Day1.fromJson(json['day2']) : null;
    day3 = json['day3'] != null ? Day1.fromJson(json['day3']) : null;
    day4 = json['day4'] != null ? Day1.fromJson(json['day4']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (day1 != null) {
      data['day1'] = day1!.toJson();
    }
    if (day2 != null) {
      data['day2'] = day2!.toJson();
    }
    if (day3 != null) {
      data['day3'] = day3!.toJson();
    }
    if (day4 != null) {
      data['day4'] = day4!.toJson();
    }
    return data;
  }
}

class Day1 {
  String? date;
  String? type;
  List<Slots>? slots;
  int? dayNumber;

  Day1({this.date, this.type, this.slots, this.dayNumber});

  Day1.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    type = json['type'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(Slots.fromJson(v));
      });
    }
    dayNumber = json['dayNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['type'] = type;
    if (slots != null) {
      data['slots'] = slots!.map((v) => v.toJson()).toList();
    }
    data['dayNumber'] = dayNumber;
    return data;
  }
}

class Slots {
  String? time;
  String? type;
  String? action;
  String? slotId;
  Selected? selected;
  // List<Alternatives>? alternatives;

  Slots({this.time, this.type, this.action, this.slotId, this.selected});

  Slots.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    type = json['type'];
    action = json['action'];
    slotId = json['slotId'];
    selected = json['selected'] != null ? Selected.fromJson(json['selected']) : null;
    // if (json['alternatives'] != null) {
    //   alternatives = <Alternatives>[];
    //   json['alternatives'].forEach((v) {
    //     alternatives!.add(new Alternatives.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['time'] = time;
    data['type'] = type;
    data['action'] = action;
    data['slotId'] = slotId;
    if (selected != null) {
      data['selected'] = selected!.toJson();
    }
    // if (this.alternatives != null) {
    //   data['alternatives'] = this.alternatives!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Selected {
  String? id;
  String? name;
  List<String>? images;
  String? address;
  Location? location;
  List<Categories>? categories;
  String? priceLevel;
  String? description;
  String? shortDescription;
  int? recommendationWeight;
  Category? category;

  Selected({
    this.id,
    this.name,
    this.images,
    this.address,
    this.location,
    this.categories,
    this.priceLevel,
    this.description,
    this.shortDescription,
    this.recommendationWeight,
    this.category,
  });

  Selected.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    images = json['images'].cast<String>();
    address = json['address'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    priceLevel = json['priceLevel'];
    description = json['description'];
    shortDescription = json['shortDescription'];
    recommendationWeight = json['recommendationWeight'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['images'] = images;
    data['address'] = address;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    data['priceLevel'] = priceLevel;
    data['description'] = description;
    data['shortDescription'] = shortDescription;
    data['recommendationWeight'] = recommendationWeight;
    if (category != null) {
      data['category'] = category!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    return data;
  }
}

class Categories {
  String? id;
  String? name;
  String? type;
  RestaurantCategory? restaurantCategory;

  Categories({this.id, this.name, this.type, this.restaurantCategory});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    restaurantCategory = json['RestaurantCategory'] != null ? RestaurantCategory.fromJson(json['RestaurantCategory']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    if (restaurantCategory != null) {
      data['RestaurantCategory'] = restaurantCategory!.toJson();
    }
    return data;
  }
}

class RestaurantCategory {
  int? displayOrder;

  RestaurantCategory({this.displayOrder});

  RestaurantCategory.fromJson(Map<String, dynamic> json) {
    displayOrder = json['displayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayOrder'] = displayOrder;
    return data;
  }
}

class Category {
  String? id;
  String? name;
  String? type;

  Category({this.id, this.name, this.type});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}

class City {
  String? id;
  String? name;
  String? country;

  City({this.id, this.name, this.country});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country'] = country;
    return data;
  }
}

class AccommodationCategory {
  String? id;
  String? name;
  String? type;
  String? description;

  AccommodationCategory({this.id, this.name, this.type, this.description});

  AccommodationCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['description'] = description;
    return data;
  }
}
