import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_field.dart';
import 'package:vlad_ai/app/customWidgets/blur_container.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/login_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/signup_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../config/global_variables.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';

class OtpCodeView extends StatefulWidget {
  const OtpCodeView({super.key});

  @override
  State<OtpCodeView> createState() => _OtpCodeViewState();
}

class _OtpCodeViewState extends State<OtpCodeView> {
  final LoginController controller = Get.find();
  final SignUpController controllerSignUp = Get.find();
  String? from;
  String? email;

  @override
  void initState() {
    from = Get.arguments['from'];
    email = Get.arguments['email'];
    if (from == 'login') {
      controller.resendOtpApi(email ?? '');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.loginBg), fit: BoxFit.cover),
        ),
        child: Obx(() {
          return controller.isSendingOtp.value
              ? Center(child: CustomLoader())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Logo
                    // Image.asset(AppAssets.loveLogo, height: 80.h).animate().fadeIn(duration: 250.ms).slideY(begin: -0.3, end: 0, duration: 250.ms),
                    //
                    // 20.h.height,

                    // Blurry Card
                    BlurContainer(
                          width: double.infinity,
                          child: Column(
                            children: [
                              // Title
                              Text(
                                context.l10n!.enter_code,
                                style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.bold),
                              ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                              5.h.height,

                              // Subtitle
                              Text(
                                    "${context.l10n!.we_sent_a_verification_code_to_your_email} $email",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.customText16(color: Colors.black),
                                  )
                                  .animate(delay: 100.ms)
                                  .fadeIn(duration: 250.ms)
                                  .slideY(begin: 0.2, end: 0, duration: 250.ms),
                              20.h.height,
                              AppCustomField(
                                hintText: '000000',
                                controller: controller.otpController,
                                keyboardType: TextInputType.number,
                              ),
                              15.h.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(context.l10n!.didnt_receive, style: AppTextStyles.customText16(color: Colors.black)),
                                  InkWell(
                                    onTap: () {
                                      controller.resendOtpApi(email ?? '');
                                    },
                                    child: Text(
                                      context.l10n!.resend_otp,
                                      style: AppTextStyles.customText16(
                                        color: AppColors.logoGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              15.h.height,

                              // Sign up button
                              AppCustomButton(
                                    title: 'Next',
                                    onPressed: () async {
                                      if (controller.otpController.text.length < 6) {
                                        CustomSnackbar.show(
                                          // iconData: Icons.warning_amber,
                                          textColor: AppColors.black,
                                          title: context.l10n!.error,
                                          message: "",
                                          backgroundColor: AppColors.white,
                                          iconColor: AppColors.black,
                                          borderColor: AppColors.black,
                                          messageText: [context.l10n!.kindly_enter_correct_otp],
                                        );
                                      } else {
                                        Get.dialog(CustomLoader(), barrierDismissible: false);
                                        bool isVerified = await controller.verifyOtpApi(email ?? '');

                                        Get.back();
                                        if (isVerified) {
                                          controllerSignUp.clearData();
                                          Get.back();
                                          Get.back();
                                          CustomSnackbar.show(
                                            // iconData: Icons.check_circle,
                                            title: context.l10n!.success,
                                            message: "",
                                            textColor: AppColors.black,
                                            backgroundColor: AppColors.white,
                                            iconColor: AppColors.black,
                                            borderColor: AppColors.black,
                                            messageText: [
                                              context.l10n!.email_verified_successfully_you_can_login_to_your_account,
                                            ],
                                          );
                                        } else {
                                          CustomSnackbar.show(
                                            // iconData: Icons.warning_amber,
                                            textColor: AppColors.black,
                                            title: context.l10n!.error,
                                            message: "",
                                            backgroundColor: AppColors.white,
                                            iconColor: AppColors.black,
                                            borderColor: AppColors.black,
                                            messageText: GlobalVariables.errorMessages,
                                          );
                                        }
                                      }
                                    },
                                  )
                                  .animate(delay: 200.ms)
                                  .fadeIn(duration: 250.ms)
                                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 250.ms),
                            ],
                          ).paddingFromAll(13.sp),
                        )
                        .paddingHorizontal(15.w)
                        .animate()
                        .fadeIn(duration: 250.ms)
                        .slideY(begin: 0.4, end: 0, duration: 250.ms),

                    30.h.height,
                  ],
                );
        }),
      ),
    );
  }
}
