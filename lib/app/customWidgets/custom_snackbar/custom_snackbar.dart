import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/app_text_style.dart';

class CustomSnackbar {
  static void show({
    String? title,
    String? message,
    Color? backgroundColor,
    IconData? iconData,
    Color? iconColor,
    List<String>? messageText,
    Color? textColor,
    double? borderRadius,
    Color? borderColor,
    void Function(GetSnackBar)? onTap,
    Duration? animationDuration,
    Duration? displayDuration,
    SnackPosition? position,
    String? emoji,
  }) {
    // Defaults (solid, not too transparent)
    final bgColor = backgroundColor ?? const Color(0xFF111827);
    final txtColor = textColor ?? Colors.white;
    final border = borderRadius ?? 18.r;
    final iconClr = iconColor ?? Colors.white;
    final displayTime = displayDuration ?? const Duration(seconds: 3);
    final animTime = animationDuration ?? const Duration(milliseconds: 500);
    final snackPosition = position ?? SnackPosition.BOTTOM;
    // final displayEmoji = emoji ?? "✨";

    // Build snack content with layered animations
    Widget customSnackWidget = Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            // allow quick dismiss by tapping the whole card if desired
          },
          child: SlideInUp(
            duration: animTime,
            child: FadeIn(
              duration: animTime,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(border),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.32), blurRadius: 14, offset: const Offset(0, 6)),
                  ],
                  border: Border.all(color: borderColor ?? Colors.white.withOpacity(0.06), width: 1),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon/Emoji area with Zoom + Shake + Pulse
                        if (iconData != null)
                          ZoomIn(
                            duration: animTime,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Subtle pulse/glow
                                Pulse(
                                  duration: const Duration(seconds: 2),
                                  infinite: true,
                                  child: Container(
                                    height: 46.sp,
                                    width: 46.sp,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [iconClr.withOpacity(0.18), Colors.transparent],
                                        radius: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                                ShakeX(
                                  duration: const Duration(milliseconds: 1400),
                                  child: Container(
                                    height: 42.sp,
                                    width: 42.sp,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [iconClr.withOpacity(0.95), iconClr.withOpacity(0.65)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(color: iconClr.withOpacity(0.45), blurRadius: 10, spreadRadius: 1),
                                      ],
                                    ),
                                    child: Icon(iconData, color: Colors.white, size: 22.sp),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(right: 14.w),
                        // else
                        //   BounceInDown(
                        //     duration: animTime,
                        //     child: Text(displayEmoji, style: TextStyle(fontSize: 28.sp)),
                        //   ).paddingOnly(right: 14.w),

                        // Text column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title with Bounce
                              Bounce(
                                duration: const Duration(milliseconds: 700),
                                child: Text(
                                  title ?? "Notice",
                                  style: AppTextStyles.customText16(color: txtColor, fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(height: 6.h),

                              // Message lines with staggered SlideInLeft
                              if (messageText != null && messageText.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: messageText.asMap().entries.map((entry) {
                                    final idx = entry.key;
                                    final txt = entry.value;
                                    return SlideInLeft(
                                      duration: animTime,
                                      delay: Duration(milliseconds: 80 * (idx + 1)),
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 4.h),
                                        child: Text(
                                          txt,
                                          style: AppTextStyles.customText12(
                                            color: txtColor.withOpacity(0.92),
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              else
                                SlideInLeft(
                                  duration: animTime,
                                  delay: const Duration(milliseconds: 120),
                                  child: Text(
                                    message ?? "Something happened!",
                                    style: AppTextStyles.customText12(color: txtColor.withOpacity(0.92), height: 1.3),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Close button (rotate + tap)
                        InkWell(
                          onTap: () => Get.back(),
                          borderRadius: BorderRadius.circular(30.r),
                          child: Container(
                            padding: EdgeInsets.all(6.sp),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.10)),
                            child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                          ),
                        ),
                      ],
                    ),

                    // Thin progress indicator at bottom (subtle, modern)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -4.h,
                      child: TweenAnimationBuilder<double>(
                        duration: displayTime,
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Container(
                            height: 4.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Colors.white.withOpacity(0.08),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  gradient: LinearGradient(
                                    colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.65)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Use GetX snackbar with the animated custom widget
    Get.snackbar(
      "",
      "",
      isDismissible: true,
      duration: displayTime,
      snackPosition: snackPosition,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: animTime,
      barBlur: 0,
      overlayBlur: 0,
      userInputForm: Form(child: customSnackWidget),
      onTap: onTap ?? (snack) {},
    );
  }

  // Variants (unchanged signatures - call show())
  static void showError({String? title, String? message, List<String>? messageList, IconData? iconData}) {
    show(
      title: title ?? "Error",
      message: message,
      messageText: messageList,
      backgroundColor: Colors.red.shade700,
      iconData: iconData ?? Icons.error_outline_rounded,
      iconColor: Colors.red,
      borderColor: Colors.redAccent,
      emoji: "❌",
    );
  }

  static void showSuccess({String? title, String? message, List<String>? messageList, IconData? iconData}) {
    show(
      title: title ?? "Success",
      message: message,
      messageText: messageList,
      backgroundColor: Colors.green.shade700,
      iconData: iconData ?? Icons.check_circle_outline,
      iconColor: Colors.greenAccent,
      borderColor: Colors.green,
      emoji: "✅",
    );
  }

  static void showInfo({String? title, String? message, List<String>? messageList, IconData? iconData}) {
    show(
      title: title ?? "Info",
      message: message,
      messageText: messageList,
      backgroundColor: Colors.blue.shade700,
      iconData: iconData ?? Icons.info_outline_rounded,
      iconColor: Colors.lightBlueAccent,
      borderColor: Colors.blueAccent,
      emoji: "ℹ️",
    );
  }

  static void showWarning({String? title, String? message, List<String>? messageList, IconData? iconData}) {
    show(
      title: title ?? "Warning",
      message: message,
      messageText: messageList,
      backgroundColor: Colors.amber.shade800,
      iconData: iconData ?? Icons.warning_amber_rounded,
      iconColor: Colors.amberAccent,
      borderColor: Colors.orangeAccent,
      emoji: "⚠️",
    );
  }
}
