import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/mvvm/view_model/cities_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../customWidgets/custom_app_bar.dart';
import '../../../customWidgets/home_travel_tile.dart';

class AllPopularCitiesView extends StatefulWidget {
  const AllPopularCitiesView({super.key});

  @override
  State<AllPopularCitiesView> createState() => _AllPopularCitiesViewState();
}

class _AllPopularCitiesViewState extends State<AllPopularCitiesView> {
  final CitiesController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPopularCities();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: context.l10n!.popular_cities,
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
          return controller.isPopularCitiesLoading.value
              ? Center(child: CustomLoader())
              : SafeArea(
                  child: ListView.builder(
                    itemCount: controller.popularCitiesRespModel?.popularCities?.length ?? 0,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return HomeTravelTile(
                        image:
                            (controller.popularCitiesRespModel?.popularCities?[index].image != null &&
                                controller.popularCitiesRespModel!.popularCities![index].image!.isNotEmpty)
                            ? controller.popularCitiesRespModel!.popularCities![index].image!.first
                            : '',
                        isFav: null,
                        title:
                            "${controller.popularCitiesRespModel?.popularCities?[index].name} - ${controller.popularCitiesRespModel?.popularCities?[index].country}",
                      ).paddingBottom(10.h);
                    },
                  ).paddingHorizontal(15.w).paddingTop(15.h),
                );
        }),
      ),
    );
  }
}
