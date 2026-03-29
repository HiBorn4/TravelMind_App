import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/home_travel_tile.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view/all_favs/all_favs_view.dart';
import 'package:vlad_ai/app/mvvm/view/tours_view/tours_view.dart';
import 'package:vlad_ai/app/mvvm/view_model/cities_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/favs_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/plan_trip_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../config/app_routes.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  final CitiesController controller = Get.find();

  final FavsController controllerFav = Get.put(FavsController());

  final PlanTripController controllerC = Get.put(PlanTripController());

  @override
  void initState() {
    // controller.getPopularCities();
    controller.getAllItineraries();
    super.initState();
  }

  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.scaffoldBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            50.h.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.sp),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      readOnly: true,
                      onTap: () {
                        Get.toNamed(AppRoutes.planTripView);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: SvgPicture.asset(
                          AppAssets.searchIcon,
                        ).paddingFromAll(10.sp),
                        hintText: context.l10n!.create_a_new_trip,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 5,
                        ),
                        hintStyle: AppTextStyles.customText16(
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
                          borderSide: BorderSide(color: AppColors.transparent),
                        ),
                      ),
                    ).paddingOnly(right: 10.h),
                  ),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'Current Location',
                //       style: AppTextStyles.customText16(color: AppColors.textLightBlack.withOpacity(0.8)),
                //     ),
                //     2.h.height,
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Bucharest, Romania',
                //           style: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w600),
                //         ),
                //         5.w.width,
                //         Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black, size: 20.sp),
                //       ],
                //     ),
                //   ],
                // ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => AllFavsView());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_outline_rounded,
                      color: Colors.black,
                      size: 20.sp,
                    ).paddingFromAll(10.sp),
                  ),
                ),
              ],
            ),
            20.h.height,

            Expanded(
              child: Obx(() {
                return controller.isPopularCitiesLoading.value ||
                        controller.isAllItinerariesLoading.value
                    ? Center(child: CustomLoader())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Popular Destinations',
                            //       style: AppTextStyles.customText20(color: Colors.black, fontWeight: FontWeight.bold),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         Get.toNamed(AppRoutes.allPopularCitiesView);
                            //       },
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.end,
                            //         children: [
                            //           Text(
                            //             'View all',
                            //             style: AppTextStyles.customText16(
                            //               color: AppColors.textLightBlack.withOpacity(0.7),
                            //             ),
                            //           ),
                            //           1.w.width,
                            //           Icon(
                            //             Icons.keyboard_arrow_right_rounded,
                            //             color: AppColors.textLightBlack.withOpacity(0.7),
                            //             size: 25.sp,
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // 30.h.height,
                            // (controller.popularCitiesRespModel?.popularCities?.isEmpty ?? true)
                            //     ? Center(
                            //         child: Text(
                            //           'No Popular Cities Found\nTry again later',
                            //           style: AppTextStyles.customText16(
                            //             color: Colors.black,
                            //             fontWeight: FontWeight.w500,
                            //           ),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       )
                            //     : SizedBox(
                            //         height: 200.h,
                            //         width: ScreenUtil().screenWidth,
                            //         child: CardSwiper(
                            //           allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                            //             horizontal: true,
                            //             vertical: false,
                            //           ),
                            //           isLoop: true,
                            //           backCardOffset: const Offset(0, -20),
                            //           numberOfCardsDisplayed:
                            //               (controller.popularCitiesRespModel?.popularCities?.length ?? 0) < 3
                            //               ? controller.popularCitiesRespModel?.popularCities?.length ?? 0
                            //               : 3,
                            //           padding: EdgeInsets.zero,
                            //           cardsCount: controller.popularCitiesRespModel?.popularCities?.length ?? 0,
                            //           cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                            //             final city = controller.popularCitiesRespModel!.popularCities![index];
                            //             return HomeTravelTile(
                            //               isFav: null,
                            //               image: (city.image ?? []).isNotEmpty
                            //                   ? city.image!.first
                            //                   : 'https://images.pexels.com/photos/552785/pexels-photo-552785.jpeg',
                            //               title: "${city.name} - ${city.country}",
                            //             );
                            //           },
                            //         ),
                            //       ),

                            // 40.h.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${context.l10n!.your_last_trips} ${(controller.allItinerariesRespModel?.data.lastTripCities.isEmpty ?? true) ? 0 : currentindex + 1}/${controller.allItinerariesRespModel?.data.lastTripCities.length ?? 0}',
                                  style: AppTextStyles.customText20(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     Get.toNamed(AppRoutes.allLastTripsView);
                                //   },
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     children: [
                                //       Text(
                                //         'View all',
                                //         style: AppTextStyles.customText16(
                                //           color: AppColors.textLightBlack.withOpacity(0.7),
                                //         ),
                                //       ),
                                //       1.w.width,
                                //       Icon(
                                //         Icons.keyboard_arrow_right_rounded,
                                //         color: AppColors.textLightBlack.withOpacity(0.7),
                                //         size: 25.sp,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            40.h.height,
                            SizedBox(
                              height: 200.h,
                              child:
                                  (controller.allItinerariesRespModel?.data ==
                                          null ||
                                      controller
                                          .allItinerariesRespModel!
                                          .data
                                          .lastTripCities
                                          .isEmpty)
                                  ? Center(
                                      child: Text(
                                        "No trips available",
                                        style: AppTextStyles.customText18(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : (controller
                                            .allItinerariesRespModel
                                            ?.data
                                            .lastTripCities
                                            .isEmpty ??
                                        true)
                                  ? Center(
                                      child: Text(
                                        'No Trips Found\nTry again later',
                                        style: AppTextStyles.customText16(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 200.h,
                                      width: ScreenUtil().screenWidth,
                                      child: CardSwiper(
                                        allowedSwipeDirection:
                                            AllowedSwipeDirection.symmetric(
                                              horizontal: true,
                                              vertical: false,
                                            ),
                                        isLoop: true,
                                        onSwipe:
                                            (
                                              previousIndex,
                                              currentIndex,
                                              direction,
                                            ) {
                                              currentindex = currentIndex ?? 0;
                                              setState(() {});
                                              return true;
                                            },
                                        backCardOffset: const Offset(0, -20),
                                        numberOfCardsDisplayed:
                                            (controller
                                                        .allItinerariesRespModel
                                                        ?.data
                                                        .lastTripCities
                                                        .length ??
                                                    0) <
                                                3
                                            ? controller
                                                      .allItinerariesRespModel
                                                      ?.data
                                                      .lastTripCities
                                                      .length ??
                                                  0
                                            : 3,
                                        padding: EdgeInsets.zero,
                                        cardsCount:
                                            controller
                                                .allItinerariesRespModel
                                                ?.data
                                                .lastTripCities
                                                .length ??
                                            0,
                                        cardBuilder:
                                            (
                                              context,
                                              index,
                                              percentThresholdX,
                                              percentThresholdY,
                                            ) {
                                              final itinerary = controller
                                                  .allItinerariesRespModel!
                                                  .data
                                                  .lastTripCities[index];
                                              return HomeTravelTile(
                                                isFav: null,
                                                showFavIcon: false,
                                                // onTapFav: () async {
                                                //   final res = await controllerFav.postFavs(
                                                //     city.itineraryData?.day1?.slots?.first.selected?.location?.type ?? '',
                                                //     city.itineraryData?.day1?.slots?.first.selected?.id ?? '',
                                                //   );
                                                //   if (res) {
                                                //     await controller.getAllItineraries(load: false);
                                                //     setState(() {});
                                                //   }
                                                // },
                                                onTap: () {
                                                  Get.to(
                                                    () => ToursView(
                                                      itineraryId: itinerary.id,
                                                    ),
                                                  );
                                                  // controllerC.iterneityResponseModel.value = IterneityResponseModel(
                                                  //   itinerary: ItineraryItr(
                                                  //     id: city.id!,
                                                  //     userId: city.userId ?? '',
                                                  //     cityId: city.cityId ?? '',
                                                  //     startDate: DateTime.parse(city.startDate ?? ''),
                                                  //     endDate: DateTime.parse(city.endDate ?? ''),
                                                  //     numberOfTravelers: city.numberOfTravelers ?? 0,
                                                  //     budget: BudgetItr.MODERATE,
                                                  //     travelStyle: city.travelStyle ?? '',
                                                  //     accommodationCategoryId: city.accommodationCategoryId ?? '',
                                                  //     disabledPerson: city.disabledPerson ?? false,
                                                  //     userInterests: city.userInterests ?? [],
                                                  //     itineraryData: ItineraryDataItr(
                                                  //       day1: DayItr(
                                                  //         date: DateTime.parse(city.itineraryData!.day1!.date ?? ''),
                                                  //         type: city.itineraryData?.day1?.type ?? '',
                                                  //         slots:
                                                  //             (city.itineraryData!.day1?.slots?.map((e) {
                                                  //               print(e.selected?.name ?? '');
                                                  //               return SlotItr(
                                                  //                 time: e.time ?? '',
                                                  //                 type: (e.type ?? '') == 'accommodation'
                                                  //                     ? AccommodationCategoryTypeItr.ACCOMMODATION
                                                  //                     : (e.type ?? '') == 'attraction'
                                                  //                     ? AccommodationCategoryTypeItr.ATTRACTION
                                                  //                     : AccommodationCategoryTypeItr.RESTAURANT,
                                                  //                 slotId: e.slotId ?? '',
                                                  //                 selectedId: e.selected?.id ?? '',
                                                  //                 alternativeIds: [],
                                                  //                 selected: SelectedItr(
                                                  //                   id: e.selected?.id ?? '',
                                                  //                   name: e.selected?.name ?? '',
                                                  //                   address: e.selected?.address ?? '',
                                                  //                   description: e.selected?.description ?? '',
                                                  //                   images: e.selected?.images ?? [],
                                                  //                   location: LocationItr(
                                                  //                     crs: CrsItr(
                                                  //                       type: CrsTypeItr.NAME,
                                                  //                       properties: PropertiesItr(name: NameItr.EPSG_4326),
                                                  //                     ),
                                                  //                     type: LocationTypeItr.POINT,
                                                  //                     coordinates: e.selected?.location!.coordinates ?? [],
                                                  //                   ),
                                                  //                   priceLevel: BudgetItr.MODERATE,
                                                  //                 ),
                                                  //                 alternatives: [],
                                                  //               );
                                                  //             }).toList()) ??
                                                  //             [],
                                                  //         dayNumber: city.itineraryData!.day1?.dayNumber ?? 1,
                                                  //       ),
                                                  //       day2: DayItr(
                                                  //         date: DateTime.parse(city.itineraryData?.day2?.date ?? ''),
                                                  //         type: city.itineraryData?.day2?.type ?? '',
                                                  //         slots:
                                                  //             (city.itineraryData!.day2?.slots
                                                  //                 ?.map(
                                                  //                   (e) => SlotItr(
                                                  //                     time: e.time ?? '',
                                                  //                     type: (e.type ?? '') == 'accommodation'
                                                  //                         ? AccommodationCategoryTypeItr.ACCOMMODATION
                                                  //                         : (e.type ?? '') == 'attraction'
                                                  //                         ? AccommodationCategoryTypeItr.ATTRACTION
                                                  //                         : AccommodationCategoryTypeItr.RESTAURANT,
                                                  //                     slotId: e.slotId ?? '',
                                                  //                     selectedId: e.selected?.id ?? '',
                                                  //                     alternativeIds: [],
                                                  //                     selected: SelectedItr(
                                                  //                       id: e.selected?.id ?? '',
                                                  //                       name: e.selected?.name ?? '',
                                                  //                       address: e.selected?.address ?? '',
                                                  //                       description: e.selected?.description ?? '',
                                                  //                       images: e.selected?.images ?? [],
                                                  //                       location: LocationItr(
                                                  //                         crs: CrsItr(
                                                  //                           type: CrsTypeItr.NAME,
                                                  //                           properties: PropertiesItr(
                                                  //                             name: NameItr.EPSG_4326,
                                                  //                           ),
                                                  //                         ),
                                                  //                         type: LocationTypeItr.POINT,
                                                  //                         coordinates:
                                                  //                             e.selected?.location!.coordinates ?? [],
                                                  //                       ),
                                                  //                       priceLevel: BudgetItr.MODERATE,
                                                  //                     ),
                                                  //                     alternatives: [],
                                                  //                   ),
                                                  //                 )
                                                  //                 .toList()) ??
                                                  //             [],
                                                  //         dayNumber: city.itineraryData!.day2!.dayNumber ?? 1,
                                                  //       ),
                                                  //       day3: DayItr(
                                                  //         date: (city.itineraryData?.day3?.date?.isEmpty ?? true)
                                                  //             ? DateTime.now()
                                                  //             : DateTime.parse(
                                                  //                 city.itineraryData?.day3?.date ?? '1-1-2025',
                                                  //               ),
                                                  //         type: city.itineraryData?.day3?.type ?? '',
                                                  //         slots:
                                                  //             (city.itineraryData!.day3?.slots
                                                  //                 ?.map(
                                                  //                   (e) => SlotItr(
                                                  //                     time: e.time ?? '',
                                                  //                     type: (e.type ?? '') == 'accommodation'
                                                  //                         ? AccommodationCategoryTypeItr.ACCOMMODATION
                                                  //                         : (e.type ?? '') == 'attraction'
                                                  //                         ? AccommodationCategoryTypeItr.ATTRACTION
                                                  //                         : AccommodationCategoryTypeItr.RESTAURANT,
                                                  //                     slotId: e.slotId ?? '',
                                                  //                     selectedId: e.selected?.id ?? '',
                                                  //                     alternativeIds: [],
                                                  //                     selected: SelectedItr(
                                                  //                       id: e.selected?.id ?? '',
                                                  //                       name: e.selected?.name ?? '',
                                                  //                       address: e.selected?.address ?? '',
                                                  //                       description: e.selected?.description ?? '',
                                                  //                       images: e.selected?.images ?? [],
                                                  //                       location: LocationItr(
                                                  //                         crs: CrsItr(
                                                  //                           type: CrsTypeItr.NAME,
                                                  //                           properties: PropertiesItr(
                                                  //                             name: NameItr.EPSG_4326,
                                                  //                           ),
                                                  //                         ),
                                                  //                         type: LocationTypeItr.POINT,
                                                  //                         coordinates:
                                                  //                             e.selected?.location!.coordinates ?? [],
                                                  //                       ),
                                                  //                       priceLevel: BudgetItr.MODERATE,
                                                  //                     ),
                                                  //                     alternatives: [],
                                                  //                   ),
                                                  //                 )
                                                  //                 .toList()) ??
                                                  //             [],
                                                  //         dayNumber: city.itineraryData!.day3?.dayNumber ?? 1,
                                                  //       ),
                                                  //       day4: DayItr(
                                                  //         date: (city.itineraryData?.day4?.date?.isEmpty ?? true)
                                                  //             ? DateTime.now()
                                                  //             : DateTime.parse(city.itineraryData?.day4!.date ?? ''),
                                                  //         type: city.itineraryData?.day4?.type ?? '',
                                                  //         slots:
                                                  //             (city.itineraryData!.day4?.slots
                                                  //                 ?.map(
                                                  //                   (e) => SlotItr(
                                                  //                     time: e.time ?? '',
                                                  //                     type: (e.type ?? '') == 'accommodation'
                                                  //                         ? AccommodationCategoryTypeItr.ACCOMMODATION
                                                  //                         : (e.type ?? '') == 'attraction'
                                                  //                         ? AccommodationCategoryTypeItr.ATTRACTION
                                                  //                         : AccommodationCategoryTypeItr.RESTAURANT,
                                                  //                     slotId: e.slotId ?? '',
                                                  //                     selectedId: e.selected?.id ?? '',
                                                  //                     alternativeIds: [],
                                                  //                     selected: SelectedItr(
                                                  //                       id: e.selected?.id ?? '',
                                                  //                       name: e.selected?.name ?? '',
                                                  //                       address: e.selected?.address ?? '',
                                                  //                       description: e.selected?.description ?? '',
                                                  //                       images: e.selected?.images ?? [],
                                                  //                       location: LocationItr(
                                                  //                         crs: CrsItr(
                                                  //                           type: CrsTypeItr.NAME,
                                                  //                           properties: PropertiesItr(
                                                  //                             name: NameItr.EPSG_4326,
                                                  //                           ),
                                                  //                         ),
                                                  //                         type: LocationTypeItr.POINT,
                                                  //                         coordinates:
                                                  //                             e.selected?.location!.coordinates ?? [],
                                                  //                       ),
                                                  //                       priceLevel: BudgetItr.MODERATE,
                                                  //                     ),
                                                  //                     alternatives: [],
                                                  //                   ),
                                                  //                 )
                                                  //                 .toList()) ??
                                                  //             [],
                                                  //         dayNumber: city.itineraryData!.day4?.dayNumber ?? 1,
                                                  //       ),
                                                  //     ),
                                                  //     createdBy: city.createdBy ?? '',
                                                  //     createdAt: DateTime.parse(city.createdAt ?? ''),
                                                  //     updatedAt: DateTime.parse(city.updatedAt ?? ''),
                                                  //     city: AccommodationCategoryItr(
                                                  //       id: city.city?.id ?? "",
                                                  //       name: city.city?.name ?? "",
                                                  //       country: city.city?.country ?? "",
                                                  //     ),
                                                  //     accommodationCategory: AccommodationCategoryItr(
                                                  //       id: city.accommodationCategory?.id ?? "",
                                                  //       name: city.accommodationCategory?.name ?? "",
                                                  //       description: city.accommodationCategory?.description ?? "",
                                                  //     ),
                                                  //   ),
                                                  //   festivals: null,
                                                  //   helpfulThings: null,
                                                  // );
                                                },
                                                duration:
                                                    (DateTime.parse(
                                                                  itinerary
                                                                      .endDate,
                                                                )
                                                                .difference(
                                                                  DateTime.parse(
                                                                    itinerary
                                                                        .startDate,
                                                                  ),
                                                                )
                                                                .inDays +
                                                            1)
                                                        .toString(),
                                                type: itinerary
                                                    .travelStyle
                                                    .capitalizeFirst,
                                                tripType: itinerary
                                                    .budget
                                                    .capitalizeFirst,
                                                image:
                                                    (itinerary.city.image.first)
                                                        .isNotEmpty
                                                    ? itinerary.city.image.first
                                                    : 'https://images.pexels.com/photos/552785/pexels-photo-552785.jpeg',
                                                title:
                                                    "${itinerary.city.name} - ${DateFormat('d MMM yyyy').format(DateTime.parse(itinerary.startDate!))}",
                                                startDate: itinerary.startDate,
                                              );
                                            },
                                      ),
                                    ),

                              // ListView.builder(
                              //     itemCount: controller.allItinerariesRespModel!.itineraries!.length,
                              //     shrinkWrap: true,
                              //     physics: BouncingScrollPhysics(),
                              //     scrollDirection: Axis.horizontal,
                              //     itemBuilder: (context, index) {
                              //       final itinerary = controller.allItinerariesRespModel!.itineraries![index];
                              //       return HomeTravelTile(
                              //         isFav: null,
                              //         image: itinerary.itineraryData?.day1?.slots?[0].selected?.images?[0],
                              //         title: "${itinerary.city?.name} - ${itinerary.city?.country}",
                              //         width: 320.w,
                              //       ).paddingRight(20.w);
                              //     },
                              //   ),
                            ),
                            100.h.height,
                          ],
                        ),
                      );
              }),
            ),
          ],
        ).paddingHorizontal(18.w),
      ),
    );
  }
}
