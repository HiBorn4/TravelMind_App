import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/config/utils.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/bottom_sheets/calender_sheet.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/drop_down_widget.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/plan_trip_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';
import '../../../customWidgets/dialogs/selection_list_dialog.dart';

class PlanTripViewOne extends StatefulWidget {
  const PlanTripViewOne({super.key});

  @override
  State<PlanTripViewOne> createState() => _PlanTripViewOneState();
}

class _PlanTripViewOneState extends State<PlanTripViewOne> {
  final PlanTripController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.initView();
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return controller.isPlanLoading.value
            ? CustomLoader()
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
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
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10.sp),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      size: 20.sp,
                                    ),
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
                                      context.l10n!.plan_your_trip,
                                      style: AppTextStyles.customText24(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      context.l10n!.lets_start_with_the_essentials_for_your_adventure,
                                      style: AppTextStyles.customText16(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  15.h.height,
                                  Obx(() {
                                    return controller.isEditingLocation.value
                                        ? Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        14.sp,
                                                      ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        context.l10n!.where,
                                                        style:
                                                            AppTextStyles.customText20(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                    10.h.height,
                                                    Obx(() {
                                                      if (!controller
                                                          .isEditingLocation
                                                          .value) {
                                                        return const SizedBox.shrink();
                                                      }
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextFormField(
                                                            onChanged: controller
                                                                .filterCities,
                                                            controller:
                                                                _searchController,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            decoration: InputDecoration(
                                                              hintText:
                                                                  context.l10n!.search_destination,
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              prefixIcon:
                                                                  SvgPicture.asset(
                                                                    AppAssets
                                                                        .searchIcon,
                                                                  ).paddingFromAll(
                                                                    12.sp,
                                                                  ),
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      14.sp,
                                                                    ),
                                                                borderSide: BorderSide(
                                                                  color: AppColors
                                                                      .textLightBlack
                                                                      .withOpacity(
                                                                        0.3,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ).paddingOnly(
                                                            bottom: 12.sp,
                                                          ),
                                                          Obx(() {
                                                            final cities =
                                                                controller
                                                                    .filteredCities;
                                                            if (cities
                                                                    .isEmpty &&
                                                                _searchController
                                                                    .text
                                                                    .isNotEmpty) {
                                                              return Center(
                                                                child: Text(
                                                                  context.l10n!.no_cities_found,
                                                                  style: AppTextStyles.customText16(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              );
                                                            }

                                                            return SizedBox(
                                                              height:
                                                                  controller
                                                                      .filteredCities
                                                                      .isEmpty
                                                                  ? 0.h
                                                                  : controller
                                                                            .filteredCities
                                                                            .length <=
                                                                        2
                                                                  ? ScreenUtil()
                                                                            .screenHeight *
                                                                        controller
                                                                            .filteredCities
                                                                            .length /
                                                                        15
                                                                  : ScreenUtil()
                                                                            .screenHeight *
                                                                        0.2,
                                                              child: ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    BouncingScrollPhysics(),
                                                                itemCount:
                                                                    cities
                                                                        .length,
                                                                itemBuilder: (_, index) {
                                                                  final city =
                                                                      cities[index];
                                                                  final isSelected =
                                                                      controller
                                                                          .selectedCityId
                                                                          .value ==
                                                                      city.id;
                                                                  return GestureDetector(
                                                                    onTap: () =>
                                                                        controller
                                                                            .selectCity(
                                                                              city,
                                                                            ),
                                                                    child: Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            4.sp,
                                                                      ),
                                                                      padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            14.sp,
                                                                        vertical:
                                                                            10.sp,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            isSelected
                                                                            ? AppColors.primary.withOpacity(
                                                                                0.1,
                                                                              )
                                                                            : Colors.white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12.sp,
                                                                            ),
                                                                        border: Border.all(
                                                                          color:
                                                                              isSelected
                                                                              ? AppColors.primary.withOpacity(
                                                                                  0.1,
                                                                                )
                                                                              : Colors.grey.shade300,
                                                                        ),
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              '${city.name ?? ''}, ${city.region ?? ''}',
                                                                              style: AppTextStyles.customText16(
                                                                                color: Colors.black,
                                                                                fontWeight: isSelected
                                                                                    ? FontWeight.w600
                                                                                    : FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          if (isSelected)
                                                                            Icon(
                                                                              Icons.check_circle,
                                                                              color: AppColors.primary,
                                                                              size: 20.sp,
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          }),
                                                        ],
                                                      );
                                                    }),
                                                  ],
                                                ).paddingFromAll(12.sp),
                                              ),
                                              15.h.height,
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              controller
                                                      .isEditingLocation
                                                      .value =
                                                  true;
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      14.sp,
                                                    ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    context.l10n!.destination,
                                                    style:
                                                        AppTextStyles.customText16(
                                                          color: AppColors
                                                              .textLightBlack,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      // CustomCachedImage(
                                                      //   height: 30.sp,
                                                      //   width: 30.sp,
                                                      //   imageUrl:
                                                      //       'https://images.pexels.com/photos/9754/mountains-clouds-forest-fog.jpg',
                                                      //   borderRadius: 8.sp,
                                                      // ),
                                                      // 4.w.width,
                                                      Obx(
                                                        () => SizedBox(
                                                          // width: 100.w,
                                                          child: Text(
                                                            controller
                                                                    .currentLocation
                                                                    .value
                                                                    .isEmpty
                                                                ? context.l10n!.select_location
                                                                : '${controller.currentLocation.value}, ${controller.currentRegion.value}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                AppTextStyles.customText16(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ).paddingFromAll(10.sp),
                                            ),
                                          );
                                  }),

                                  10.h.height,
                                  Obx(() {
                                    final controller =
                                        Get.find<PlanTripController>();
                                    return controller.isEditingDays.value
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(14.sp),
                                            ),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    context.l10n!.duration,
                                                    style:
                                                        AppTextStyles.customText20(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                                SliderTheme(
                                                  data: SliderTheme.of(context).copyWith(
                                                    activeTrackColor: Color(
                                                      0xFF2196F3,
                                                    ),
                                                    inactiveTrackColor: Color(
                                                      0xFFE0E0E0,
                                                    ),
                                                    thumbColor: Color(
                                                      0xFF2196F3,
                                                    ),
                                                    trackHeight: 6.0,
                                                    thumbShape: ImageThumbShape(
                                                      imageAsset:
                                                          AppAssets.sliderThumb,
                                                      size: 50.h,
                                                    ),
                                                    overlayColor: Color(
                                                      0xFF2196F3,
                                                    ).withOpacity(0.2),
                                                    overlayShape:
                                                        RoundSliderOverlayShape(
                                                          overlayRadius: 20.0,
                                                        ),
                                                    trackShape:
                                                        RoundedRectSliderTrackShape(),
                                                  ),
                                                  child: Obx(() {
                                                    return Slider(
                                                      padding: EdgeInsets.zero,
                                                      value: controller
                                                          .sliderValue
                                                          .value,
                                                      min: 0,
                                                      max: 10,
                                                      onChanged: (double value) {
                                                        controller
                                                                .sliderValue
                                                                .value =
                                                            value;
                                                        if (controller
                                                                .startDate
                                                                .value !=
                                                            null) {
                                                          controller
                                                              .endDate
                                                              .value = controller
                                                              .startDate
                                                              .value!
                                                              .add(
                                                                Duration(
                                                                  days: value
                                                                      .toInt(),
                                                                ),
                                                              );
                                                          controller
                                                              .daysCount
                                                              .value = value
                                                              .toInt();
                                                        }
                                                      },
                                                    );
                                                  }),
                                                ),
                                                Obx(() {
                                                  return Text(
                                                    "${controller.sliderValue.value.toInt()} ${context.l10n!.days}",
                                                    style:
                                                        AppTextStyles.customText16(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  );
                                                }),
                                                10.h.height,
                                              ],
                                            ).paddingHorizontal(12.sp).paddingTop(12.h),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              controller.isEditingDays.value =
                                                  false;
                                              controller
                                                      .isEditingLocation
                                                      .value =
                                                  false;
                                              controller.isEditingBudget.value =
                                                  false;
                                              controller
                                                      .isEditingTravelers
                                                      .value =
                                                  false;
                                              Utils.showBottomSheet(
                                                context: context,
                                                child: CalenderSheet(
                                                  onConfirm:
                                                      (startDate, endDate) {
                                                        controller
                                                                .startDate
                                                                .value =
                                                            startDate;
                                                        controller
                                                            .updateTripDates(
                                                              startDate,
                                                              endDate,
                                                            );
                                                      },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      14.sp,
                                                    ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    context.l10n!.start_date,
                                                    style:
                                                        AppTextStyles.customText16(
                                                          color: AppColors
                                                              .textLightBlack,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                  ),
                                                  Obx(
                                                    () => Text(
                                                      controller
                                                                  .daysCount
                                                                  .value ==
                                                              0
                                                          ? context.l10n!.add_date_days
                                                          : Utils.formatDate(
                                                              controller
                                                                  .startDate
                                                                  .value,
                                                            ),
                                                      style:
                                                          AppTextStyles.customText16(
                                                            color:
                                                                AppColors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ).paddingFromAll(10.sp).paddingVertical(6.h),
                                            ),
                                          );
                                  }),
                                  10.h.height,
                                  Obx(() {
                                    return controller.isEditingTravelers.value
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(14.sp),
                                            ),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    context.l10n!.travelers,
                                                    style:
                                                        AppTextStyles.customText20(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                                15.h.height,
                                                _buildTravelersTile(
                                                  value: controller.adultsCount,
                                                  title: context.l10n!.adults,
                                                  subtitle: Text(
                                                    context.l10n!.ages_13_or_above,
                                                    style:
                                                        AppTextStyles.customText16(
                                                          color: AppColors
                                                              .textLightBlack
                                                              .withOpacity(0.7),
                                                        ),
                                                  ),
                                                ),
                                                Divider(
                                                  color: AppColors
                                                      .textLightBlack
                                                      .withOpacity(0.2),
                                                ),
                                                _buildTravelersTile(
                                                  value:
                                                      controller.childrenCount,
                                                  title: context.l10n!.children,
                                                  subtitle: Text(
                                                    context.l10n!.ages_2_12,
                                                    style:
                                                        AppTextStyles.customText16(
                                                          color: AppColors
                                                              .textLightBlack
                                                              .withOpacity(0.7),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ).paddingFromAll(10.sp),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              controller.isEditingDays.value =
                                                  false;
                                              controller
                                                      .isEditingLocation
                                                      .value =
                                                  false;
                                              controller.isEditingBudget.value =
                                                  false;
                                              controller
                                                      .isEditingTravelers
                                                      .value =
                                                  true;
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      14.sp,
                                                    ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    context.l10n!.travelers,
                                                    style:
                                                        AppTextStyles.customText16(
                                                          color: AppColors
                                                              .textLightBlack,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                  ),
                                                  Text(
                                                    context.l10n!.add_travelers,
                                                    style:
                                                        AppTextStyles.customText16(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ],
                                              ).paddingFromAll(10.sp).paddingVertical(6.h),
                                            ),
                                          );
                                  }),
                                  10.h.height,
                                  Obx(() {
                                    return controller.isEditingBudget.value
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(14.sp),
                                            ),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    context.l10n!.budget,
                                                    style:
                                                        AppTextStyles.customText20(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                                15.h.height,
                                                Obx(() {
                                                  return DropDownWidget(
                                                    selectedValue: controller
                                                        .budgetValue
                                                        .value,
                                                    onChanged: (val) {
                                                      controller
                                                              .budgetValue
                                                              .value =
                                                          val ?? '';
                                                    },
                                                    itemsList: controller.items,
                                                    title: '',
                                                  );
                                                }),
                                              ],
                                            ).paddingFromAll(10.sp),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              Utils.showCustomDialog(
                                                context: context,
                                                child: CupertinoSelectionList(
                                                  items: controller.items,
                                                  onSelected: (val) {
                                                    controller
                                                            .budgetValue
                                                            .value =
                                                        val;
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      14.sp,
                                                    ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    context.l10n!.budget,
                                                    style:
                                                        AppTextStyles.customText16(
                                                          color: AppColors
                                                              .textLightBlack,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                  ),
                                                  Obx(
                                                    () => Text(
                                                      controller
                                                              .budgetValue
                                                              .value
                                                              .isEmpty
                                                          ? context.l10n!.add_budget
                                                          : controller
                                                                .budgetValue
                                                                .value,
                                                      style:
                                                          AppTextStyles.customText16(
                                                            color:
                                                                AppColors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ).paddingFromAll(10.sp).paddingVertical(6.h),
                                            ),
                                          );
                                  }),
                                  20.h.height,
                                  AppCustomButton(
                                    title: context.l10n!.next,
                                    onPressed: () {
                                      // ✅ Validation checks before navigating
                                      if (controller.selectedCityId.value
                                          .toString()
                                          .isEmpty) {
                                        CustomSnackbar.show(
                                          // iconData: Icons.warning_amber,
                                          textColor: AppColors.black,
                                          title: context.l10n!.error,
                                          message: "",
                                          backgroundColor: AppColors.white,
                                          iconColor: AppColors.black,
                                          borderColor: AppColors.black,
                                          messageText: [
                                            context.l10n!.please_select_a_destination,
                                          ],
                                        );
                                        return;
                                      }

                                      if (controller.startDate.value == null ||
                                          controller.endDate.value == null) {
                                        CustomSnackbar.show(
                                          // iconData: Icons.warning_amber,
                                          textColor: AppColors.black,
                                          title: context.l10n!.error,
                                          message: "",
                                          backgroundColor: AppColors.white,
                                          iconColor: AppColors.black,
                                          borderColor: AppColors.black,
                                          messageText: [
                                            context.l10n!.please_select_start_and_end_dates,
                                          ],
                                        );
                                        return;
                                      }

                                      final totalTravelers =
                                          controller.adultsCount.value +
                                          controller.childrenCount.value;
                                      if (totalTravelers == 0) {
                                        CustomSnackbar.show(
                                          // iconData: Icons.warning_amber,
                                          textColor: AppColors.black,
                                          title: context.l10n!.error,
                                          message: "",
                                          backgroundColor: AppColors.white,
                                          iconColor: AppColors.black,
                                          borderColor: AppColors.black,
                                          messageText: [
                                            context.l10n!.please_select_at_least_one_traveller,
                                          ],
                                        );
                                        return;
                                      }

                                      if (controller
                                          .budgetValue
                                          .value
                                          .isEmpty) {
                                        CustomSnackbar.show(
                                          // iconData: Icons.warning_amber,
                                          textColor: AppColors.black,
                                          title: context.l10n!.error,
                                          message: "",
                                          backgroundColor: AppColors.white,
                                          iconColor: AppColors.black,
                                          borderColor: AppColors.black,
                                          messageText: [
                                            context.l10n!.please_select_your_budget_range,
                                          ],
                                        );
                                        return;
                                      }

                                      // ✅ All validations passed → navigate to next page
                                      controller.pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ],
                              ).paddingFromAll(12.sp).paddingHorizontal(6.w),
                            ).paddingHorizontal(10.w).paddingBottom(0.h),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget _buildTravelersTile({
    required RxInt value,
    required String title,
    required Widget subtitle,
  }) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.customText18(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              3.h.height,
              subtitle,
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (value > 0) {
                    value.value--;
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppColors.textLightBlack.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '-',
                      style: AppTextStyles.customText22(
                        color: value.value == 0
                            ? AppColors.textLightBlack.withOpacity(0.2)
                            : Colors.black,
                        height: 0,
                      ),
                    ).paddingBottom(3.h),
                  ).paddingFromAll(10.sp),
                ),
              ),
              5.w.width,
              SizedBox(
                width: 20.w,
                child: Text(
                  value.toString(),
                  style: AppTextStyles.customText18(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              5.w.width,
              GestureDetector(
                onTap: () {
                  value.value++;
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppColors.textLightBlack.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+',
                      style: AppTextStyles.customText22(
                        color: Colors.black,
                        height: 0,
                      ),
                    ).paddingBottom(4.h),
                  ).paddingFromAll(10.sp),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class ImageThumbShape extends SliderComponentShape {
  final String imageAsset;
  final double size;
  static final Map<String, ui.Image> _cache = {}; // 🔹 cache images

  const ImageThumbShape({required this.imageAsset, this.size = 30});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(size, size);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    double topPadding = 3.h; // 🔹 Adjust this for more/less padding

    // if image is cached, draw immediately
    if (_cache.containsKey(imageAsset)) {
      final img = _cache[imageAsset]!;
      final dst = Rect.fromCenter(
        center: center.translate(0, topPadding), // 🔹 shift down
        width: size,
        height: size,
      );

      paintImage(canvas: canvas, rect: dst, image: img, fit: BoxFit.contain);
      return;
    }

    // if not cached, load once
    final assetImage = AssetImage(imageAsset);
    assetImage
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            _cache[imageAsset] = info.image; // cache it
            SchedulerBinding.instance.addPostFrameCallback((_) {
              parentBox.markNeedsPaint();
            });
          }),
        );
  }
}
