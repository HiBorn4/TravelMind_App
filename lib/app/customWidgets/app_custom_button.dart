import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:vlad_ai/app/services/logger_service.dart';

import '../config/app_colors.dart';
import '../config/app_text_style.dart';
import 'sizedbox_extension.dart';

class AppCustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? borderRadius;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final Widget? icon;
  final Color? bgColor;
  final Color? borderColor;
  final GlobalKey? textKey;

  const AppCustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.borderRadius,
    this.height,
    this.width,
    this.textStyle,
    this.icon,
    this.bgColor,
    this.borderColor,
    this.textKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50.h,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            HapticFeedback.mediumImpact();
            // 🔹 Log button tap as Firebase Analytics event
            await FirebaseAnalytics.instance.logEvent(
              name: title.toLowerCase().replaceAll(' ', '_'),
              parameters: {'button_name': title, 'timestamp': DateTime.now().toIso8601String()},
            );

            LoggerService.w("Analytic Sent: $title");
            // 🔹 Proceed with your action
            onPressed();
          } catch (e, s) {
            // 🔹 Log any crash/error in Crashlytics
            await FirebaseCrashlytics.instance.recordError(e, s, reason: 'Error in AppCustomButton: $title');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? AppColors.secondaryBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30.sp),
            side: BorderSide(color: borderColor ?? AppColors.transparent),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null) 6.width,
            Text(
              title,
              key: textKey,
              style: textStyle ?? AppTextStyles.customText16(color: AppColors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
