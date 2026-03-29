import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:vlad_ai/app/config/app_assets.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view/view%20photos/view_photos_scree.dart';
import 'package:vlad_ai/app/mvvm/view_model/favs_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/hotel_detail_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import 'package:vlad_ai/app/mvvm/view_model/chat_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/bottom_bar_controller.dart';

import 'package:vlad_ai/app/config/app_routes.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_style.dart';
import '../../../customWidgets/custom_cache_image/custom_cached_image.dart';

class HotelDetailView extends StatefulWidget {
  const HotelDetailView({super.key, this.markerId});
  final String? markerId;
  @override
  State<HotelDetailView> createState() => _HotelDetailViewState();
}

class _HotelDetailViewState extends State<HotelDetailView> {
  late final String _controllerTag;
  late final HotelDetailController controller;
  final FavsController controllerFav = Get.put(FavsController());
  final TextEditingController askAnythingController = TextEditingController();
  final images = [
    "https://images.unsplash.com/photo-1504384308090-c894fdcc538d", // Office teamwork
    "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61", // People working laptops
    "https://images.unsplash.com/photo-1507679799987-c73779587ccf", // Job interview
    "https://images.unsplash.com/photo-1551836022-d5d88e9218df", // Man at desk
    "https://images.unsplash.com/photo-1521737604893-d14cc237f11d", // Group discussion
  ];

  final amenities = [
    {"icon": AppAssets.burgerIcon, "title": "Restaurant"},
    {"icon": AppAssets.tvIcon, "title": "Television"},
    {"icon": AppAssets.gymIcon, "title": "Gym"},
    {"icon": AppAssets.webIcon, "title": "Internet"},
  ];

  /// Safely gets today's schedule info, returns null if closed or no data
  Map<String, dynamic>? _getTodaySchedule() {
    final weeklySchedule = controller.cityDetails?.item?.weeklySchedule;
    if (weeklySchedule == null) return null;

    final dayName = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    final daySchedule = weeklySchedule[dayName];
    if (daySchedule == null) return null;

    final periods = daySchedule['periods'] as List?;
    if (periods == null || periods.isEmpty) return null;

    final firstPeriod = periods.first as Map<String, dynamic>?;
    if (firstPeriod == null) return null;

    return {
      'openTime': firstPeriod['openTime']?.toString() ?? '00:00',
      'closeTime': firstPeriod['closeTime']?.toString() ?? '00:00',
    };
  }

  /// Checks if currently open based on schedule
  Color _getStatusColor() {
    final schedule = _getTodaySchedule();
    if (schedule == null) return AppColors.negativeRed;

    try {
      final openParts = schedule['openTime']!.split(':');
      final closeParts = schedule['closeTime']!.split(':');

      final openTime = DateTime.now().copyWith(
        hour: int.parse(openParts.first),
        minute: int.parse(openParts.last.substring(0, 2)),
      );
      final closeTime = DateTime.now().copyWith(
        hour: int.parse(closeParts.first),
        minute: int.parse(closeParts.last.substring(0, 2)),
      );

      return isBewteenTwoDates(DateTime.now(), openTime, closeTime)
          ? AppColors.positiveGreen
          : AppColors.negativeRed;
    } catch (_) {
      return AppColors.negativeRed;
    }
  }

  /// Gets formatted hours string
  String _getHoursText() {
    final schedule = _getTodaySchedule();
    if (schedule == null) return 'Closed';

    try {
      final open = schedule['openTime']!.substring(0, 5);
      final close = schedule['closeTime']!.substring(0, 5);
      return '$open - $close';
    } catch (_) {
      return 'Closed';
    }
  }

