import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_urls.dart';
import 'package:vlad_ai/app/mvvm/model/body_model/notifications_model.dart';
import 'package:vlad_ai/app/services/https_calls.dart';
import 'package:vlad_ai/app/services/logger_service.dart';

class NotificationController extends GetxController {
  RxBool isNotificationsLoading = true.obs;
  NotificationModel? notificationModel;

  Future<bool> getNotifications() async {
    try {
      isNotificationsLoading.value = true;

      String? endPoint = AppUrls.getNotificationsAPI;
      final response = await HttpsCalls().getApiHits(endPoint);
      if (response.statusCode == 200) {
        notificationModel = NotificationModel.fromJson(response.body);
        log(notificationModel.toString());
        return true;
      } else {
        LoggerService.w('Signup response is null');
        return false;
      }
    } catch (e, _) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    } finally {
      isNotificationsLoading.value = false;
    }
  }

  Future<bool> getMarkNotifications() async {
    try {
      isNotificationsLoading.value = true;
      String? endPoint = AppUrls.getMarkAllNotificationsTrue;
      final response = await HttpsCalls().getApiHits(endPoint);
      if (response.statusCode == 200) {
        notificationModel = NotificationModel.fromJson(response.body);
        return true;
      } else {
        LoggerService.w('Signup response is null');
        return false;
      }
    } catch (e, _) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      isNotificationsLoading.value = false;
    }
  }

  Future<bool> postNotificationReviews(
    String itineraryId,
    int rating,
    String comment,
  ) async {
    try {
      final data = {"rating": rating.toString(), "comment": comment};
      String jsonString = json.encode(data);
      LoggerService.i('Posting review for itinerary: $itineraryId');
      LoggerService.i('Review data: $jsonString');
      final response = await HttpsCalls().postApiHits(
        '${AppUrls.itineraryReviews}/$itineraryId',
        utf8.encode(jsonString),
      );
      LoggerService.i('Review response status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.i('Review posted successfully');
        // Refresh notifications after posting review
        await getNotifications();
        return true;
      } else {
        LoggerService.w('Failed to post review: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      LoggerService.e(
        'Error posting review: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  // Fetch existing review for an itinerary
  Future<Map<String, dynamic>?> getItineraryReview(String itineraryId) async {
    try {
      LoggerService.i('Fetching review for itinerary: $itineraryId');
      final response = await HttpsCalls().getApiHits(
        '${AppUrls.itineraryReviews}/$itineraryId',
      );
      LoggerService.i('Get review response status: ${response.statusCode}');
      LoggerService.i('Get review response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        LoggerService.i('Parsed review data: $jsonData');
        if (jsonData['success'] == true && jsonData['data'] != null) {
          // Review is nested inside data.review
          final reviewData = jsonData['data']['review'];
          LoggerService.i('Returning review data: $reviewData');
          return reviewData;
        }
      }
      return null;
    } catch (e, stackTrace) {
      LoggerService.e(
        'Error fetching review: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
