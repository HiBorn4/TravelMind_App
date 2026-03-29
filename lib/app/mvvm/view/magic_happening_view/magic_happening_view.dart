import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vlad_ai/app/config/app_assets.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../view_model/plan_trip_controller.dart';

class MagicHappeningView extends StatefulWidget {
  const MagicHappeningView({super.key});

  @override
  State<MagicHappeningView> createState() => _MagicHappeningViewState();
}

class _MagicHappeningViewState extends State<MagicHappeningView> with SingleTickerProviderStateMixin {
  int _countdown = 5;
  late AnimationController _controller;
  // late Animation<double> _scaleAnimation;
  // late Animation<double> _opacityAnimation;
  final PlanTripController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    // _scaleAnimation = Tween<double>(
    //   begin: 0.3,
    //   end: 1.2,
    // ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    // _opacityAnimation = Tween<double>(
    //   begin: 0.0,
    //   end: 1.0,
    // ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      _controller.forward(from: 0); // animate each number
      await Future.delayed(const Duration(seconds: 1));
      if (_countdown == 1) {
        Get.offAllNamed(AppRoutes.toursView);
        return false;
      }
      setState(() {
        _countdown--;
      });
      return true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.magicBg), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            // Countdown in center (big racing style)
            // Center(
            //   child: AnimatedBuilder(
            //     animation: _controller,
            //     builder: (context, child) {
            //       return Opacity(
            //         opacity: _opacityAnimation.value,
            //         child: Transform.scale(
            //           scale: _scaleAnimation.value,
            //           child: Text(
            //             '$_countdown',
            //             style: TextStyle(
            //               fontSize: 120.sp,
            //               fontWeight: FontWeight.bold,
            //               color: AppColors.secondaryBlack,
            //               shadows: [Shadow(offset: const Offset(3, 3), blurRadius: 6, color: Colors.black.withOpacity(0.4))],
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Center(child: Lottie.asset(AppAssets.heartCountdown, height: 70.h)),

            // Bottom text
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  context.l10n!.the_magic_is_happening,
                  style: AppTextStyles.customText24(color: AppColors.secondaryBlack, fontWeight: FontWeight.bold),
                ),
                6.h.height,
                Text(
                  context.l10n!.we_are_searching_thousands_of_options_to_find_the_best_matches_for_you_this_will_just_take_a_moment,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.customText16(color: Colors.black),
                ).paddingHorizontal(60.w),
              ],
            ).paddingBottom(200.h),
          ],
        ),
      ),
    );
  }
}
