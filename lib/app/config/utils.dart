/// Provides utility functions for the LayerX app.
library;

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../services/logger_service.dart';

class Utils {
  static String formatDate(DateTime? date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date ?? DateTime.now());
  }

  static String formatDateDMY(DateTime? date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date ?? DateTime.now());
  }

  static calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static String? formatDateTime(DateTime? date) {
    if (date == null) return null;
    return DateFormat('MMM d, h:mm a').format(date); // e.g., Apr 18, 3:45 PM
  }

  static bool isNotExpired(String date) {
    try {
      final cleanedDate = date
          .replaceAll(RegExp(r's+'), '') // Remove all spaces
          .replaceAll(RegExp(r'[./]'), '-') // Replace '/' and '.' with '-'
          .trim();

      final DateTime inputDate = DateTime.parse(cleanedDate);

      final DateTime today = DateTime.now();
      final DateTime currentDate = DateTime(today.year, today.month, today.day);

      return inputDate.isAfter(currentDate) || inputDate.isAtSameMomentAs(currentDate);
    } catch (e) {
      LoggerService.i("Invalid date format or error parsing date: e");
      return false;
    }
  }

  static void showBottomSheet({required BuildContext context, required Widget child, bool? isDismissable}) {
    showModalBottomSheet(
      isScrollControlled: isDismissable ?? true,
      isDismissible: isDismissable ?? true,
      enableDrag: isDismissable ?? true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (context) {
        return Container(
          width: ScreenUtil().screenWidth,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30.sp), topLeft: Radius.circular(30.sp)),
          ),
          child: child,
        );
      },
    );
  }

  static void showCustomDialog({required BuildContext context, required Widget child}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5), // soft blur backdrop
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 340.w, // ✅ dialog width limit
              minWidth: 280.w,
              maxHeight: 420.h, // ✅ dialog height limit
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(22.sp),
              clipBehavior: Clip.antiAlias,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(22.sp),
                    // boxShadow: [
                    //   BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 6)),
                    // ],
                  ),
                  padding: EdgeInsets.all(20.sp),
                  child: child, // your CupertinoLocationInfoDialog widget
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showBlurryDialog({required BuildContext context, required Widget child}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3), // Semi-transparent barrier for elevation effect
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Apply blur to background
          child: Dialog(
            elevation: 10, // Add elevation for lifted effect
            backgroundColor: Colors.white, // White dialog background
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.sp)),
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.sp),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22.sp)),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showPickImageOptionsDialog(
    BuildContext context, {
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
    VoidCallback? onFileTap, // <-- made nullable
    bool? hasFile, // <-- nullable param
    VoidCallback? onVideoTap, // <-- made nullable
    bool? hasVideo, // <-- nullable param
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(onPressed: onCameraTap, child: Text(context.l10n!.camera)),
          CupertinoActionSheetAction(onPressed: onGalleryTap, child: Text(context.l10n!.gallery)),

          if (hasFile == true && onFileTap != null) // <-- safe null check
            CupertinoActionSheetAction(onPressed: onFileTap, child: Text(context.l10n!.pick_file)),
          if (hasVideo == true && onVideoTap != null) // <-- safe null check
            CupertinoActionSheetAction(onPressed: onVideoTap, child: Text(context.l10n!.video)),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n!.cancel),
        ),
      ),
    );
  }

  static Future<void> showPickVideoOptionsDialog(
    BuildContext context, {
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(onPressed: onCameraTap, child: Text(context.l10n!.record_video)),
          CupertinoActionSheetAction(onPressed: onGalleryTap, child: Text(context.l10n!.pick_video_from_gallery)),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n!.cancel),
        ),
      ),
    );
  }

  static showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n!.error),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(context.l10n!.ok),
            ),
          ],
        );
      },
    );
  }
}
