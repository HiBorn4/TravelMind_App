import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_assets.dart';
import 'package:vlad_ai/app/mvvm/view/plan_trip_views/plan_trip_view_one.dart';
import 'package:vlad_ai/app/mvvm/view/plan_trip_views/plan_trip_view_two.dart';
import 'package:vlad_ai/app/mvvm/view_model/plan_trip_controller.dart';

class PlanTripMainView extends StatefulWidget {
  const PlanTripMainView({super.key});

  @override
  State<PlanTripMainView> createState() => _PlanTripMainViewState();
}

class _PlanTripMainViewState extends State<PlanTripMainView> {
  final PlanTripController controller = Get.find();
  final List<Widget> screens = [PlanTripViewOne(), PlanTripViewTwo()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.planTripBg), fit: BoxFit.cover),
        ),
        child: PageView.builder(
          controller: controller.pageController,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return screens[index];
          },
        ),
      ),
    );
  }
}
