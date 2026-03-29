import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_assets.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/custom_app_bar.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/hotel_tile.dart';
import 'package:vlad_ai/app/mvvm/view_model/favs_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

class AllFavsView extends StatefulWidget {
  const AllFavsView({super.key});

  @override
  State<AllFavsView> createState() => _AllFavsViewState();
}

class _AllFavsViewState extends State<AllFavsView> {
  final FavsController controller = Get.put(FavsController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFavs(true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: context.l10n!.favourites,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20.sp,
          ),
        ),
      ),
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.scaffoldBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() {
          return controller.isFavLoading.value
              ? Center(child: CustomLoader())
              : SafeArea(
                  child:
                      ((controller
                                  .favouriteModel
                                  .value
                                  .data
                                  ?.favorites
                                  .accommodations
                                  .isEmpty ??
                              true) &&
                          (controller
                                  .favouriteModel
                                  .value
                                  .data
                                  ?.favorites
                                  .attractions
                                  .isEmpty ??
                              true) &&
                          (controller
                                  .favouriteModel
                                  .value
                                  .data
                                  ?.favorites
                                  .restaurants
                                  .isEmpty ??
                              true))
                      ? Center(
                          child: Text(
                            context.l10n!.no_favourites_available,
                            style: AppTextStyles.customText18(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                          ).copyWith(top: 15.h, bottom: 20.h),
                          children: [
                            if ((controller
                                        .favouriteModel
                                        .value
                                        .data
                                        ?.favorites
                                        .accommodations
                                        .length ??
                                    0) >
                                0)
                              Text(
                                context.l10n!.accommodation,
                                style: AppTextStyles.customText20(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).paddingBottom(10.h),
                            ...controller.favouriteModel.value.data?.favorites.accommodations.map((
                                  e,
                                ) {
                                  return MainHotelTile(
                                    images: e.images.isNotEmpty
                                        ? e.images.first
                                        : "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
                                    hotelTitle: e.name,
                                    address: e.address,
                                    location: e.pricePerNight.toString(),
                                    onClose: () {
                                      // widget.controller.selectedMarker.value = null;
                                      // widget.controller.setSelectedAnnotation(MapDataModel(lat: 0, lng: 0));
                                      // widget.controller.setShowIcon(true);
                                      // widget.controller.fabShow.value = true;
                                    },
                                    onTap: () async {
                                      // widget.controller.fabShow.value = true;
                                      // if (kDebugMode) {
                                      //   print('Marker Actual ID: ');
                                      // }
                                      // // Navigate and pass only the ID
                                      await Get.toNamed(
                                        AppRoutes.hotelDetailView,
                                        arguments: e.id,
                                      );
                                      controller.getFavs(false);
                                    },
                                    isFavScreen: true,
                                  ).paddingBottom(10.h);
                                }).toList() ??
                                [],
                            if ((controller
                                        .favouriteModel
                                        .value
                                        .data
                                        ?.favorites
                                        .attractions
                                        .length ??
                                    0) >
                                0)
                              Text(
                                'Attractions',
                                style: AppTextStyles.customText20(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).paddingBottom(10.h).paddingTop(20.h),
                            ...controller.favouriteModel.value.data?.favorites.attractions.map((
                                  e,
                                ) {
                                  return MainHotelTile(
                                    images: e.images.isNotEmpty
                                        ? e.images.first
                                        : "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
                                    hotelTitle: e.name,
                                    address: e.address,
                                    
                                    isFavScreen: true,
                                    location: e.priceLevel.toString(),
                                    onClose: () {
                                      // widget.controller.selectedMarker.value = null;
                                      // widget.controller.setSelectedAnnotation(MapDataModel(lat: 0, lng: 0));
                                      // widget.controller.setShowIcon(true);
                                      // widget.controller.fabShow.value = true;
                                    },
                                    onTap: () async {
                                      // widget.controller.fabShow.value = true;
                                      // if (kDebugMode) {
                                      //   print('Marker Actual ID: ');
                                      // }
                                      // // Navigate and pass only the ID
                                      await Get.toNamed(
                                        AppRoutes.hotelDetailView,
                                        arguments: e.id,
                                      );
                                      controller.getFavs(false);
                                    },
                                  ).paddingBottom(10.h);
                                }).toList() ??
                                [],
                            if ((controller
                                        .favouriteModel
                                        .value
                                        .data
                                        ?.favorites
                                        .restaurants
                                        .length ??
                                    0) >
                                0)
                              Text(
                                context.l10n!.restaurants,
                                style: AppTextStyles.customText20(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).paddingBottom(10.h).paddingTop(20.h),
                            ...controller.favouriteModel.value.data?.favorites.restaurants.map((
                                  e,
                                ) {
                                  return MainHotelTile(
                                    images: e.images.isNotEmpty
                                        ? e.images.first
                                        : "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
                                    hotelTitle: e.name,
                                    address: e.address,
                                    location: e.averagePrice.toString(),
                                    isFavScreen: true,
                                    onClose: () {
                                      // widget.controller.selectedMarker.value = null;
                                      // widget.controller.setSelectedAnnotation(MapDataModel(lat: 0, lng: 0));
                                      // widget.controller.setShowIcon(true);
                                      // widget.controller.fabShow.value = true;
                                    },
                                    onTap: () async {
                                      // widget.controller.fabShow.value = true;
                                      // if (kDebugMode) {
                                      //   print('Marker Actual ID: ');
                                      // }
                                      // // Navigate and pass only the ID
                                      await Get.toNamed(
                                        AppRoutes.hotelDetailView,
                                        arguments: e.id,
                                      );
                                      controller.getFavs(false);
                                    },
                                  ).paddingBottom(10.h);

                                  // return HomeTravelTile(
                                  //   image: e.images.isNotEmpty ? e.images.first : null,
                                  //   title: e.name,
                                  //   onTap: () async {
                                  //     final res = await controller.postFavs('restaurant', e.id);
                                  //     if (res) {
                                  //       await controller.getFavs(false);
                                  //       setState(() {});
                                  //     }
                                  //   },
                                  //   isFav: e.favoriteId.isNotEmpty,
                                  // ).paddingBottom(10);
                                }).toList() ??
                                [],
                          ],
                        ),
                );
        }),
      ),
    );
  }
}
