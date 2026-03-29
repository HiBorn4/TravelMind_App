import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/notification_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../config/app_assets.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';
import '../app_custom_button.dart';
import '../rating_slider.dart';

class RatingSheet extends StatefulWidget {
  final bool? isEditAble;
  final String iteneryId;
  final int? existingRating;
  final String? existingComment;
  const RatingSheet({
    super.key,
    this.isEditAble,
    required this.iteneryId,
    this.notificationController,
    this.existingRating,
    this.existingComment,
  });
  final NotificationController? notificationController;
  @override
  State<RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<RatingSheet> {
  int rating = 1;
  bool isSubmitting = false;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set existing values if available
    if (widget.existingRating != null) {
      rating = widget.existingRating!;
    }
    if (widget.existingComment != null) {
      textEditingController.text = widget.existingComment!;
    }
  }

  Future<void> _submitReview() async {
    if (widget.notificationController != null) {
      setState(() {
        isSubmitting = true;
      });
      final success = await widget.notificationController!.postNotificationReviews(
        widget.iteneryId,
        rating,
        textEditingController.text,
      );
      setState(() {
        isSubmitting = false;
      });
      Get.back();
      if (success) {
        _showConfetti();
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit review. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.back();
    }
  }

  void _showConfetti() {
    Get.dialog(
      Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset(
                AppAssets.confetti,
                fit: BoxFit.cover,
                repeat: false,
                onLoaded: (composition) {
                  Future.delayed(composition.duration, () {
                    if (Get.isDialogOpen ?? false) {
                      Get.back();
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
      barrierColor: Colors.transparent,
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: EdgeInsets.all(10.sp),
                              // ignore: deprecated_member_use
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                              child: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).paddingHorizontal(18.w),
                  10.h.height,
                  // 🔹 Blurred container with Calendar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.sp),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(24.sp),
                        ),
                        child: Column(
                          children: [
                            10.h.height,
                            Text(
                              widget.isEditAble == false ? context.l10n!.your_feedback : context.l10n!.leave_us_a_review,
                              style: AppTextStyles.customText22(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.isEditAble == false
                                  ? context.l10n!.thank_you_for_your_feedback
                                  : context.l10n!.share_your_feedback_us_to_improve_our_quality,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.customText12(
                                color: AppColors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                              ),
                            ).paddingHorizontal(30.w),
                            15.h.height,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.sp),
                                color: Colors.transparent,
                              ),
                              child: RatingSlider(
                                size: 50.sp,
                                isChangeable: true,
                                rating: rating,
                                onDragChanged: (val) {
                                  if (widget.isEditAble == false) {
                                  } else {
                                    setState(() {
                                      rating = val;
                                    });
                                  }
                                },
                                onRatingChanged: (val) {
                                  if (widget.isEditAble == false) {
                                  } else {
                                    setState(() {
                                      rating = val;
                                    });
                                  }
                                },
                              ).paddingVertical(8.h),
                            ),
                            20.h.height,
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                context.l10n!.feedback,
                                style: AppTextStyles.customText18(color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                            ),
                            8.h.height,
                            TextFormField(
                              minLines: 5,
                              maxLines: 5,
                              controller: textEditingController,
                              textInputAction: TextInputAction.done,
                              readOnly: widget.isEditAble == false,
                              decoration: InputDecoration(
                                hintText: widget.isEditAble == false
                                    ? context.l10n!.no_feedback_provided
                                    : context.l10n!.enter_your_feedback_here,
                                hintStyle: AppTextStyles.customText14(color: AppColors.textLightBlack),
                                fillColor: Color(0xffF7F7F7),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.sp),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.sp),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.sp),
                                  borderSide: BorderSide(color: AppColors.transparent),
                                ),
                              ),
                            ),
                            15.h.height,
                            if (widget.isEditAble != false)
                              AppCustomButton(
                                title: isSubmitting ? context.l10n!.submitting : context.l10n!.submit,
                                bgColor: isSubmitting ? Colors.grey : null,
                                onPressed: () {
                                  if (isSubmitting) return;
                                  _submitReview();
                                },
                              ).paddingHorizontal(35.w),
                          ],
                        ).paddingFromAll(12.sp).paddingHorizontal(6.w),
                      ).paddingHorizontal(10.w).paddingBottom(10.h),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