  void _navigateToChatWithContext() async {
  final userQuery = askAnythingController.text.trim();
  
  if (userQuery.isEmpty) {
    Get.snackbar(
      'Empty Query',
      'Please type your question first',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.negativeRed.withOpacity(0.8),
      colorText: Colors.white,
      margin: EdgeInsets.all(15.w),
    );
    return;
  }

  try {
    // Get hotel context
    final hotelContext = controller.getHotelContextForChat();
    
    // Create the full query with context (for API)
    final fullQuery = '''$userQuery

[Context: User is asking about the following hotel/place]
$hotelContext''';

    // Store in a temporary variable accessible after navigation
    final queryToSend = userQuery;
    final contextQuery = fullQuery;
    
    
    // Clear the input field
    askAnythingController.clear();
    
    // Navigate back to bottom bar
    Get.back();
    
    // Use Get.until to ensure we're back at BottomBarView
    Get.until((route) => route.settings.name == AppRoutes.bottomBarView);
    
    // Now we're definitely at BottomBarView, proceed
    await Future.delayed(Duration(milliseconds: 200));
    
    // Get controllers
    final bottomBarController = Get.find<BottomBarController>();
    final chatController = Get.find<ChatController>();
    
    // Set data
    chatController.messageController.text = queryToSend;
    chatController.fullContextQuery = contextQuery;
    
    // Switch to chat tab
    bottomBarController.selectedIndex.value = 0;
    
    // Wait and send
    await Future.delayed(Duration(milliseconds: 400));
    chatController.initalMessage();
    
  } catch (e) {
    print('Navigation error: $e');
    Get.snackbar(
      'Error',
      'Failed to navigate to chat. Error: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.negativeRed.withOpacity(0.8),
      colorText: Colors.white,
      margin: EdgeInsets.all(15.w),
      duration: Duration(seconds: 3),
    );
  }
}


