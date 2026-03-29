import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../customWidgets/map_widget.dart';
import '../../view_model/map_controller.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final AppMapController controller = Get.find();
  String? from;

  @override
  void initState() {
    if (Get.arguments != null) from = Get.arguments['from'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: from == 'suggest'
      //     ? SizedBox.shrink()
      //     : SafeArea(
      //         child: SizedBox(
      //           width: 55.sp,
      //           height: 55.sp,
      //           child: RawMaterialButton(
      //             onPressed: () {
      //               // if (controller.selectedCityId == null) {
      //               //   CustomSnackbar.show(
      //               //     // iconData: Icons.warning_amber,
      //               //     textColor: AppColors.black,
      //               //     title: "Error",
      //               //     message: "Please select a city first.",
      //               //     backgroundColor: AppColors.white,
      //               //     iconColor: AppColors.black,
      //               //     borderColor: AppColors.black,
      //               //     messageText: ["Please select a city first."],
      //               //   );
      //               // } else {
      //               Get.toNamed(
      //                 AppRoutes.newPlaceView,
      //                 arguments: controller.selectedCityId,
      //               );
      //               // }
      //             },
      //             fillColor: Colors.black,
      //             shape: const CircleBorder(),
      //             elevation: 6.0,
      //             child: Icon(Icons.add, color: Colors.white, size: 30.sp),
      //           ),
      //         ).paddingBottom(100.h),
      //       ),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                controller.isHotelVisible.value = true;
              },
              child: SizedBox(
                height: ScreenUtil().screenHeight,
                width: ScreenUtil().screenWidth,
                child: ProjectionMapWidget(
                  controller: controller,
                  from: from ?? "",
                ),
              ),
            ),

            // Markers loading overlay
            // Obx(() => controller.isMarkersLoading.value
            //     ? Container(
            //         color: Colors.black.withValues(alpha: 0.3),
            //         child: Center(
            //           child: Container(
            //             padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               borderRadius: BorderRadius.circular(12.sp),
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.black.withValues(alpha: 0.1),
            //                   blurRadius: 10,
            //                   offset: const Offset(0, 4),
            //                 ),
            //               ],
            //             ),
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 SizedBox(
            //                   width: 32.sp,
            //                   height: 32.sp,
            //                   child: CircularProgressIndicator(
            //                     strokeWidth: 3,
            //                     valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
            //                   ),
            //                 ),
            //                 12.h.height,
            //                 Text(
            //                   'Loading places...',
            //                   style: AppTextStyles.customText14(
            //                     color: AppColors.black,
            //                     fontWeight: FontWeight.w500,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            //     : const SizedBox.shrink()),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    25.h.height,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.sp),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Obx(
                        () => TextFormField(
                          controller: TextEditingController.fromValue(
                            controller.selectedCity.value != null
                                ? TextEditingValue(
                                    text:
                                        "${controller.selectedCity.value!.name ?? ''}, ${controller.selectedCity.value!.region ?? ''}",
                                    selection: TextSelection.collapsed(
                                      offset:
                                          controller
                                              .selectedCity
                                              .value!
                                              .name
                                              ?.length ??
                                          0,
                                    ),
                                  )
                                : const TextEditingValue(text: ''),
                          ),
                          textInputAction: TextInputAction.search,
                          readOnly: true,
                          onTap: () {
                            Get.toNamed(AppRoutes.searchOnMapView);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            fillColor: Colors.white,
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(4.sp),
                              child: RawMaterialButton(
                                onPressed: () {
                                  Get.toNamed(
                                    AppRoutes.newPlaceView,
                                    arguments: controller.selectedCityId,
                                  );
                                },
                                fillColor: Colors.black,
                                constraints: BoxConstraints(
                                  minWidth: 32.sp,
                                  minHeight: 32.sp,
                                  maxWidth: 32.sp,
                                  maxHeight: 32.sp,
                                ),
                                shape: const CircleBorder(),
                                elevation: 2.0,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 23.sp,
                                ),
                              ),
                            ),
                            prefixIcon: SvgPicture.asset(
                              AppAssets.searchIcon,
                            ).paddingFromAll(10.sp),
                            hintText: context.l10n!.search_for_places_cities,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 5,
                            ),
                            hintStyle: AppTextStyles.customText14(
                              color: AppColors.textLightBlack,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.sp),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.sp),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.sp),
                              borderSide: BorderSide(
                                color: AppColors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ).paddingHorizontal(17.w),
                    10.h.height,
                    Obx(() {
                      return controller.isCategoriesLoading.value
                          ? Text('- - -')
                          : SizedBox(
                              height: 35.h,
                              child: Obx(() {
                                final categories =
                                    controller.cityCategoriesList.value ?? [];
                                if (categories.isEmpty) {
                                  return Center(
                                    child: Text(context.l10n!.no_categories_available),
                                  );
                                }
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.only(left: 17.w),
                                  child: Row(
                                    children: categories.map((cat) {
                                      final isActive =
                                          controller
                                              .selectedCategory
                                              .value
                                              ?.id ==
                                          cat.id;
                                      return GestureDetector(
                                        onTap: () {
                                          if (isActive) {
                                            controller
                                                .clearCategory(); // deselect
                                          } else {
                                            controller.selectCategory(
                                              cat,
                                            ); // select
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10.w),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 14.w,
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? AppColors.black
                                                : AppColors.white,
                                            borderRadius: BorderRadius.circular(
                                              50.sp,
                                            ),
                                            border: Border.all(
                                              color: isActive
                                                  ? AppColors.black
                                                  : AppColors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: Text(
                                            cat.name ?? '',
                                            style: AppTextStyles.customText14(
                                              color: isActive
                                                  ? AppColors.white
                                                  : AppColors.black,
                                              fontWeight: isActive
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }),
                            );
                    }),
                  ],
                ),
                // Obx(() {
                //   return controller.isHotelVisible.value
                //       ? Column(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Align(
                //               alignment: Alignment.centerRight,
                //               child: GestureDetector(
                //                 onTap: () {
                //                   controller.isHotelVisible.value = false;
                //                 },
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     color: Colors.white,
                //                     shape: BoxShape.circle,
                //                   ),
                //                   child: Icon(
                //                     Icons.close,
                //                     color: Colors.black,
                //                     size: 20.sp,
                //                   ).paddingFromAll(10.sp),
                //                 ),
                //               ),
                //             ).paddingHorizontal(17.w),
                //             15.h.height,
                //           ],
                //         )
                //       : SizedBox.shrink();
                // }).paddingBottom(120.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
