class SuggestPlaceBodyModel {
  String? cityId;
  String? title;
  Location? location;
  List<String>? categoryIds;
  List<String>? travelStyle;
  String? budget;
  List<String>? popularSeasons;
  String? address;

  SuggestPlaceBodyModel({this.cityId, this.title, this.location, this.categoryIds, this.travelStyle, this.budget, this.popularSeasons, this.address});

  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'title': title,
      'location': location?.toJson(),
      'categoryIds': categoryIds,
      'travelStyle': travelStyle,
      'budget': budget,
      'popularSeasons': popularSeasons,
      'address': address,
    };
  }
}

class Location {
  List<double>? coordinates;

  Location({this.coordinates});

  Map<String, dynamic> toJson() {
    return {'coordinates': coordinates};
  }
}
