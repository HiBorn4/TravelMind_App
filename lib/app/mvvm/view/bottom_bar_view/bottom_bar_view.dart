import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/mvvm/view/bottom_bar_views/chat_view.dart';
import 'package:vlad_ai/app/mvvm/view/bottom_bar_views/map_view.dart';
import 'package:vlad_ai/app/mvvm/view/bottom_bar_views/profile_view.dart';
import 'package:vlad_ai/app/mvvm/view/bottom_bar_views/shop_view.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../view_model/bottom_bar_controller.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  final BottomBarController controller = Get.find();

  final List<Widget> pages = [ChatView(), MapView(), ShopView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => buildBottomBar()),
    );
  }

  Widget buildBottomBar() {
    return SafeArea(
      child: Container(
        height: 60.h,
        margin: EdgeInsets.only(bottom: 12.sp, left: 12.sp, right: 12.sp),
        padding: EdgeInsets.all(6.sp),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(38.sp),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF717171).withOpacity(0.1), // gray
              Colors.black.withOpacity(0.1), // black with 20% opacity
            ],
          ),
          boxShadow: [BoxShadow(offset: Offset(0, -5.h), color: AppColors.black.withOpacity(.1), blurRadius: 10.sp)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildItem(AppAssets.chatInActiveIcon, AppAssets.chatActiveIcon, 0),
            buildItem(AppAssets.mapInActiveIcon, AppAssets.mapActiveIcon, 1),
            buildItem(AppAssets.shopInActiveIcon, AppAssets.shopActiveIcon, 2),
            buildItem(AppAssets.profileInActiveIcon, AppAssets.profileActiveIcon, 3),
          ],
        ),
      ).paddingHorizontal(60.w),
    );
  }

  Widget buildItem(String? activeIcon, String? inactiveIcon, int index) {
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeView(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
        child: SvgPicture.asset(isSelected ? inactiveIcon ?? '' : activeIcon ?? ''),
      ),
    );
  }
}
