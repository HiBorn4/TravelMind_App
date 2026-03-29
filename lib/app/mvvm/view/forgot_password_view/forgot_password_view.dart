import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_field.dart';
import 'package:vlad_ai/app/customWidgets/blur_container.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/forgot_password_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../config/global_variables.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final ForgotPasswordController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.loginBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BlurContainer(
                  width: double.infinity,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                              context.l10n!.forgot_password,
                              style: AppTextStyles.customText24(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 250.ms)
                            .slideY(begin: 0.2, end: 0, duration: 250.ms),

                        5.h.height,

                        // Subtitle
                        Text(
                              context.l10n!.enter_your_registered_email_address_for_verification,
                              textAlign: TextAlign.left,
                              style: AppTextStyles.customText14(
                                color: AppColors.textLightBlack,
                              ),
                            )
                            .animate(delay: 100.ms)
                            .fadeIn(duration: 250.ms)
                            .slideY(begin: 0.2, end: 0, duration: 250.ms),

                        20.h.height,

                        AppCustomField(
                          hintText: context.l10n!.enter_email_address,
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          labelTitle: context.l10n!.email_address,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return context.l10n!.email_is_required;
                            } else if (!emailRegex.hasMatch(val.trim())) {
                              return context.l10n!.please_enter_valid_email;
                            }
                            return null;
                          },
                        ),

                        20.h.height,

                        // Send button
                        AppCustomButton(
                              title: 'Send',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  Get.dialog(
                                    CustomLoader(),
                                    barrierDismissible: false,
                                  );
                                  bool success = await controller
                                      .forgotPassword();
                                  Get.back();
                                  if (success) {
                                    // Navigate to OTP verification screen
                                    Get.toNamed(AppRoutes.passwordResetOtpView);
                                  } else {
                                    CustomSnackbar.show(
                                      textColor: AppColors.black,
                                      title: "Error",
                                      message: "",
                                      backgroundColor: AppColors.white,
                                      iconColor: AppColors.black,
                                      borderColor: AppColors.black,
                                      messageText:
                                          GlobalVariables.errorMessages,
                                    );
                                  }
                                }
                              },
                            )
                            .animate(delay: 200.ms)
                            .fadeIn(duration: 250.ms)
                            .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1, 1),
                              duration: 250.ms,
                            ),
                      ],
                    ).paddingFromAll(13.sp),
                  ),
                )
                .paddingHorizontal(15.w)
                .animate()
                .fadeIn(duration: 250.ms)
                .slideY(begin: 0.4, end: 0, duration: 250.ms),

            30.h.height,
          ],
        ),
      ),
    );
  }
}
