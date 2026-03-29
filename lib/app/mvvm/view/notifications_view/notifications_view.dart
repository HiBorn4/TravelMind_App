import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/bottom_sheets/rating_sheet.dart';
import 'package:vlad_ai/app/customWidgets/custom_app_bar.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/notification_tile.dart';
import 'package:vlad_ai/app/mvvm/view_model/notification_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  void initState() {
    notificationController.getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: context.l10n!.notifications,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20.sp),
        ),
      ),
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: Obx(
          () => notificationController.isNotificationsLoading.value
              ? Center(child: CustomLoader())
              : (notificationController.notificationModel?.data.notifications.length ?? 0) == 0
              ? Center(
                  child: Text(
                    context.l10n!.no_notifications,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: notificationController.notificationModel?.data.notifications.length ?? 0,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notification = notificationController.notificationModel!.data.notifications[index];
                    return GestureDetector(
                      onTap: () async {
                        // Only handle trip_completed_review type notifications
                        if (notification.type == 'trip_starting_soon' ||
                            notification.itineraryId == null) {
                          return;
                        }

                        // Always check if review already exists
                        Get.dialog(CustomLoader(), barrierDismissible: false);
                        debugPrint('Fetching review for itineraryId: ${notification.itineraryId}');
                        final reviewData = await notificationController.getItineraryReview(
                          notification.itineraryId!,
                        );
                        debugPrint('Review data received: $reviewData');
                        Get.back(); // Close loader

                        if (reviewData != null) {
                          debugPrint('Showing existing review - rating: ${reviewData['rating']}, comment: ${reviewData['comment']}');
                          // Review exists - show in read-only mode
                          final existingRating = int.tryParse(reviewData['rating']?.toString() ?? '1') ?? 1;
                          final existingComment = reviewData['comment']?.toString() ?? '';
                          Get.bottomSheet(
                            RatingSheet(
                              isEditAble: false,
                              iteneryId: notification.itineraryId!,
                              notificationController: notificationController,
                              existingRating: existingRating,
                              existingComment: existingComment,
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        } else {
                          // No review yet - show editable form
                          Get.bottomSheet(
                            RatingSheet(
                              isEditAble: true,
                              iteneryId: notification.itineraryId!,
                              notificationController: notificationController,
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        }
                      },
                      child: NotificationTile(notification: notification),
                    );
                  },
                ).paddingTop((kToolbarHeight + 50).h).paddingHorizontal(17.w),
        ),
      ),
    );
  }
}
