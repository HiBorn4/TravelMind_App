import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/mvvm/view_model/cities_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../config/app_text_style.dart';
import '../../../customWidgets/custom_app_bar.dart';
import '../../../customWidgets/home_travel_tile.dart';

class AllLastTripsView extends StatefulWidget {
  const AllLastTripsView({super.key});

  @override
  State<AllLastTripsView> createState() => _AllLastTripsViewState();
}

class _AllLastTripsViewState extends State<AllLastTripsView> {
  final CitiesController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllItineraries();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: context.l10n!.last_trips,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20.sp),
        ),
      ),
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: Obx(() {
          return controller.isAllItinerariesLoading.value
              ? Center(child: CustomLoader())
              : SafeArea(
                  child:
                      (controller.allItinerariesRespModel?.data == null ||
                          controller.allItinerariesRespModel!.data.lastTripCities.isEmpty)
                      ? Center(
                          child: Text(
                            context.l10n!.no_trips_available,
                            style: AppTextStyles.customText18(color: AppColors.black, fontWeight: FontWeight.w600),
                          ),
                        ).paddingHorizontal(15.w).paddingTop(15.h)
                      : ListView.builder(
                          itemCount: controller.allItinerariesRespModel!.data.lastTripCities.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final itinerary = controller.allItinerariesRespModel!.data.lastTripCities[index];
                            return HomeTravelTile(
                              isFav: null,
                              image: itinerary.city.image.first,
                              title: "${itinerary.city.name} - ${itinerary.city.country}",
                            ).paddingBottom(10.h);
                          },
                        ).paddingHorizontal(15.w).paddingTop(15.h),
                );
        }),
      ),
    );
  }
}
