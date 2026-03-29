class ItineraryBodyModel {
  final String cityId;
  final String startDate;
  final String endDate;
  final int numberOfTravelers;
  final String budget; // economy, moderate, luxury
  final String travelStyle; // solo, couple, family, friends
  final String accommodationCategoryId;
  final bool disabledPerson;
  final List<String> userInterests;

  ItineraryBodyModel({
    required this.cityId,
    required this.startDate,
    required this.endDate,
    required this.numberOfTravelers,
    required this.budget,
    required this.travelStyle,
    required this.accommodationCategoryId,
    required this.disabledPerson,
    required this.userInterests,
  });

  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'startDate': startDate,
      'endDate': endDate,
      'numberOfTravelers': numberOfTravelers,
      'budget': budget,
      'travelStyle': travelStyle,
      'accommodationCategoryId': accommodationCategoryId,
      'disabledPerson': disabledPerson,
      'userInterests': userInterests,
    };
  }
}
