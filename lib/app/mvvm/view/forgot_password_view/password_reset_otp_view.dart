import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/blur_container.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/forgot_password_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';

class PasswordResetOtpView extends StatefulWidget {
  const PasswordResetOtpView({super.key});

  @override
  State<PasswordResetOtpView> createState() => _PasswordResetOtpViewState();
}

class _PasswordResetOtpViewState extends State<PasswordResetOtpView> {
  final ForgotPasswordController controller = Get.find();
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get otpCode => otpControllers.map((c) => c.text).join();

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
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlurContainer(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          context.l10n!.otp_verification,
                          style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.bold),
                        ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                        5.h.height,

                        // Subtitle
                        Text(
                          context.l10n!.enterEmailOtp(controller.emailController.text,),
                          textAlign: TextAlign.left,
                          style: AppTextStyles.customText14(color: AppColors.textLightBlack),
                        ).animate(delay: 100.ms).fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                        25.h.height,

                        // OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            return Expanded(
                              child: Container(
                                height: 50.h,
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: otpControllers[index].text.isNotEmpty
                                        ? AppColors.secondaryBlack
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: TextField(
                                  controller: otpControllers[index],
                                  focusNode: focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: AppTextStyles.customText20(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                    if (value.isNotEmpty && index < 5) {
                                      focusNodes[index + 1].requestFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      focusNodes[index - 1].requestFocus();
                                    }
                                  },
                                ),
                              ),
                            );
                          }),
                        ),

                        20.h.height,

                        // Resend OTP
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.l10n!.didnt_receive,
                                style: AppTextStyles.customText14(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: controller.isSendingOtp.value
                                    ? null
                                    : () async {
                                        bool success = await controller.resendOtp();
                                        if (success) {
                                          CustomSnackbar.show(
                                            textColor: AppColors.black,
                                            title: context.l10n!.success,
                                            message: "",
                                            backgroundColor: AppColors.white,
                                            iconColor: AppColors.black,
                                            borderColor: AppColors.black,
                                            messageText: [context.l10n!.we_sent_a_verification_code_to_your_email],
                                          );
                                        }
                                      },
                                child: Text(
                                  controller.isSendingOtp.value ? context.l10n!.sending : context.l10n!.resend_otp,
                                  style: AppTextStyles.customText14(
                                    color: AppColors.logoGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        25.h.height,

                        // Continue button
                        AppCustomButton(
                              title: context.l10n!.continue_,
                              onPressed: () {
                                if (otpCode.length < 6) {
                                  CustomSnackbar.show(
                                    textColor: AppColors.black,
                                    title: context.l10n!.error,
                                    message: "",
                                    backgroundColor: AppColors.white,
                                    iconColor: AppColors.black,
                                    borderColor: AppColors.black,
                                    messageText: [context.l10n!.please_enter_the_complete_6_digit_otp],
                                  );
                                  return;
                                }
                                // Save OTP to controller and navigate to set password
                                controller.otpController.text = otpCode;
                                Get.toNamed(AppRoutes.setPasswordView);
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
