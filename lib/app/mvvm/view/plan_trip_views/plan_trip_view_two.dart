import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vlad_ai/app/config/app_assets.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/global_variables.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/config/utils.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/custom_snackbar/custom_snackbar.dart';
import 'package:vlad_ai/app/customWidgets/dialogs/selection_list_dialog.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/plan_trip_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_colors.dart';
import '../../model/api_response/acc_inter_responsemodel.dart';

class PlanTripViewTwo extends StatefulWidget {
  const PlanTripViewTwo({super.key});

  @override
  State<PlanTripViewTwo> createState() => _PlanTripViewTwoState();
}

class _PlanTripViewTwoState extends State<PlanTripViewTwo> {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.pageController.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                            child: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
                          ),
                        ),
                      ),
                    ),
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
                              context.l10n!.refine_your_trip,
                              style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.l10n!.customize_the_details_to_match_your_travel_style,
                              style: AppTextStyles.customText16(color: Colors.black),
                            ),
                          ),
                          15.h.height,
                          Obx(() {
                            return GestureDetector(
                              onTap: () {
                                Utils.showCustomDialog(
                                  context: context,
                                  child: CupertinoSelectionList(
                                    items: controller.groupList,
                                    onSelected: (val) {
                                      controller.groupValue.value = val;
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.sp),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.groupValue.value,
                                      style: AppTextStyles.customText18(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.secondaryBlack),
                                  ],
                                ).paddingFromAll(10.sp).paddingVertical(5.h),
                              ),
                            );
                          }),

                          // 8.h.height,
                          // Obx(() {
                          //   return DropDownWidget(
                          //     fillColor: Colors.white,
                          //     borderColor: Colors.transparent,
                          //     selectedValue: controller.startingDateValue.value,
                          //     onChanged: (val) {
                          //       controller.startingDateValue.value = val ?? '';
                          //     },
                          //     itemsList: controller.startingDateList,
                          //     title: '',
                          //   );
                          // }),
                          8.h.height,
                          Obx(() {
                            return GestureDetector(
                              onTap: () {
                                Utils.showCustomDialog(
                                  context: context,
                                  child: Obx(() {
                                    final list = controller.accommodationList.value;
                                    if (list == null || list.isEmpty) {
                                      return const CupertinoActivityIndicator();
                                    }
                                    return CupertinoSelectionList<AccommodationCategory>(
                                      items: list,
                                      labelBuilder: (item) => item.name ?? 'Unknown',
                                      onSelected: (val) {
                                        controller.placeValue.value = val.name ?? '';
                                        controller.selectedAccommodation.value = val.id ?? '';
                                      },
                                    );
                                  }),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.sp),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.placeValue.value,
                                      style: AppTextStyles.customText18(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.secondaryBlack),
                                  ],
                                ).paddingFromAll(10.sp).paddingVertical(5.h),
                              ),
                            );
                          }),

                          // 8.h.height,
                          // Container(
                          //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.sp)),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         'Disabled Person',
                          //         style: AppTextStyles.customText18(color: Colors.black, fontWeight: FontWeight.w500),
                          //       ),
                          //       Obx(() {
                          //         return SizedBox(
                          //           height: 23.h,
                          //           child: Transform.scale(
                          //             scale: 0.8, // slightly smaller to match deszign
                          //             child: CupertinoSwitch(
                          //               inactiveTrackColor: AppColors.grey.withOpacity(0.3),
                          //               inactiveThumbColor: AppColors.white,
                          //               value: controller.disabledPersonaValue.value,
                          //               activeColor: AppColors.secondaryBlack,
                          //               onChanged: (val) {
                          //                 controller.disabledPersonaValue.value = val;
                          //               },
                          //             ),
                          //           ),
                          //         );
                          //       }),
                          //     ],
                          //   ).paddingFromAll(10.sp).paddingVertical(5.h),
                          // ),
                          8.h.height,
                          // Container(
                          //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.sp)),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         'Pet Friendly',
                          //         style: AppTextStyles.customText18(color: Colors.black, fontWeight: FontWeight.w500),
                          //       ),
                          //       Obx(() {
                          //         return SizedBox(
                          //           height: 23.h,
                          //           child: Transform.scale(
                          //             scale: 0.8, // slightly smaller to match deszign
                          //             child: CupertinoSwitch(
                          //               inactiveTrackColor: AppColors.grey.withOpacity(0.3),
                          //               inactiveThumbColor: AppColors.white,
                          //               value: controller.petFriendlyValue.value,
                          //               activeColor: AppColors.secondaryBlack,
                          //               onChanged: (val) {
                          //                 controller.petFriendlyValue.value = val;
                          //               },
                          //             ),
                          //           ),
                          //         );
                          //       }),
                          //     ],
                          //   ).paddingFromAll(10.sp).paddingVertical(5.h),
                          // ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.l10n!.your_interests,
                              style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     "Select what you love to do. We'll tailor your experience around it.",
                          //     style: AppTextStyles.customText16(color: Colors.black),
                          //   ),
                          // ),
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
                              // controller.pageController.nextPage(
                              //   duration: Duration(milliseconds: 500),
                              //   curve: Curves.easeInOut,
                              // );
                            },
                          ),
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
