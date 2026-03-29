class LocationModel {
  final List<double> coordinates;
  final String type = "Point";

  LocationModel({required this.coordinates});

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
  };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    coordinates: List<double>.from(json['coordinates']),
  );
}