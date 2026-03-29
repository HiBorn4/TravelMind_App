import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vlad_ai/app/config/app_assets.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';

class GetStartedViewOne extends StatefulWidget {
  const GetStartedViewOne({super.key});

  @override
  State<GetStartedViewOne> createState() => _GetStartedViewOneState();
}

class _GetStartedViewOneState extends State<GetStartedViewOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          color: Color(0xffCCE9FB),
          image: DecorationImage(image: AssetImage(AppAssets.splashBg), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Main Heading
                Text(
                  context.l10n!.your_ai_powered_travel_companion,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.customText32(color: Colors.black, fontWeight: FontWeight.bold, height: 1.2),
                ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.3, end: 0, duration: 250.ms),

                4.h.height,

                // Sub Heading
                Text(
                      context.l10n!.plan_explore_and_navigate,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.customText16(color: Colors.black),
                    )
                    .paddingHorizontal(40.w)
                    .animate(delay: 150.ms) // little delay for staging
                    .fadeIn(duration: 250.ms)
                    .slideY(begin: 0.3, end: 0, duration: 250.ms),

                20.h.height,

                // Button
                AppCustomButton(
                      title: context.l10n!.continue_with_phone,
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.loginSelectionView);
                      },
                    )
                    .paddingHorizontal(30.w)
                    .animate(delay: 300.ms)
                    .fadeIn(duration: 250.ms)
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 250.ms),

                30.h.height,
              ],
            ),
            Positioned(
              top: 280.h,
              right: 0,
              left: 0,
              child: Lottie.asset(AppAssets.dancingLottie, height: 90.h),
            ),
          ],
        ),
      ),
    );
  }
}