  @override
  void initState() {
    super.initState();
    final String? id = widget.markerId ?? Get.arguments;
    // Create a unique controller for each page instance
    _controllerTag = 'hotel_detail_$id';
    controller = Get.put(HotelDetailController(), tag: _controllerTag);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCityDetails(id.toString());
    });
  }

  @override
  void dispose() {
    askAnythingController.dispose();
    Get.delete<HotelDetailController>(tag: _controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return controller.isDetailsLoading.value
            ? CustomLoader()
            : Stack(
                children: [
                  SizedBox(
                    height: ScreenUtil().screenHeight * 0.58,
                    width: ScreenUtil().screenWidth,
                    child: CustomCachedImage(
                      height: ScreenUtil().screenHeight * 0.58,
                      width: double.infinity,
                      imageUrl:
                          controller.cityDetails?.item?.images?[0] ?? images[0],
                      borderRadius: 0.sp,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        GestureDetector(
                          // onTap: () {
                          //   print(true);
                          //   Utils.showCustomDialog(
                          //     context: context,
                          //     child: JobImagesDialog(imageUrls: images),
                          //   );
                          // },
                          onTap: () {
                            //   onTap: () {
                            // Utils.showCustomDialog(
                            //   context: context,
                            //   child: JobImagesDialog(imageUrls: controller.cityDetails?.item?.images ?? images),
                            // );
                            Get.to(
                              () => PhotoViewScreen(
                                photos:
                                    controller.cityDetails?.item?.images ??
                                    images,
                              ),
                            );
                            //   },
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: SvgPicture.asset(AppAssets.backButton),
                                ).paddingLeft(0.w),
                                Column(
                                  children: [
                                    SizedBox(height: 25.h),
                                    GestureDetector(
                                      onTap: () async {
                                        final res = await controllerFav
                                            .postFavs(
                                              controller.cityDetails?.type ??
                                                  '',
                                              controller
                                                      .cityDetails
                                                      ?.item
                                                      ?.id ??
                                                  '',
                                            );
                                        controller
                                                .cityDetails
                                                ?.item!
                                                .isFavoritedByMe =
                                            res;
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                          bottom: 10,
                                        ),
                                        child: Align(
                                          alignment: AlignmentGeometry.topRight,
                                          child: Container(
                                            padding: EdgeInsets.all(10.sp),
                                            decoration: BoxDecoration(
                                              color: controller.cityDetails?.item?.isFavoritedByMe ?? false
                                                  ? Colors.red
                                                  : Colors.white.withOpacity(0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                              AppAssets.heartIcon,
                                              height: 20.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        // ignore: deprecated_member_use
                                        if (await canLaunch(
                                          'tel: ${controller.cityDetails?.item?.phone}',
                                        )) {
                                          // ignore: deprecated_member_use
                                          await launch(
                                            'tel: ${controller.cityDetails?.item?.phone}',
                                          );
                                        } else {
                                          throw 'Could not launch tel: ${controller.cityDetails?.item?.phone}l';
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                          bottom: 10,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(10.sp),
                                          decoration: BoxDecoration(
                                            // ignore: deprecated_member_use
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            AppAssets.callIcon,
                                            height: 20.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        // ignore: deprecated_member_use
                                        if (await canLaunch(
                                          controller
                                                  .cityDetails
                                                  ?.item
                                                  ?.googleMapUrl ??
                                              '',
                                        )) {
                                          // ignore: deprecated_member_use
                                          await launch(
                                            controller
                                                    .cityDetails
                                                    ?.item
                                                    ?.googleMapUrl ??
                                                '',
                                          );
                                        } else {
                                          throw 'Could not launch tel: ${controller.cityDetails?.item?.phone}l';
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                          bottom: 10,
                                        ),
                                        child: Align(
                                          alignment: AlignmentGeometry.topRight,
                                          child: Container(
                                            padding: EdgeInsets.all(10.sp),
                                            decoration: BoxDecoration(
                                              // ignore: deprecated_member_use
                                              color: Colors.white
                                                  .withOpacity(0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(
                                              AppAssets.locationFilled,
                                              height: 20.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Expanded(
                        //       child: Text(
                        //         controller.cityDetails?.item?.name ?? 'N/A',
                        //         style: AppTextStyles.customText32(
                        //           color: AppColors.white,
                        //           fontWeight: FontWeight.bold,
                        //           height: 1.2,
                        //         ),
                        //       ),
                        //     ),
                        //     15.w.width,
                        //     // Container(
                        //     //   decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        //     //   child: Center(
                        //     //     child: Row(
                        //     //       mainAxisSize: MainAxisSize.min,
                        //     //       crossAxisAlignment: CrossAxisAlignment.center,
                        //     //       children: [
                        //     //         Icon(Icons.star, color: Colors.orangeAccent, size: 15.sp),
                        //     //         SizedBox(width: 1.w),
                        //     //         Text(
                        //     //           "4.9",
                        //     //           style: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w500),
                        //     //         ).paddingRight(2.w),
                        //     //       ],
                        //     //     ).paddingHorizontal(4.w),
                        //     //   ).paddingFromAll(15.sp),
                        //     // ),
                        //   ],
                        // ).paddingHorizontal(15.w),
                        GestureDetector(
                          // onTap: () {
                          //   print(true);
                          //   Utils.showCustomDialog(
                          //     context: context,
                          //     child: JobImagesDialog(imageUrls: images),
                          //   );
                          // },
                          onTap: () {
                            //   onTap: () {
                            // Utils.showCustomDialog(
                            //   context: context,
                            //   child: JobImagesDialog(imageUrls: controller.cityDetails?.item?.images ?? images),
                            // );
                            Get.to(
                              () => PhotoViewScreen(
                                photos:
                                    controller.cityDetails?.item?.images ??
                                    images,
                              ),
                            );
                            //   },
                          },
                          child: Container(
                            height: ScreenUtil().screenHeight * 0.28,
                            width: double.infinity,
                            color: Colors.transparent,
                          ),
                        ),

                        GestureDetector(
                          // onTap: () {
                          //   print(true);
                          //   Utils.showCustomDialog(
                          //     context: context,
                          //     child: JobImagesDialog(imageUrls: images),
                          //   );
                          // },
                          onTap: () {
                            //   onTap: () {
                            // Utils.showCustomDialog(
                            //   context: context,
                            //   child: JobImagesDialog(imageUrls: controller.cityDetails?.item?.images ?? images),
                            // );
                            Get.to(
                              () => PhotoViewScreen(
                                photos:
                                    controller.cityDetails?.item?.images ??
                                    images,
                              ),
                            );
                            //   },
                          },
                          child: Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: PageController(),
                                count:
                                    controller
                                        .cityDetails
                                        ?.item
                                        ?.images
                                        ?.length ??
                                    0,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor: Colors.white,
                                  dotColor: Colors.white,
                                  spacing: 8,
                                  expansionFactor: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                        15.h.height,
                        // GestureDetector(
                        //   onTap: () {
                        //     Utils.showCustomDialog(
                        //       context: context,
                        //       child: JobImagesDialog(imageUrls: controller.cityDetails?.item?.images ?? images),
                        //     );
                        //   },
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(24.sp),
                        //     child: BackdropFilter(
                        //       filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // <-- blurry background
                        //       child: GestureDetector(
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             color: Colors.white.withOpacity(0.7), // semi-transparent to show blur
                        //             borderRadius: BorderRadius.circular(24.sp),
                        //           ),
                        //           child: Text(
                        //             'View Images',
                        //             style: AppTextStyles.customText14(color: Colors.black, fontWeight: FontWeight.w500),
                        //           ).paddingFromAll(12.sp).paddingHorizontal(15.w),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SafeArea(
                          top: false,
                          bottom: false,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.sp),
                              topRight: Radius.circular(24.sp),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 8,
                                sigmaY: 8,
                              ), // <-- blurry background
                              child: GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: Colors.white.withOpacity(
                                      1,
                                    ), // semi-transparent to show blur
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24.sp),
                                      topRight: Radius.circular(24.sp),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller
                                                      .cityDetails
                                                      ?.item
                                                      ?.name ??
                                                  'N/A',
                                              style: AppTextStyles.customText24(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (controller
                                              .cityDetails
                                              ?.item
                                              ?.weeklySchedule !=
                                          null)
                                        10.h.height,
                                      if (controller
                                              .cityDetails
                                              ?.item
                                              ?.weeklySchedule !=
                                          null)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 15.sp,
                                              width: 15.sp,
                                              decoration: BoxDecoration(
                                                color:
                                                    (controller
                                                                .cityDetails
                                                                ?.item
                                                                ?.weeklySchedule[DateFormat(
                                                                  'EEEE',
                                                                )
                                                                .format(
                                                                  DateTime.now(),
                                                                )
                                                                .toString()
                                                                .toLowerCase()]['periods'] ??
                                                            [])
                                                        .isEmpty
                                                    ? AppColors.negativeRed
                                                    : isBewteenTwoDates(
                                                        DateTime.now(),
                                                        DateTime.now().copyWith(
                                                          minute: int.parse(
                                                            controller
                                                                    .cityDetails
                                                                    ?.item
                                                                    ?.weeklySchedule[DateFormat(
                                                                          'EEEE',
                                                                        )
                                                                        .format(
                                                                          DateTime.now(),
                                                                        )
                                                                        .toString()
                                                                        .toLowerCase()]['periods']
                                                                    .first['openTime']
                                                                    .toString()
                                                                    .split(':')
                                                                    .last ??
                                                                '00',
                                                          ),
                                                          hour: int.parse(
                                                            controller
                                                                    .cityDetails
                                                                    ?.item
                                                                    ?.weeklySchedule[DateFormat(
                                                                          'EEEE',
                                                                        )
                                                                        .format(
                                                                          DateTime.now(),
                                                                        )
                                                                        .toString()
                                                                        .toLowerCase()]['periods']
                                                                    .first['openTime']
                                                                    .toString()
                                                                    .split(':')
                                                                    .first ??
                                                                '00',
                                                          ),
                                                        ),
                                                        DateTime.now().copyWith(
                                                          minute: int.parse(
                                                            controller
                                                                    .cityDetails
                                                                    ?.item
                                                                    ?.weeklySchedule[DateFormat(
                                                                          'EEEE',
                                                                        )
                                                                        .format(
                                                                          DateTime.now(),
                                                                        )
                                                                        .toString()
                                                                        .toLowerCase()]['periods']
                                                                    .first['closeTime']
                                                                    .toString()
                                                                    .split(':')
                                                                    .last ??
                                                                '00',
                                                          ),
                                                          hour: int.parse(
                                                            controller
                                                                    .cityDetails
                                                                    ?.item
                                                                    ?.weeklySchedule[DateFormat(
                                                                          'EEEE',
                                                                        )
                                                                        .format(
                                                                          DateTime.now(),
                                                                        )
                                                                        .toString()
                                                                        .toLowerCase()]['periods']
                                                                    .first['closeTime']
                                                                    .toString()
                                                                    .split(':')
                                                                    .first ??
                                                                '00',
                                                          ),
                                                        ),
                                                      )
                                                    ? AppColors.positiveGreen
                                                    : AppColors.negativeRed,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.white,
                                                  width: 1.sp,
                                                ),
                                              ),
                                            ),
                                            5.w.width,
                                            Text(
                                              (controller
                                                              .cityDetails
                                                              ?.item
                                                              ?.weeklySchedule[DateFormat(
                                                                'EEEE',
                                                              )
                                                              .format(
                                                                DateTime.now(),
                                                              )
                                                              .toString()
                                                              .toLowerCase()]['periods'] ??
                                                          [])
                                                      .isEmpty
                                                  ? 'Closed'
                                                  : "${controller.cityDetails?.item?.weeklySchedule[DateFormat('EEEE').format(DateTime.now()).toString().toLowerCase()]['periods'].first['openTime'].toString().substring(0, 5)} - ${controller.cityDetails?.item?.weeklySchedule[DateFormat('EEEE').format(DateTime.now()).toString().toLowerCase()]['periods'].first['closeTime'].toString().substring(0, 5)}",
                                              style: AppTextStyles.customText14(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      15.h.height,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            context.l10n!.overview,
                                            style: AppTextStyles.customText22(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      5.h.height,
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: ReadMoreText(
                                          controller
                                                  .cityDetails
                                                  ?.item
                                                  ?.shortDescription ??
                                              'N/A',
                                          textAlign: TextAlign.start,
                                          trimMode: TrimMode.Line,
                                          moreStyle: AppTextStyles.customText14(
                                            color: AppColors.secondaryBlack,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          lessStyle: AppTextStyles.customText14(
                                            color: AppColors.secondaryBlack,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          trimLines: 5,
                                          style: AppTextStyles.customText16(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                      15.h.height,

                                      // // --- Available Seasons ---
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: [
                                      //     Text(
                                      //       "Available Seasons",
                                      //       style: AppTextStyles.customText24(
                                      //         color: AppColors.black,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // 5.h.height,
                                      // (controller.cityDetails?.item?.availableSeasons?.isEmpty ?? true)
                                      //     ? Text(
                                      //         "No available seasons",
                                      //         style: AppTextStyles.customText14(color: AppColors.textLightBlack),
                                      //       )
                                      //     : SizedBox(
                                      //         height: 35.h,
                                      //         child: ListView.builder(
                                      //           itemCount:
                                      //               controller.cityDetails?.item?.availableSeasons?.length ?? 0,
                                      //           scrollDirection: Axis.horizontal,
                                      //           physics: const BouncingScrollPhysics(),
                                      //           itemBuilder: (context, index) {
                                      //             final season =
                                      //                 controller.cityDetails?.item?.availableSeasons?[index] ?? 'N/A';
                                      //             return _buildAmenityTile(season.toString()).paddingRight(5.w);
                                      //           },
                                      //         ),
                                      //       ),

                                      // // --- Travel Styles ---
                                      // 15.h.height,
                                      if (controller
                                              .cityDetails
                                              ?.item
                                              ?.amenities
                                              ?.isNotEmpty ??
                                          true)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Amenities",
                                              style: AppTextStyles.customText22(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (controller
                                              .cityDetails
                                              ?.item
                                              ?.amenities
                                              ?.isNotEmpty ??
                                          false)
                                        5.h.height,
                                      (controller
                                                  .cityDetails
                                                  ?.item
                                                  ?.amenities
                                                  ?.isEmpty ??
                                              true)
                                          ? SizedBox.shrink()
                                          : SizedBox(
                                              height: 34.h,
                                              child: ListView.builder(
                                                itemCount:
                                                    controller
                                                        .cityDetails
                                                        ?.item
                                                        ?.amenities
                                                        ?.length ??
                                                    0,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  final style =
                                                      controller
                                                          .cityDetails
                                                          ?.item
                                                          ?.amenities?[index] ??
                                                      'N/A';
                                                  return _buildAmenityTile(
                                                    style.toString(),
                                                  ).paddingRight(5.w);
                                                },
                                              ),
                                            ),

                                      15.h.height,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            context.l10n!.similar_things_to_do,
                                            style: AppTextStyles.customText22(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      5.h.height,
                                      SizedBox(
                                        height:
                                            (controller.cityDetails?.type
                                                    ?.toLowerCase()
                                                    .contains('exp') ??
                                                false)
                                            ? 270.h
                                            : 250.h,
                                        width: double.infinity,
                                        child: ListView.builder(
                                          itemCount: controller
                                              .cityDetails
                                              ?.similarItems
                                              ?.length,
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          // pageSnapping: true,
                                          // controller: PageController(viewportFraction: 0.90),
                                          itemBuilder: (context, index) {
                                            final item = controller
                                                .cityDetails
                                                ?.similarItems?[index];
                                            return ClipRRect(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                    () => HotelDetailView(
                                                      markerId: item!.id
                                                          .toString(),
                                                    ),
                                                    preventDuplicates: false,
                                                  );
                                                },
                                                child: Container(
                                                  height:
                                                      ((item?.durationMinutes ??
                                                              0) ==
                                                          0)
                                                      ? 240.h
                                                      : 260.h,
                                                  width: Get.width * 0.8,
                                                  margin: EdgeInsets.only(
                                                    right: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.sp,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      /// --- Image Carousel with PageView ---
                                                      Stack(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: AppColors
                                                                    .white,
                                                                width: 1.2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12.sp,
                                                                  ),
                                                            ),
                                                            child: CustomCachedImage(
                                                              height: 150.h,
                                                              width: 300.w,
                                                              imageUrl:
                                                                  item?.images?[0] ??
                                                                  'https://images.unsplash.com/photo-1504384308090-c894fdcc538d',
                                                              borderRadius:
                                                                  12.sp,
                                                            ),
                                                          ),

                                                          /// Top-right blurry heart icon
                                                          // Positioned(
                                                          //   top: 10.h,
                                                          //   right: 10.w,
                                                          //   child: ClipRRect(
                                                          //     borderRadius: BorderRadius.circular(50),
                                                          //     child: BackdropFilter(
                                                          //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                          //       child: Container(
                                                          //         padding: EdgeInsets.all(6.sp),
                                                          //         decoration: BoxDecoration(
                                                          //           color: Colors.white.withOpacity(0.3),
                                                          //           shape: BoxShape.circle,
                                                          //         ),
                                                          //         child: Image.asset(
                                                          //           AppAssets.heartIcon,
                                                          //           height: 20.h,
                                                          //         ),
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ).paddingVertical(10.h),

                                                      /// --- Details Section ---
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item?.name ?? 'N/A',
                                                            maxLines: 1,
                                                            style:
                                                                AppTextStyles.customText18(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          6.h.height,
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              if (item
                                                                      ?.category
                                                                      ?.name
                                                                      ?.isNotEmpty ??
                                                                  false)
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // SvgPicture.asset(AppAssets.hotelIcon),
                                                                    // 5.w.width,
                                                                    Text(
                                                                      item
                                                                              ?.category
                                                                              ?.name ??
                                                                          '',
                                                                      style: AppTextStyles.customText14(
                                                                        // ignore: deprecated_member_use
                                                                        color: AppColors
                                                                            .textLightBlack
                                                                            .withOpacity(
                                                                              0.7,
                                                                            ),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              // else
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(0,0,20,0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // SvgPicture.asset(AppAssets.hotelIcon),
                                                                    // 5.w.width,
                                                                    Text(
                                                                      item?.priceLevel?.toLowerCase().contains(
                                                                                'econ',
                                                                              ) ??
                                                                              false
                                                                          ? '\$'
                                                                          : item?.priceLevel?.toLowerCase().contains(
                                                                                'mode',
                                                                              ) ??
                                                                              false
                                                                          ? '\$\$'
                                                                          : '\$\$\$',
                                                                      style: AppTextStyles.customText14(
                                                                        // ignore: deprecated_member_use
                                                                        color: AppColors
                                                                            .textLightBlack
                                                                            .withOpacity(
                                                                              0.9,
                                                                            ),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          if ((item?.durationMinutes ??
                                                                  0) !=
                                                              0)
                                                            6.h.height,
                                                          if ((item?.durationMinutes ??
                                                                  0) !=
                                                              0)
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // SvgPicture.asset(AppAssets.locationIcon),
                                                                // 5.w.width,
                                                                Flexible(
                                                                  child: Text(
                                                                    ((item?.durationMinutes ??
                                                                                0) ==
                                                                            0)
                                                                        ? item?.category?.type ??
                                                                              ''
                                                                        : '${Duration(minutes: item?.durationMinutes ?? 0).inHours.toString()} hrs',
                                                                    style: AppTextStyles.customText14(
                                                                      // ignore: deprecated_member_use
                                                                      color: AppColors
                                                                          .textLightBlack
                                                                          .withOpacity(
                                                                            0.7,
                                                                          ),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                      // 10.h.height,
                                                    ],
                                                  ).paddingHorizontal(0.w),
                                                ),
                                              ));
                                          },
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(left: 12.sp, right: 12.sp, top: 12.sp, bottom: 50.sp),
                                ),
                              ),
                            ).paddingBottom(5.h).paddingHorizontal(0.w),)
                        ),
                        // 70.h.height,
                      ],
                    ).paddingTop(20.h),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Material(
                      elevation: 10,
                      color: Colors.white,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: 10.h,
                          left: 15.w,
                          right: 15.w,
                          bottom: MediaQuery.of(context).padding.bottom + 10.h,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.sp),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.15),
                                blurRadius: 20,
                                offset: Offset(0, 5),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: TextFormField(
                              controller: askAnythingController,  // ← ADD THIS LINE
                              textInputAction: TextInputAction.search,
                              onFieldSubmitted: (_) => _navigateToChatWithContext(),  // ← ADD THIS LINE
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: GestureDetector(  // ← WRAP Row with GestureDetector
                                  onTap: _navigateToChatWithContext,  // ← ADD THIS LINE
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppAssets.sendIcon),
                                    ],
                                  ).paddingRight(10.w),
                                ),
                                hintText: context.l10n!.ask_anything,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                hintStyle: AppTextStyles.customText14(
                                  color: AppColors.textLightBlack,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.sp),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.sp),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
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
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }

  bool isBewteenTwoDates(DateTime dt, DateTime start, DateTime end) {
    // If end is before or equal to start, hours span midnight (e.g., 9:00 - 00:00)
    if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
      // Check if current time is after start OR before end
      return dt.isAfter(start) || dt.isBefore(end);
    }
    return dt.isAfter(start) && dt.isBefore(end);
  }

  Widget _buildAmenityTile(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        // ignore: deprecated_member_use
        border: Border.all(color: AppColors.black.withOpacity(0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            height: 14,
            title.toLowerCase().contains('wifi')
                ? AppAssets.wifi_1
                : title.toLowerCase().contains('parking')
                ? AppAssets.parking_1
                : title.toLowerCase().contains('gym')
                ? AppAssets.gym_1
                : title.toLowerCase().contains('restaurant')
                ? AppAssets.waiter_1
                : title.toLowerCase().contains('sauna')
                ? AppAssets.sauna_1_1
                : title.toLowerCase().contains('pool')
                ? AppAssets.swimmer_1
                : title.toLowerCase().contains('terrace')
                ? AppAssets.terrace_1
                : title.toLowerCase().contains('waiter')
                ? AppAssets.waiter_1
                : title.toLowerCase().contains('bbq')
                ? AppAssets.grill_1__1
                : title.toLowerCase().contains('family')
                ? AppAssets.family_1
                : title.toLowerCase().contains('charger')
                ? AppAssets.electric_station_1
                : title.toLowerCase().contains('disable')
                ? AppAssets.disable_sign_1
                : title.toLowerCase().contains('breakfast')
                ? AppAssets.coffee_cup_1
                : title.toLowerCase().contains('reception')
                ? AppAssets.call_1
                : title.toLowerCase().contains('conditioning')
                ? AppAssets.wind_1
                : title.toLowerCase().contains('ciubar')
                ? AppAssets.steam_1
                : AppAssets.restaurant_1,
          ),
          5.w.width,
          Text(
            title,
            style: AppTextStyles.customText(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
