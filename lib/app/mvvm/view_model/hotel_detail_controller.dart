import 'dart:developer';

import 'package:get/get.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/get_cities_details_resp_model.dart';
import 'package:vlad_ai/app/repository/cities_repo/cities_repo.dart';

import '../../services/logger_service.dart';
import '../model/api_response/api_response.dart';

class HotelDetailController extends GetxController {
  RxBool isDetailsLoading = false.obs;
  GetCitiesDetailFResponseModel? cityDetails;

  Future<bool> fetchCityDetails(String id, {bool? load}) async {
    if (load ?? true) {
      isDetailsLoading.value = true;
    }
    try {
      ApiResponse<GetCitiesDetailFResponseModel> apiResponse = await CitiesRepository().getCityDetails(id);
      if (apiResponse.success != null && apiResponse.success!) {
        log(apiResponse.data?.item?.weeklySchedule.toString() ?? '');
        cityDetails = apiResponse.data;
        return true;
      } else {
        return false;
      }
    } catch (e, stack) {
      LoggerService.e('Error during fetching user data: $e', error: e, stackTrace: stack);
      return false;
    } finally {
      isDetailsLoading.value = false;
    }
  }

  /// Prepare hotel context for chat query
  String getHotelContextForChat() {
    if (cityDetails?.item == null) return '';

    final item = cityDetails!.item!;
    final StringBuffer context = StringBuffer();

    context.writeln('Hotel/Place Information:');
    
    // Name
    if (item.name != null && item.name!.isNotEmpty) {
      context.writeln('Name: ${item.name}');
    }

    // Address
    if (item.address != null && item.address!.isNotEmpty) {
      context.writeln('Address: ${item.address}');
    }

    // Description
    if (item.description != null && item.description!.isNotEmpty) {
      context.writeln('Description: ${item.description}');
    }

    // Rating
    // if (item.rating != null) {
    //   context.writeln('Rating: ${item.rating} stars');
    // }

    // Price Level
    if (item.priceLevel != null && item.priceLevel!.isNotEmpty) {
      context.writeln('Price Level: ${item.priceLevel}');
    }

    // Phone
    // if (item.internationalPhoneNumber != null && item.internationalPhoneNumber!.isNotEmpty) {
    //   context.writeln('Phone: ${item.internationalPhoneNumber}');
    // }

    // Website
    // if (item.website != null && item.website!.isNotEmpty) {
    //   context.writeln('Website: ${item.website}');
    // }

    // Opening Hours
    if (item.weeklySchedule != null && item.weeklySchedule!.isNotEmpty) {
      context.writeln('Opening Hours:');
      item.weeklySchedule!.forEach((day, schedule) {
        if (schedule != null && schedule['periods'] != null) {
          final periods = schedule['periods'] as List;
          if (periods.isNotEmpty) {
            final firstPeriod = periods.first as Map<String, dynamic>;
            final openTime = firstPeriod['openTime']?.toString() ?? 'N/A';
            final closeTime = firstPeriod['closeTime']?.toString() ?? 'N/A';
            context.writeln('  ${day.capitalize}: $openTime - $closeTime');
          }
        }
      });
    }

    // Amenities/Features
    if (item.amenities != null && item.amenities!.isNotEmpty) {
      context.writeln('Amenities: ${item.amenities!.join(", ")}');
    }

    return context.toString();
  }
}

extension StringExtension on String {
  String get capitalize => this.isEmpty ? this : '${this[0].toUpperCase()}${this.substring(1)}';
}