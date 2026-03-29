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

class SetPasswordView extends StatefulWidget {
  const SetPasswordView({super.key});

  @override
  State<SetPasswordView> createState() => _SetPasswordViewState();
}

class _SetPasswordViewState extends State<SetPasswordView> {
  final ForgotPasswordController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            BlurContainer(
              width: double.infinity,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      context.l10n!.set_password,
                      style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.bold),
                    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                    5.h.height,

                    // Subtitle
                    Text(
                      context.l10n!.please_set_your_password,
                      textAlign: TextAlign.left,
                      style: AppTextStyles.customText14(color: AppColors.textLightBlack),
                    ).animate(delay: 100.ms).fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                    20.h.height,

                    // New Password Field
                    Obx(() => AppCustomField(
                          hintText: context.l10n!.enter_new_password,
                          controller: controller.newPasswordController,
                          labelTitle: context.l10n!.set_password,
                          obscureText: !controller.isPasswordVisible.value,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return context.l10n!.password_is_required;
                            }
                            if (val.length < 8) {
                              return context.l10n!.password_must_be_at_least_6_characters;
                            }
                            return null;
                          },
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                            },
                            child: Icon(
                              controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                              size: 18.sp,
                              color: AppColors.textLightBlack,
                            ).paddingVertical(15.h).paddingLeft(30.w),
                          ),
                        )),

                    15.h.height,

                    // Confirm Password Field
                    Obx(() => AppCustomField(
                          hintText: context.l10n!.confirm_new_password,
                          controller: controller.confirmPasswordController,
                          labelTitle: context.l10n!.confirm_new_password_capital,
                          obscureText: !controller.isConfirmPasswordVisible.value,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return context.l10n!.please_confirm_your_password;
                            }
                            if (val != controller.newPasswordController.text) {
                              return context.l10n!.passwords_do_not_match;
                            }
                            return null;
                          },
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.isConfirmPasswordVisible.value =
                                  !controller.isConfirmPasswordVisible.value;
                            },
                            child: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 18.sp,
                              color: AppColors.textLightBlack,
                            ).paddingVertical(15.h).paddingLeft(30.w),
                          ),
                        )),

                    25.h.height,

                    // Set Password button
                    AppCustomButton(
                          title: context.l10n!.set_password,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              Get.dialog(CustomLoader(), barrierDismissible: false);
                              bool success = await controller.resetPassword();
                              Get.back();
                              if (success) {
                                controller.clearAllData();
                                // Navigate back to login
                                Get.offAllNamed(AppRoutes.loginView);
                                CustomSnackbar.show(
                                  textColor: AppColors.black,
                                  title: context.l10n!.success,
                                  message: "",
                                  backgroundColor: AppColors.white,
                                  iconColor: AppColors.black,
                                  borderColor: AppColors.black,
                                  messageText: [context.l10n!.password_reset_successfully_you_can_now_login_with_your_new_password],
                                );
                              } else {
                                CustomSnackbar.show(
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
              ),
            ).paddingHorizontal(15.w).animate().fadeIn(duration: 250.ms).slideY(begin: 0.4, end: 0, duration: 250.ms),

            30.h.height,
          ],
        ),
      ),
    );
  }
}
