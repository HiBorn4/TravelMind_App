import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/model/api_response/iternitiy_resp_model.dart';
import 'package:vlad_ai/app/mvvm/view_model/plan_trip_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../config/app_text_style.dart';
import '../../../customWidgets/custom_cache_image/custom_cached_image.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';

class ToursView extends StatefulWidget {
  const ToursView({super.key, this.itineraryId});
  final String? itineraryId;
  @override
  State<ToursView> createState() => _ToursViewState();
}

class _ToursViewState extends State<ToursView> {
  late final PlanTripController controller;
  final ScrollController _scrollController = ScrollController();

  // Track selected slots locally (don't rely on model having isSelected)
  final Set<SlotItr> _selectedSlots = {};
  // DateTime start = DateTime.now();
  // DateTime end = DateTime.now().add(Duration(hours: 5));
  // bool allDay = false;

  @override
  void initState() {
    super.initState();
    // Get or create controller - handles both navigation from plan trip and from saved trips
    controller = Get.isRegistered<PlanTripController>()
        ? Get.find<PlanTripController>()
        : Get.put(PlanTripController());

    // Get itineraryId from widget param OR route arguments
    final String? id = widget.itineraryId ?? (Get.arguments as String?);
    if (id != null) {
      controller.getItineryById(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.itineraryId != null) {
          Get.back();
        } else {
          Get.offAllNamed(AppRoutes.bottomBarView);
        }
        return Future.value(widget.itineraryId != null);
      },
      child: Obx(
        () => controller.isDataLoading.value
            ? Scaffold(body: Center(child: CustomLoader()))
            : Scaffold(
                body: Obx(() {
                  final itinerary =
                      controller.itineraryIt?.value ??
                      controller.iterneityResponseModel.value?.itinerary;
                  final itineraryData =
                      controller.itineraryIt?.value.itineraryData ??
                      controller
                          .iterneityResponseModel
                          .value
                          ?.itinerary
                          .itineraryData;

                  // Handle null data gracefully
                  if (itinerary == null ||
                      itineraryData == null ||
                      itinerary.id == null) {
                    return Container(
                      height: ScreenUtil().screenHeight,
                      width: ScreenUtil().screenWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppAssets.scaffoldBg),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const Center(child: CustomLoader()),
                    );
                  }

                  return Container(
                    height: ScreenUtil().screenHeight,
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppAssets.scaffoldBg),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        50.h.height,
                        _buildHeader(itinerary),
                        20.h.height,
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: _buildDayWidgets(
                                itineraryData,
                                itinerary.id!,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).paddingHorizontal(16.w),
                  );
                }),
              ),
      ),
    );
  }

  Widget _buildHeader(ItineraryItr? itinerary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.itineraryId != null) {
                  Get.back();
                } else {
                  Get.offAllNamed(AppRoutes.bottomBarView);
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20.sp,
              ),
            ),
            5.w.width,
            //TODO: add city image here
            // CustomCachedImage(
            //   height: 30.sp,
            //   width: 30.sp,
            //   imageUrl: io,
            //   borderRadius: 8.sp,
            // ),
            4.w.width,
            SizedBox(
              // width: 150.w,
              child: Text(
                itinerary?.city?.name ?? context.l10n!.select_a_city,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.customText24(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        // SvgPicture.asset(AppAssets.forwardIcon),
      ],
    );
  }

  // 🔹 Build widgets for each day
  List<Widget> _buildDayWidgets(
    ItineraryDataItr? itineraryData,
    String itinereryId,
  ) {
    if (itineraryData == null) {
      return [
        Center(
          child: Text(
            context.l10n!.no_itinerary_data_available,
            style: AppTextStyles.customText16(color: Colors.black),
          ),
        ),
      ];
    }

    final days = [
      itineraryData.day1,
      itineraryData.day2,
      itineraryData.day3,
      itineraryData.day4,
      itineraryData.day5,
      itineraryData.day6,
      itineraryData.day7,
    ];

    List<Widget> dayWidgets = [];
    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      if (day.slots.isNotEmpty) {
        dayWidgets.add(_buildDaySection(day, i + 1, itinereryId));
        dayWidgets.add(20.h.height);
      }
    }
    return dayWidgets;
  }

  // 🔹 Build a single day section with manual drag and drop
  Widget _buildDaySection(DayItr day, int dayNumber, String itinereryId) {
    final dayIndex = dayNumber - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${context.l10n!.day} $dayNumber ${DateFormat('E, d MMM').format(day.date)}',
                  style: AppTextStyles.customText16(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        20.h.height,
        // Build slot items with drag and drop
        ...List.generate(day.slots.length, (index) {
          final slot = day.slots[index];
          final isSelected = _selectedSlots.contains(slot);

          return LongPressDraggable<Map<String, dynamic>>(
            key: ValueKey('drag_${slot.slotId}'),
            data: {
              'slotId': slot.slotId,
              'dayIndex': dayIndex,
            },
            feedback: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(10.r),
              shadowColor: Colors.black38,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 32.w,
                child: Opacity(
                  opacity: 0.9,
                  child: _buildSlotTile(slot, itinereryId, showSelectedBorder: false),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildSlotTile(slot, itinereryId, showSelectedBorder: false),
            ),
            onDragStarted: () {
              HapticFeedback.mediumImpact();
            },
            child: DragTarget<Map<String, dynamic>>(
              key: ValueKey('target_${slot.slotId}'),
              onWillAcceptWithDetails: (details) {
                final draggedSlotId = details.data['slotId'] as String;
                return draggedSlotId != slot.slotId;
              },
              onAcceptWithDetails: (details) async {
                final draggedSlotId = details.data['slotId'] as String;
                final fromDayIndex = details.data['dayIndex'] as int;

                // Only allow same-day reordering
                if (fromDayIndex != dayIndex) {
                  CustomSnackbar.show(
                    textColor: AppColors.black,
                    title: "Cannot Move",
                    message: "",
                    backgroundColor: AppColors.white,
                    iconColor: AppColors.black,
                    borderColor: AppColors.black,
                    messageText: ["You can only reorder within the same day"],
                  );
                  return;
                }

                final targetDay = _getDayByIndex(dayIndex);
                if (targetDay == null) return;

                // Find indices
                final fromIndex = targetDay.slots.indexWhere((s) => s.slotId == draggedSlotId);
                final toIndex = targetDay.slots.indexWhere((s) => s.slotId == slot.slotId);

                if (fromIndex == -1 || toIndex == -1 || fromIndex == toIndex) return;

                log('Reorder: from=$fromIndex to=$toIndex, slots before: ${targetDay.slots.map((s) => s.selected.name).toList()}');

                // Perform the reorder locally
                final movedSlot = targetDay.slots.removeAt(fromIndex);
                // Clamp toIndex to valid range after removal
                final insertIndex = toIndex.clamp(0, targetDay.slots.length);
                targetDay.slots.insert(insertIndex, movedSlot);

                log('Slots after reorder: ${targetDay.slots.map((s) => s.selected.name).toList()}');

                // Force both StatefulWidget and GetX to rebuild
                setState(() {});
                controller.itineraryIt?.refresh();
                controller.iterneityResponseModel.refresh();

                // Call API with all slot IDs from the same data source as UI
                final itrData = _getItineraryData();
                if (itrData != null) {
                  final allSlotIds = itrData.getAllSlotIds();
                  log('All slot IDs after reorder: $allSlotIds');

                  final success = await controller.reorderSlots(itinereryId, allSlotIds);
                  if (success) {
                    // Small delay to ensure data is fully updated
                    await Future.delayed(const Duration(milliseconds: 100));
                    // Refresh UI with updated times from backend
                    controller.itineraryIt?.refresh();
                    controller.iterneityResponseModel.refresh();
                    if (mounted) setState(() {});
                    log('Reorder successful - UI refreshed with updated times');
                  } else {
                    // Revert local change on failure - reload from server
                    await controller.getItineryById(itinereryId);
                    CustomSnackbar.show(
                      textColor: AppColors.black,
                      title: context.l10n!.error,
                      message: "",
                      backgroundColor: AppColors.white,
                      iconColor: AppColors.black,
                      borderColor: AppColors.black,
                      messageText: ["Failed to save reorder. Please try again."],
                    );
                  }
                }
              },
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: isHovering
                        ? Border.all(color: AppColors.black.withOpacity(0.3), width: 2)
                        : null,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_selectedSlots.contains(slot)) {
                          _selectedSlots.remove(slot);
                        } else {
                          _selectedSlots.add(slot);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: _buildSlotTile(
                      slot,
                      itinereryId,
                      showSelectedBorder: isSelected,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  // 🔹 Helper to get the current itinerary data (same source as UI)
  ItineraryDataItr? _getItineraryData() {
    return controller.itineraryIt?.value.itineraryData ??
        controller.iterneityResponseModel.value?.itinerary.itineraryData;
  }

  // 🔹 Helper to get a Day by index
  DayItr? _getDayByIndex(int index) {
    final data = _getItineraryData();
    switch (index) {
      case 0:
        return data?.day1;
      case 1:
        return data?.day2;
      case 2:
        return data?.day3;
      case 3:
        return data?.day4;
      case 4:
        return data?.day5;
      case 5:
        return data?.day6;
      case 6:
        return data?.day7;
      default:
        return null;
    }
  }

  // 🔹 Existing slot tile - unchanged layout, with optional selected border
  Widget _buildSlotTile(
    SlotItr slot,
    String itineraryId, {
    bool showSelectedBorder = false,
  }) {
    final selected = slot.selected;
    final imageUrl = selected.images.isNotEmpty
        ? selected.images.first
        : 'https://images.pexels.com/photos/9754/mountains-clouds-forest-fog.jpg';
    final isAccommodation =
        slot.type == AccommodationCategoryTypeItr.ACCOMMODATION;
    // keep the original content exactly as before, just add optional outer padding/border handling
    return DayOfWeekWidget(
      imageUrl: imageUrl,
      selected: selected,
      // controller: controller,
      itenaryId: itineraryId,
      isAccommodation: isAccommodation,
      context: context,
      showSelectedBorder: _selectedSlots.contains(slot),
      slotItr: slot,
    );
  }
}

class DayOfWeekWidget extends StatefulWidget {
  const DayOfWeekWidget({
    super.key,
    required this.imageUrl,
    required this.selected,
    required this.isAccommodation,
    required this.context,
    required this.slotItr,
    required this.showSelectedBorder,
    // required this.controller,
    required this.itenaryId,
  });

  final String imageUrl;
  final SelectedItr selected;
  final bool isAccommodation;
  final BuildContext context;
  final SlotItr slotItr;
  final bool showSelectedBorder;
  // final PlanTripController controller;
  final String itenaryId;
  @override
  State<DayOfWeekWidget> createState() => _DayOfWeekWidgetState();
}

class _DayOfWeekWidgetState extends State<DayOfWeekWidget> {
  TimeOfDay start = TimeOfDay.now();
  TimeOfDay end = TimeOfDay.now();
  calculateTime(bool second) {
    if (!second) {
      start = TimeOfDay(
        hour: int.parse(widget.slotItr.time.substring(0, 2)),
        minute: int.parse(widget.slotItr.time.substring(3, 5)),
      );
    }
    end = TimeOfDay.fromDateTime(
      DateTime.now()
          .copyWith(hour: start.hour, minute: start.minute)
          .copyWith()
          .add(Duration(minutes: widget.selected.durationMinutes ?? 0)),
    );
    setState(() {});
  }

  @override
  void initState() {
    calculateTime(false);
    super.initState();
  }

  ExpansibleController expansibleController = ExpansibleController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // widget.slotItr.selected.id
            Get.toNamed(
              AppRoutes.hotelDetailView,
              arguments: widget.slotItr.selected.id,
            );
          },
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: widget.showSelectedBorder
                          ? Colors.transparent
                          : Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  child: ListTile(
                    // tilePadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 0,
                    ),
                    // collapsedShape: RoundedRectangleBorder(
                    //   side: BorderSide(color: Colors.transparent),
                    //   borderRadius: BorderRadius.circular(16.sp),
                    // ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(16.sp),
                    ),
                    // showTrailingIcon: false,
                    // childrenPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomCachedImage(
                              height: 50.sp,
                              width: 50.sp,
                              imageUrl: widget.imageUrl,
                              borderRadius: 8.sp,
                            ),
                            10.w.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 170.w,
                                  child: Text(
                                    widget.selected.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.customText16(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                4.h.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      color: AppColors.textLightBlack
                                          .withOpacity(0.7),
                                      size: 15.sp,
                                    ),
                                    5.w.width,
                                    Text(
                                      widget.slotItr.time,
                                      style: AppTextStyles.customText12(
                                        color: AppColors.textLightBlack
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    10.w.width,
                                    SvgPicture.asset(
                                      widget.isAccommodation
                                          ? AppAssets.hotelIcon
                                          : AppAssets.hotelIcon,
                                    ),
                                    5.w.width,
                                    Text(
                                      widget.slotItr.type ==
                                              AccommodationCategoryTypeItr
                                                  .ACCOMMODATION
                                          ? 'Accommodation'
                                          : widget.slotItr.type ==
                                                AccommodationCategoryTypeItr
                                                    .RESTAURANT
                                          ? 'Restaurant'
                                          : "Attraction",
                                      style: AppTextStyles.customText12(
                                        color: AppColors.textLightBlack
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Icon(Icons.more_horiz_outlined, color: Colors.black, size: 20.sp),
                      ],
                    ).paddingVertical(4.h),
                  ),

                  // CustomExpandableTile(
                  //   initiallyExpanded: false,
                  //   expansibleController: expansibleController,
                  //   title: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           CustomCachedImage(
                  //             height: 50.sp,
                  //             width: 50.sp,
                  //             imageUrl: widget.imageUrl,
                  //             borderRadius: 8.sp,
                  //           ),
                  //           10.w.width,
                  //           Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               SizedBox(
                  //                 width: 170.w,
                  //                 child: Text(
                  //                   widget.selected.name,
                  //                   maxLines: 2,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   style: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w600),
                  //                 ),
                  //               ),
                  //               4.h.height,
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.start,
                  //                 children: [
                  //                   Icon(
                  //                     Icons.access_time_rounded,
                  //                     color: AppColors.textLightBlack.withOpacity(0.7),
                  //                     size: 15.sp,
                  //                   ),
                  //                   5.w.width,
                  //                   Text(
                  //                     widget.slotItr.time,
                  //                     style: AppTextStyles.customText12(
                  //                       color: AppColors.textLightBlack.withOpacity(0.7),
                  //                     ),
                  //                   ),
                  //                   10.w.width,
                  //                   SvgPicture.asset(
                  //                     widget.isAccommodation ? AppAssets.hotelIcon : AppAssets.hotelIcon,
                  //                   ),
                  //                   5.w.width,
                  //                   Text(
                  //                     widget.slotItr.type == AccommodationCategoryTypeItr.ACCOMMODATION
                  //                         ? 'Accommodation'
                  //                         : widget.slotItr.type == AccommodationCategoryTypeItr.RESTAURANT
                  //                         ? 'Restaurant'
                  //                         : "Attraction",
                  //                     style: AppTextStyles.customText12(
                  //                       color: AppColors.textLightBlack.withOpacity(0.7),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //       Icon(Icons.more_horiz_outlined, color: Colors.black, size: 20.sp),
                  //     ],
                  //   ).paddingVertical(4.h),

                  //   //TODO: implement slot details here
                  //   child: SizedBox.shrink(),
                  //   // Column(
                  //   //   children: [
                  //   //     // ignore: deprecated_member_use
                  //   //     // Divider(color: AppColors.textLightBlack.withOpacity(0.2)),
                  //   //     // 10.h.height,
                  //   //     // Row(
                  //   //     //   mainAxisAlignment: MainAxisAlignment.center,
                  //   //     //   children: [
                  //   //     //     ShowPicker(
                  //   //     //       time: start,
                  //   //     //       onTap: () async {
                  //   //     //         final date = await showCupertinoTimePicker(
                  //   //     //           context,
                  //   //     //           use24hFormat: true,
                  //   //     //           widgetRenderBox: context.findRenderObject() as RenderBox,
                  //   //     //         );
                  //   //     //         if (date != null) {
                  //   //     //           start = date;
                  //   //     //           setState(() {});
                  //   //     //           calculateTime(true);
                  //   //     //         }
                  //   //     //       },
                  //   //     //     ),
                  //   //     //     Text(' - '),
                  //   //     //     Container(
                  //   //     //       decoration: BoxDecoration(
                  //   //     //         borderRadius: BorderRadius.circular(50.sp),
                  //   //     //         color: AppColors.textLightBlack.withOpacity(0.1),
                  //   //     //       ),
                  //   //     //       child: Center(
                  //   //     //         child: Text(
                  //   //     //           DateFormat.Hm().format(DateTime.now().copyWith(minute: end.minute, hour: end.hour)),
                  //   //     //           textAlign: TextAlign.center,
                  //   //     //           style: AppTextStyles.customText14(color: AppColors.black),
                  //   //     //         ).paddingVertical(10.h).paddingHorizontal(16.w),
                  //   //     //       ),
                  //   //     //     ),

                  //   //     //     // Spacer(),
                  //   //     //     // Row(
                  //   //     //     //   mainAxisAlignment: MainAxisAlignment.start,
                  //   //     //     //   children: [
                  //   //     //     // GestureDetector(
                  //   //     //     //   onTap: () {
                  //   //     //     //   },
                  //   //     //     //   child: Container(
                  //   //     //     //     decoration: BoxDecoration(
                  //   //     //     //       borderRadius: BorderRadius.circular(50.sp),
                  //   //     //     //       color: AppColors.textLightBlack.withOpacity(0.1),
                  //   //     //     //     ),
                  //   //     //     //     child: Center(
                  //   //     //     //       child: Text(
                  //   //     //     //         "People usually spend\n${(selected.durationMinutes ?? 0) > 0 ? Duration(minutes: selected.durationMinutes ?? 0).inHours : Duration(minutes: selected.durationMinutes ?? 0).inMinutes}${(selected.durationMinutes ?? 0) > 0 ? 'h' : 'm'} at this place",
                  //   //     //     //         textAlign: TextAlign.center,
                  //   //     //     //         style: AppTextStyles.customText12(color: AppColors.black),
                  //   //     //     //       ).paddingVertical(6.h).paddingHorizontal(17.w),
                  //   //     //     //     ),
                  //   //     //     //   ),
                  //   //     //     // ),
                  //   //     //     //   ],
                  //   //     //     // ),
                  //   //     //     // Row(
                  //   //     //     //   mainAxisAlignment: MainAxisAlignment.end,
                  //   //     //     //   children: [
                  //   //     //     //     Text(
                  //   //     //     //       'All Day',
                  //   //     //     //       style: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w500),
                  //   //     //     //     ),
                  //   //     //     //     //TODO: implement is all day
                  //   //     //     //     Transform.scale(
                  //   //     //     //       scale: 0.8,
                  //   //     //     //       child: CupertinoSwitch(
                  //   //     //     //         inactiveTrackColor: AppColors.grey.withOpacity(0.3),
                  //   //     //     //         inactiveThumbColor: AppColors.white,
                  //   //     //     //         value: false,
                  //   //     //     //         activeTrackColor: AppColors.secondaryBlack,
                  //   //     //     //         onChanged: (val) {
                  //   //     //     //           // allDay = val;
                  //   //     //     //           // setState(() {});
                  //   //     //     //         },
                  //   //     //     //       ),
                  //   //     //     //     ),
                  //   //     //     //   ],
                  //   //     //     // ),
                  //   //     //   ],
                  //   //     // ),
                  //   //     // Divider(color: AppColors.textLightBlack.withOpacity(0.2)),
                  //   //     // 10.h.height,
                  //   //     // Row(
                  //   //     //   children: [
                  //   //     //     // Expanded(
                  //   //     //     //   child: AppCustomButton(
                  //   //     //     //     height: 35.h,
                  //   //     //     //     title: 'Reset',
                  //   //     //     //     bgColor: Colors.transparent,
                  //   //     //     //     textStyle: AppTextStyles.customText16(
                  //   //     //     //       color: AppColors.secondaryBlack,
                  //   //     //     //       fontWeight: FontWeight.w600,
                  //   //     //     //     ),
                  //   //     //     //     borderColor: AppColors.secondaryBlack,
                  //   //     //     //     onPressed: () {
                  //   //     //     //       // TODO: impement reset functionality
                  //   //     //     //     },
                  //   //     //     //   ),
                  //   //     //     // ),
                  //   //     //     // 15.w.width,
                  //   //     //     Expanded(
                  //   //     //       child: AppCustomButton(
                  //   //     //         height: 35.h,
                  //   //     //         title: 'Confirm',
                  //   //     //         onPressed: () async {
                  //   //     //           await widget.controller.updateSlot(
                  //   //     //             widget.itenaryId,
                  //   //     //             widget.slotItr.slotId,
                  //   //     //             DateFormat("HH:mm").format(DateFormat.jm().parse(start.format(context))),
                  //   //     //           );
                  //   //     //           expansibleController.collapse();
                  //   //     //         },
                  //   //     //       ),
                  //   //     //     ),
                  //   //     //   ],
                  //   //     // ),
                  //   //   ],
                  //   // ),
                  // ),
                ),
              ),
              10.w.width,
              SvgPicture.asset(AppAssets.optionsIcon),
              10.w.width,
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 10.h,
              width: 1.w,
              color: AppColors.grey.withOpacity(00),
            ),
          ],
        ).paddingLeft(30.w),
      ],
    );
  }
}

