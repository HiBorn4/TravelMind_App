import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/blur_container.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';

class LoginSelectionView extends StatefulWidget {
  const LoginSelectionView({super.key});

  @override
  State<LoginSelectionView> createState() => _LoginSelectionViewState();
}

class _LoginSelectionViewState extends State<LoginSelectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.loginBg), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // // Logo
            // Image.asset(AppAssets.vladTextLogo, height: 50.h).animate().fadeIn(duration: 250.ms).slideY(begin: -0.3, end: 0, duration: 250.ms),
            //
            // 10.h.height,

            // Blurry Card
            BlurContainer(
              width: double.infinity,
              child: Column(
                children: [
                  // Title
                  Text(
                    context.l10n!.get_started,
                    style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.bold),
                  ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                  5.h.height,

                  // Subtitle
                  Text(
                    context.l10n!.register_for_trips_subscribe_to_calendars_and_manage_trips_you_are_going_to,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.customText16(color: Colors.black),
                  ).animate(delay: 100.ms).fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                  20.h.height,

                  // Sign up button
                  AppCustomButton(
                        title: context.l10n!.sign_up,
                        onPressed: () {
                          Get.toNamed(AppRoutes.signUpView);
                        },
                      )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 250.ms)
                      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 250.ms),

                  10.h.height,

                  // Sign in button
                  AppCustomButton(
                        title: context.l10n!.sign_in,
                        onPressed: () {
                          Get.toNamed(AppRoutes.loginView);
                        },
                        bgColor: Colors.white,
                        textStyle: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w600),
                      )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 250.ms)
                      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 250.ms),

                  10.h.height,

                  // Social buttons row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50.sp)),
                          child: Center(child: SvgPicture.asset(AppAssets.appleIcon, height: 30.h)),
                        ),
                      ),
                      10.w.width,
                      Expanded(
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50.sp)),
                          child: Center(child: Image.asset(AppAssets.googleIcon, height: 30.h)),
                        ),
                      ),
                    ],
                  ).animate(delay: 400.ms).fadeIn(duration: 250.ms).slideY(begin: 0.3, end: 0, duration: 250.ms),
                ],
              ).paddingFromAll(13.sp),
            ).paddingHorizontal(15.w).animate().fadeIn(duration: 250.ms).slideY(begin: 0.4, end: 0, duration: 250.ms),

            30.h.height,
          ],
        ),
      ),
    );
  }
}
