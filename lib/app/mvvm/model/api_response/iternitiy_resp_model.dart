// LayerX-style full model — all classes end with 'Itr'
// Paste this file (e.g., models/itinerary_itr.dart)

// ------------------ Data ------------------
class IterneityResponseModel {
  ItineraryItr itinerary;
  List<FestivalItr>? festivals;
  List<HelpfulThingItr>? helpfulThings;

  IterneityResponseModel({
    required this.itinerary,
    required this.festivals,
    required this.helpfulThings,
  });

  factory IterneityResponseModel.fromJson(Map<String, dynamic> json) =>
      IterneityResponseModel(
        itinerary: ItineraryItr.fromJson(json["itinerary"] ?? {}),
        festivals: (json["festivals"] as List? ?? [])
            .map((e) => FestivalItr.fromJson(e ?? {}))
            .toList(),
        helpfulThings: (json["helpfulThings"] as List? ?? [])
            .map((e) => HelpfulThingItr.fromJson(e ?? {}))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    "itinerary": itinerary.toJson(),
    "festivals": festivals?.map((e) => e.toJson()).toList() ?? [],
    "helpfulThings": helpfulThings?.map((e) => e.toJson()).toList() ?? [],
  };
}

// ------------------ Festival ------------------
class FestivalItr {
  String id;
  String name;
  String description;
  LocationItr location;
  String cityId;
  DateTime startDate;
  DateTime endDate;
  String? startTime;
  String? endTime;
  bool ticketRequired;
  bool isActive;
  String createdBy;
  String? updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  FestivalItr({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.cityId,
    required this.startDate,
    required this.endDate,
    this.startTime,
    this.endTime,
    required this.ticketRequired,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory FestivalItr.fromJson(Map<String, dynamic> json) => FestivalItr(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    description: json["description"] ?? "",
    location: LocationItr.fromJson(json["location"] ?? {}),
    cityId: json["cityId"] ?? "",
    startDate: DateTime.tryParse(json["startDate"] ?? "") ?? DateTime.now(),
    endDate: DateTime.tryParse(json["endDate"] ?? "") ?? DateTime.now(),
    startTime: json["startTime"],
    endTime: json["endTime"],
    ticketRequired: json["ticketRequired"] ?? false,
    isActive: json["isActive"] ?? false,
    createdBy: json["createdBy"] ?? "",
    updatedBy: json["updatedBy"],
    createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "location": location.toJson(),
    "cityId": cityId,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "startTime": startTime,
    "endTime": endTime,
    "ticketRequired": ticketRequired,
    "isActive": isActive,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}

// ------------------ Location / CRS ------------------
class LocationItr {
  CrsItr crs;
  LocationTypeItr type;
  List<double> coordinates;

  LocationItr({
    required this.crs,
    required this.type,
    required this.coordinates,
  });

  factory LocationItr.fromJson(Map<String, dynamic> json) => LocationItr(
    crs: CrsItr.fromJson(json["crs"] ?? {}),
    type: locationTypeItrValues.map[json["type"]] ?? LocationTypeItr.POINT,
    coordinates: ((json["coordinates"] as List?) ?? [])
        .map<double>((x) => (x == null) ? 0.0 : (x as num).toDouble())
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    "crs": crs.toJson(),
    "type": locationTypeItrValues.reverse[type],
    "coordinates": coordinates,
  };
}

class CrsItr {
  CrsTypeItr type;
  PropertiesItr properties;

  CrsItr({required this.type, required this.properties});

  factory CrsItr.fromJson(Map<String, dynamic> json) => CrsItr(
    type: crsTypeItrValues.map[json["type"]] ?? CrsTypeItr.NAME,
    properties: PropertiesItr.fromJson(json["properties"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "type": crsTypeItrValues.reverse[type],
    "properties": properties.toJson(),
  };
}

class PropertiesItr {
  NameItr name;

  PropertiesItr({required this.name});

  factory PropertiesItr.fromJson(Map<String, dynamic> json) =>
      PropertiesItr(name: nameItrValues.map[json["name"]] ?? NameItr.EPSG_4326);

  Map<String, dynamic> toJson() => {"name": nameItrValues.reverse[name]};
}

// ------------------ HelpfulThing ------------------
class HelpfulThingItr {
  String id;
  String cityId;
  String categoryId;
  String title;
  String description;
  String? contactInfo;
  List<dynamic> images;
  List<dynamic> externalLinks;
  bool isActive;
  dynamic location;
  dynamic address;
  String createdBy;
  String? updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  AccommodationCategoryItr category;

  HelpfulThingItr({
    required this.id,
    required this.cityId,
    required this.categoryId,
    required this.title,
    required this.description,
    this.contactInfo,
    required this.images,
    required this.externalLinks,
    required this.isActive,
    this.location,
    this.address,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.category,
  });

  factory HelpfulThingItr.fromJson(Map<String, dynamic> json) =>
      HelpfulThingItr(
        id: json["id"] ?? "",
        cityId: json["cityId"] ?? "",
        categoryId: json["categoryId"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        contactInfo: json["contactInfo"],
        images: (json["images"] as List?) ?? [],
        externalLinks: (json["externalLinks"] as List?) ?? [],
        isActive: json["isActive"] ?? false,
        location: json["location"],
        address: json["address"],
        createdBy: json["createdBy"] ?? "",
        updatedBy: json["updatedBy"],
        createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
        deletedAt: json["deletedAt"],
        category: AccommodationCategoryItr.fromJson(
          json["category"] ?? <String, dynamic>{},
        ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cityId": cityId,
    "categoryId": categoryId,
    "title": title,
    "description": description,
    "contactInfo": contactInfo,
    "images": images,
    "externalLinks": externalLinks,
    "isActive": isActive,
    "location": location,
    "address": address,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
    "category": category.toJson(),
  };
}

// ------------------ AccommodationCategory ------------------
class AccommodationCategoryItr {
  String id;
  String name;
  String? description;
  AccommodationCategoryTypeItr? type;
  String? country;
  String? region;
  RestaurantCategoryItr? restaurantCategory;

  AccommodationCategoryItr({
    required this.id,
    required this.name,
    this.region,
    this.description,
    this.type,
    this.country,
    this.restaurantCategory,
  });

  factory AccommodationCategoryItr.fromJson(Map<String, dynamic> json) =>
      AccommodationCategoryItr(
        id: json["id"] ?? "",
        name: json["name"] ?? "",

        description: json["description"],
        type: accommodationCategoryTypeItrValues.map[json["type"]],
        country: json["country"],
        region: json["region"],
        restaurantCategory: json["RestaurantCategory"] == null
            ? null
            : RestaurantCategoryItr.fromJson(json["RestaurantCategory"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "type": accommodationCategoryTypeItrValues.reverse[type],
    "country": country,
    "region": region,
    "RestaurantCategory": restaurantCategory?.toJson(),
  };
}

class RestaurantCategoryItr {
  int displayOrder;

  RestaurantCategoryItr({required this.displayOrder});

  factory RestaurantCategoryItr.fromJson(Map<String, dynamic> json) =>
      RestaurantCategoryItr(displayOrder: json["displayOrder"] ?? 0);

  Map<String, dynamic> toJson() => {"displayOrder": displayOrder};
}

// ------------------ Itinerary ------------------
class ItineraryItr {
  String? id;
  String? userId;
  String? cityId;
  DateTime? startDate;
  DateTime? endDate;
  int? numberOfTravelers;
  BudgetItr? budget;
  String? travelStyle;
  String? accommodationCategoryId;
  bool? disabledPerson;
  List<String>? userInterests;
  ItineraryDataItr? itineraryData;
  String? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  AccommodationCategoryItr? city;
  AccommodationCategoryItr? accommodationCategory;

  ItineraryItr({
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

  factory ItineraryItr.fromJson(Map<String, dynamic> json) => ItineraryItr(
    id: json["id"] ?? "",
    userId: json["userId"] ?? "",
    cityId: json["cityId"] ?? "",
    startDate: DateTime.tryParse(json["startDate"] ?? "") ?? DateTime.now(),
    endDate: DateTime.tryParse(json["endDate"] ?? "") ?? DateTime.now(),
    numberOfTravelers: json["numberOfTravelers"] ?? 0,
    budget: budgetItrValues.map[json["budget"]] ?? BudgetItr.ECONOMIC,
    travelStyle: json["travelStyle"] ?? "",
    accommodationCategoryId: json["accommodationCategoryId"] ?? "",
    disabledPerson: json["disabledPerson"] ?? false,
    userInterests: (json["userInterests"] as List? ?? [])
        .map((e) => e.toString())
        .toList(),
    itineraryData: ItineraryDataItr.fromJson(json["itineraryData"] ?? {}),
    createdBy: json["createdBy"] ?? "",
    updatedBy: json["updatedBy"],
    createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
    deletedAt: json["deletedAt"],
    city: AccommodationCategoryItr.fromJson(json["city"] ?? {}),
    accommodationCategory: AccommodationCategoryItr.fromJson(
      json["accommodationCategory"] ?? {},
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "cityId": cityId,
    "startDate": _dateOnly(startDate ?? DateTime.now()),
    "endDate": _dateOnly(endDate ?? DateTime.now()),
    "numberOfTravelers": numberOfTravelers,
    "budget": budgetItrValues.reverse[budget],
    "travelStyle": travelStyle,
    "accommodationCategoryId": accommodationCategoryId,
    "disabledPerson": disabledPerson,
    "userInterests": userInterests,
    "itineraryData": itineraryData!.toJson(),
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "deletedAt": deletedAt,
    "city": city!.toJson(),
    "accommodationCategory": accommodationCategory!.toJson(),
  };

  static String _dateOnly(DateTime dt) =>
      "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
}

// ------------------ Budget Enum ------------------
enum BudgetItr { ECONOMIC, MODERATE }

final budgetItrValues = EnumValuesItr({
  "economic": BudgetItr.ECONOMIC,
  "moderate": BudgetItr.MODERATE,
});

// ------------------ ItineraryData / Day / Slot / Selected ------------------
class ItineraryDataItr {
  DayItr day1;
  DayItr day2;
  DayItr day3;
  DayItr day4;
  DayItr day5;
  DayItr day6;
  DayItr day7;

  ItineraryDataItr({
    required this.day1,
    required this.day2,
    required this.day3,
    required this.day4,
    required this.day5,
    required this.day6,
    required this.day7,
  });

  factory ItineraryDataItr.fromJson(Map<String, dynamic> json) =>
      ItineraryDataItr(
        day1: DayItr.fromJson(json["day1"] ?? {}),
        day2: DayItr.fromJson(json["day2"] ?? {}),
        day3: DayItr.fromJson(json["day3"] ?? {}),
        day4: DayItr.fromJson(json["day4"] ?? {}),
        day5: DayItr.fromJson(json["day5"] ?? {}),
        day6: DayItr.fromJson(json["day6"] ?? {}),
        day7: DayItr.fromJson(json["day7"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "day1": day1.toJson(),
    "day2": day2.toJson(),
    "day3": day3.toJson(),
    "day4": day4.toJson(),
    "day5": day5.toJson(),
    "day6": day6.toJson(),
    "day7": day7.toJson(),
  };

  /// Get all days as a list for easy iteration
  List<DayItr> get allDays => [day1, day2, day3, day4, day5, day6, day7];

  /// Get all slot IDs from all days combined
  List<String> getAllSlotIds() {
    final List<String> allSlotIds = [];
    for (final day in allDays) {
      for (final slot in day.slots) {
        allSlotIds.add(slot.slotId);
      }
    }
    return allSlotIds;
  }
}

class DayItr {
  DateTime date;
  String type;
  List<SlotItr> slots;
  int dayNumber;

  DayItr({
    required this.date,
    required this.type,
    required this.slots,
    required this.dayNumber,
  });

  factory DayItr.fromJson(Map<String, dynamic> json) => DayItr(
    date: DateTime.tryParse(json["date"] ?? "") ?? DateTime.now(),
    type: json["type"] ?? "",
    slots: (json["slots"] as List? ?? [])
        .map((e) => SlotItr.fromJson(e ?? {}))
        .toList(),
    dayNumber: json["dayNumber"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "date": ItineraryItr._dateOnly(date),
    "type": type,
    "slots": slots.map((e) => e.toJson()).toList(),
    "dayNumber": dayNumber,
  };
}

class SlotItr {
  String time;
  AccommodationCategoryTypeItr type;
  String? action;
  String slotId;
  String selectedId;
  List<String> alternativeIds;
  SelectedItr selected;
  List<SelectedItr> alternatives;

  SlotItr({
    required this.time,
    required this.type,
    this.action,
    required this.slotId,
    required this.selectedId,
    required this.alternativeIds,
    required this.selected,
    required this.alternatives,
  });

  factory SlotItr.fromJson(Map<String, dynamic> json) => SlotItr(
    time: json["time"] ?? "",
    type:
        accommodationCategoryTypeItrValues.map[json["type"]] ??
        AccommodationCategoryTypeItr.ACCOMMODATION,
    action: json["action"],
    slotId: json["slotId"] ?? "",
    selectedId: json["selectedId"] ?? "",
    alternativeIds: (json["alternativeIds"] as List? ?? [])
        .map((e) => e.toString())
        .toList(),
    // API returns "selectedDetails", fallback to "selected" for backward compatibility
    selected: SelectedItr.fromJson(json["selectedDetails"] ?? json["selected"] ?? {}),
    alternatives: (json["alternatives"] as List? ?? [])
        .map((e) => SelectedItr.fromJson(e ?? {}))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "type": accommodationCategoryTypeItrValues.reverse[type],
    "action": action,
    "slotId": slotId,
    "selectedId": selectedId,
    "alternativeIds": alternativeIds,
    "selected": selected.toJson(),
    "alternatives": alternatives.map((e) => e.toJson()).toList(),
  };
}

class SelectedItr {
  String id;
  String name;
  String address;
  List<String> images;
  LocationItr location;
  AccommodationCategoryItr? category;
  int? recommendationWeight;
  String? description;
  String? shortDescription;
  int? durationMinutes;
  BudgetItr? priceLevel;
  List<AccommodationCategoryItr>? categories;

  SelectedItr({
    required this.id,
    required this.name,
    required this.address,
    required this.images,
    required this.location,
    this.category,
    this.recommendationWeight,
    this.description,
    this.shortDescription,
    this.durationMinutes,
    this.priceLevel,
    this.categories,
  });

  factory SelectedItr.fromJson(Map<String, dynamic> json) => SelectedItr(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    address: json["address"] ?? "",
    images: (json["images"] as List? ?? []).map((e) => e.toString()).toList(),
    location: LocationItr.fromJson(json["location"] ?? {}),
    category: json["category"] == null
        ? null
        : AccommodationCategoryItr.fromJson(json["category"]),
    recommendationWeight: json["recommendationWeight"],
    description: json["description"],
    shortDescription: json["shortDescription"],
    durationMinutes: json["durationMinutes"],
    priceLevel: budgetItrValues.map[json["priceLevel"]],
    categories: json["categories"] == null
        ? null
        : (json["categories"] as List)
              .map((e) => AccommodationCategoryItr.fromJson(e ?? {}))
              .toList(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "images": images,
    "location": location.toJson(),
    "category": category?.toJson(),
    "recommendationWeight": recommendationWeight,
    "description": description,
    "shortDescription": shortDescription,
    "durationMinutes": durationMinutes,
    "priceLevel": priceLevel == null
        ? null
        : budgetItrValues.reverse[priceLevel],
    "categories": categories?.map((e) => e.toJson()).toList() ?? [],
  };
}

// ------------------ Enums & Helper ------------------
enum NameItr { EPSG_4326 }

final nameItrValues = EnumValuesItr({"EPSG:4326": NameItr.EPSG_4326});

enum CrsTypeItr { NAME }

final crsTypeItrValues = EnumValuesItr({"name": CrsTypeItr.NAME});

enum LocationTypeItr { POINT }

final locationTypeItrValues = EnumValuesItr({"Point": LocationTypeItr.POINT});

enum AccommodationCategoryTypeItr { ACCOMMODATION, ATTRACTION, RESTAURANT }

final accommodationCategoryTypeItrValues = EnumValuesItr({
  "accommodation": AccommodationCategoryTypeItr.ACCOMMODATION,
  "attraction": AccommodationCategoryTypeItr.ATTRACTION,
  "restaurant": AccommodationCategoryTypeItr.RESTAURANT,
});

class EnumValuesItr<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValuesItr(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
