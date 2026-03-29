import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/suggest_place_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';

class NewPlaceView extends StatefulWidget {
  const NewPlaceView({super.key});

  @override
  State<NewPlaceView> createState() => _NewPlaceViewState();
}

class _NewPlaceViewState extends State<NewPlaceView> {
  String? selectedCityId;
  final SuggestPlaceController controller = Get.find();

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      selectedCityId = Get.arguments as String;
      controller.selectedCityId.value = selectedCityId ?? '';
    }

    print('Received City ID: $selectedCityId');
  }

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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.l10n!.new_place,
                  style: AppTextStyles.customText32(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).paddingTop(30.h),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.newPlaceAllIcons, height: 70.h),
                  10.h.height,
                  Text(
                    context.l10n!.suggest_us_to_your_favourite_places_we_will_take_care_and_add_them_so_that_other_people_know_them,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.customText16(
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ).paddingHorizontal(40.w),
                  40.h.height,
                  AppCustomButton(
                    title: context.l10n!.suggest_now,
                    onPressed: () {
                      Get.toNamed(AppRoutes.categoryView);
                    },
                  ).paddingHorizontal(45.w),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.l10n!.new_place,
                  style: AppTextStyles.customText32(
                    color: Colors.transparent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).paddingTop(30.h),
            ],
          ).paddingHorizontal(20.w),
        ),
      ),
    );
  }
}
