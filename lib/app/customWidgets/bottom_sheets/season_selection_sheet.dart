import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/suggest_place_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../config/app_assets.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';
import '../app_custom_button.dart';

class SeasonSelectionSheet extends StatefulWidget {
  const SeasonSelectionSheet({super.key});

  @override
  State<SeasonSelectionSheet> createState() => _SeasonSelectionSheetState();
}

class _SeasonSelectionSheetState extends State<SeasonSelectionSheet> {
  final SuggestPlaceController controller = Get.find();

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
                  10.h.height,
                  // 🔹 Blurred container with Calendar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.sp),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(24.sp),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n!.best_seasons_to_visit,
                              style: AppTextStyles.customText22(
                                color: AppColors.secondaryBlack,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            20.h.height,
                            _seasonItem(context.l10n!.spring, "Spring"),
                            10.h.height,
                            _seasonItem(context.l10n!.summer, "Summer"),
                            10.h.height,
                            _seasonItem(context.l10n!.autumn, "Autumn"),
                            10.h.height,
                            _seasonItem(context.l10n!.winter, "Winter"),
                            15.h.height,
                            AppCustomButton(
                              title: context.l10n!.confirm,
                              onPressed: () {
                                Get.back();
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

  Widget _seasonItem(String title, String value) {
    return GestureDetector(
      onTap: () {
        if (controller.selectedSeason.contains(value)) {
          controller.selectedSeason.remove(value);
        } else {
          controller.selectedSeason.add(value);
        }
      },
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.sp)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() {
              return controller.selectedSeason.contains(value)
                  ? SvgPicture.asset(AppAssets.selectedTickIcon)
                  : Container(
                      height: 15.h,
                      width: 15.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(2.sp),
                        border: Border.all(color: AppColors.textLightBlack, width: 2),
                      ),
                    );
            }),
            10.w.width,
            Text(title, style: AppTextStyles.customText18(color: Colors.black)),
          ],
        ).paddingHorizontal(15.w),
      ),
    );
  }
}
