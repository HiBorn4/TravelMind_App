import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../config/app_assets.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';
import '../app_custom_button.dart';

class ThanksContactingSheet extends StatefulWidget {
  const ThanksContactingSheet({super.key});

  @override
  State<ThanksContactingSheet> createState() => _ThanksContactingSheetState();
}

class _ThanksContactingSheetState extends State<ThanksContactingSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     GestureDetector(
                //       onTap: () => Get.back(),
                //       child: ClipRRect(
                //         borderRadius: BorderRadius.circular(50),
                //         child: BackdropFilter(
                //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                //           child: Container(
                //             padding: EdgeInsets.all(10.sp),
                //             decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                //             child: Icon(Icons.close, color: Colors.black, size: 20.sp),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ).paddingHorizontal(18.w),
                // 10.h.height,

                // 🔹 Blurred container with Calendar
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.sp),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(24.sp),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drag handle
                          Container(
                            width: 60.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: AppColors.textLightBlack.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          20.h.height,
                          SvgPicture.asset(AppAssets.loveLogo, height: 100.h),
                          20.h.height,
                          // Main message
                          Text(
                            context.l10n!.thank_you_for_contacting_us_we_will_be_in_touch_with_you_soon,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w500),
                          ).paddingHorizontal(20.w),

                          20.h.height,

                          // Action button
                          AppCustomButton(title: context.l10n!.okay, onPressed: () => Get.back()).paddingHorizontal(20.w),
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
    );
  }
}
