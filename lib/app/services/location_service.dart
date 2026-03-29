import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

import 'logger_service.dart';

class LocationService {
  double? latitude;
  double? longitude;
  String? currentLocation;

  /// Request permission & check if service is enabled
  Future<bool> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      LoggerService.w('Location service is disabled.');
      await Geolocator.openLocationSettings();
      return false;
    }

    final status = await Permission.location.request();

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      LoggerService.w('Location permission permanently denied.');
      await openAppSettings();
      return false;
    }

    LoggerService.w('Location permission denied.');
    return false;
  }

  /// Fetch current coordinates + city name
  Future<bool> getCurrentLocation({bool highAccuracy = true}) async {
    try {
      LoggerService.i('Fetching current location...');

      if (!await requestPermission()) return false;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: highAccuracy ? LocationAccuracy.high : LocationAccuracy.medium,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      // Reverse geocode
      await _setCityFromCoordinates();

      LoggerService.i('Location → Lat: $latitude, Long: $longitude, City: $currentLocation');

      return true;
    } catch (e, s) {
      LoggerService.e('Location error: $e', stackTrace: s);
      return false;
    }
  }

  /// Convert coordinates into city name
  Future<void> _setCityFromCoordinates() async {
    try {
      if (latitude == null || longitude == null) return;

      final placemarks = await placemarkFromCoordinates(latitude!, longitude!);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        currentLocation = [
          place.locality, // City
          place.administrativeArea, // Province / State
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      }
    } catch (e) {
      LoggerService.e('Error while reverse geocoding: $e');
      currentLocation = 'Unknown Location';
    }
  }

  bool get hasLocation => latitude != null && longitude != null;
}
