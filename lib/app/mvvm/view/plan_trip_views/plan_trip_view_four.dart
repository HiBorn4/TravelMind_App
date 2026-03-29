import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/plan_trip_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import 'package:flutter/cupertino.dart';

import '../../../config/global_variables.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';

class PlanTripViewFour extends StatefulWidget {
  const PlanTripViewFour({super.key});

  @override
  State<PlanTripViewFour> createState() => _PlanTripViewFourState();
}

class _PlanTripViewFourState extends State<PlanTripViewFour> {
  final PlanTripController controller = Get.find();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                            child: Icon(Icons.close, color: Colors.black, size: 20.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).paddingHorizontal(18.w),
                10.h.height,
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
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.l10n!.your_interests,
                              style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.l10n!.select_what_you_love_to_do_well_tailor_your_experience_around_it,
                              style: AppTextStyles.customText16(color: Colors.black),
                            ),
                          ),
                          20.h.height,
                          Obx(() {
                            final list = controller.intrestList.value;
                            if (list == null || list.isEmpty) {
                              return const CupertinoActivityIndicator();
                            }
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: List.generate(list.length, (index) {
                                final item = list[index];
                                final id = item.id ?? '';
                                final name = item.name ?? 'Unknown';
                                final isSelected = controller.selectedInterestIds.contains(id);
                                return GestureDetector(
                                  onTap: () => controller.toggleSelection(id),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.black
                                          : Colors.white, // always keep background white
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.black.withOpacity(0.4)
                                            : Colors.grey.shade300, // border changes when selected
                                        width: 2, // optional: make it slightly thicker
                                      ),
                                    ),
                                    child: Text(
                                      name,
                                      style: AppTextStyles.customText16(
                                        color: isSelected ? AppColors.white : AppColors.black, // text stays black
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),

                          20.h.height,
                          AppCustomButton(
                            title: context.l10n!.generate_itinerary,
                            onPressed: () async {
                              /// Check if at least 3 interests are selected
                              if (controller.selectedInterestIds.length < 3) {
                                CustomSnackbar.show(
                                  // iconData: Icons.warning_amber,
                                  textColor: AppColors.black,
                                  title: context.l10n!.error,
                                  message: "",
                                  backgroundColor: AppColors.white,
                                  iconColor: AppColors.black,
                                  borderColor: AppColors.black,
                                  messageText: [context.l10n!.please_select_at_least_3_interests_before_proceeding],
                                );
                                return;
                              }
                              Get.dialog(
                                Scaffold(
                                  body: Container(
                                    height: ScreenUtil().screenHeight,
                                    width: ScreenUtil().screenWidth,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage(AppAssets.magicBg), fit: BoxFit.cover),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(child: Lottie.asset(AppAssets.heartCountdown, height: 70.h)),
                                        // Bottom text
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              context.l10n!.the_magic_is_happening,
                                              style: AppTextStyles.customText24(
                                                color: AppColors.secondaryBlack,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            6.h.height,
                                            Text(
                                              context.l10n!.we_are_searching_thousands_of_options_to_find_the_best_matches_for_you_this_will_just_take_a_moment,
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.customText16(color: Colors.black),
                                            ).paddingHorizontal(60.w),
                                          ],
                                        ).paddingBottom(200.h),
                                      ],
                                    ),
                                  ),
                                ),
                                barrierDismissible: false,
                              );
                              String? itineraryId = await controller.craeteIterApi();
                              Get.back();
                              if (itineraryId != null) {
                                Get.toNamed(AppRoutes.toursView, arguments: itineraryId);
                              } else {
                                CustomSnackbar.show(
                                  textColor: AppColors.black,
                                  title: context.l10n!.error,
                                  message: "",
                                  backgroundColor: AppColors.white,
                                  iconColor: AppColors.black,
                                  borderColor: AppColors.black,
                                  messageText: GlobalVariables.errorMessages,
                                );
                              }
                            },
                          ),

                          // 15.h.height,
                          // InkWell(
                          //   onTap: () {
                          //     Get.offAllNamed(AppRoutes.magicHappeningView);
                          //   },
                          //   child: Text(
                          //     'Skip Itinerary',
                          //     style: AppTextStyles.customText16(color: AppColors.secondaryBlack, fontWeight: FontWeight.w600),
                          //   ),
                          // ),
                          10.h.height,
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