class ShowPicker extends StatelessWidget {
  const ShowPicker({super.key, this.onTap, required this.time});
  final void Function()? onTap;
  final TimeOfDay time;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.sp),
          color: AppColors.textLightBlack.withOpacity(0.1),
        ),
        child: Center(
          child: Text(
            DateFormat.Hm().format(
              DateTime.now().copyWith(hour: time.hour, minute: time.minute),
            ),
            textAlign: TextAlign.center,
            style: AppTextStyles.customText14(color: AppColors.black),
          ).paddingVertical(10.h).paddingHorizontal(16.w),
        ),
      ),
    );
  }
}

class CustomExpandableTile extends StatefulWidget {
  final Widget title;
  final Widget child;
  final bool initiallyExpanded;
  final ExpansibleController expansibleController;
  const CustomExpandableTile({
    super.key,
    required this.title,
    required this.child,
    required this.initiallyExpanded,
    required this.expansibleController,
  });

  @override
  State<CustomExpandableTile> createState() => _CustomExpandableTileState();
}

class _CustomExpandableTileState extends State<CustomExpandableTile> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.sp),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: widget.expansibleController,
          tilePadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          dense: true,
          collapsedShape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(16.sp),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(16.sp),
          ),
          showTrailingIcon: false,
          childrenPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          title: widget.title,
          initiallyExpanded: _expanded,
          onExpansionChanged: (value) {
            if (widget.child != SizedBox.shrink()) {
              setState(() => _expanded = value);
            }
          },
          children: [
            Container(
              padding: EdgeInsets.all(
                widget.child == SizedBox.shrink() ? 0 : 12,
              ),
              alignment: Alignment.centerLeft,
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

class SlotTransferData {
  final SlotItr slot;
  final int sourceDayIndex;

  SlotTransferData(this.slot, this.sourceDayIndex);
}
