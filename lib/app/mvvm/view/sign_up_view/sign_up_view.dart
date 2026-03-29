import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_field.dart';
import 'package:vlad_ai/app/customWidgets/blur_container.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/signup_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/notification_service_controller.dart';
import 'package:vlad_ai/app/mvvm/model/body_model/countries_model.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../config/global_variables.dart';
import '../../../config/utils.dart';
import '../../../customWidgets/custom_loader.dart';
import '../../../customWidgets/custom_pickers/country_picker.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final SignUpController controller = Get.find();
  final FirebaseMessagingController messageController = Get.find();
  final _formKey = GlobalKey<FormState>(); // ✅ Form Key

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.loginBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey, // ✅ Attached form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlurContainer(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                                  context.l10n!.continue_with_email,
                                  style: AppTextStyles.customText24(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 250.ms)
                                .slideY(begin: 0.2, end: 0, duration: 250.ms),

                            5.h.height,

                            Text(
                                  context.l10n!.sign_in_or_sign_up_with_your_email,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.customText16(
                                    color: Colors.black,
                                  ),
                                )
                                .animate(delay: 100.ms)
                                .fadeIn(duration: 250.ms)
                                .slideY(begin: 0.2, end: 0, duration: 250.ms),

                            20.h.height,

                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Obx(() {
                                  return Container(
                                        height: 100.sp,
                                        width: 100.sp,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            100.sp,
                                          ),
                                          color: AppColors.white,
                                          image: DecorationImage(
                                            image:
                                                controller.rXfile.value == null
                                                ? AssetImage(
                                                    AppAssets.placeholderMan,
                                                  )
                                                : FileImage(
                                                        controller
                                                            .rXfile
                                                            .value!,
                                                      )
                                                      as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                      .animate()
                                      .scale(
                                        begin: Offset(0.8, 0.8),
                                        end: Offset(1, 1),
                                        curve: Curves.easeOutBack,
                                        duration: 400.ms,
                                      )
                                      .fadeIn(duration: 300.ms);
                                }),
                                Positioned(
                                  right: 0.w,
                                  left: 0,
                                  bottom: -10.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      Utils.showPickImageOptionsDialog(
                                        context,
                                        onCameraTap: () async {
                                          Navigator.of(context).pop();
                                          await controller
                                              .pickImageFromCamera();
                                        },
                                        onGalleryTap: () async {
                                          Navigator.of(context).pop();
                                          await controller
                                              .pickImageFromGallery();
                                        },
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      AppAssets.cameraIcon,
                                      height: 30.h,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            20.h.height,

                            AppCustomField(
                              hintText: context.l10n!.enter_first_name,
                              labelTitle: context.l10n!.first_name,
                              controller: controller.firstNameController,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return context.l10n!.first_name_is_required;
                                }
                                return null;
                              },
                            ),

                            10.h.height,

                            AppCustomField(
                              hintText: context.l10n!.enter_last_name,
                              labelTitle: context.l10n!.last_name,
                              controller: controller.lastNameController,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return context.l10n!.last_name_is_required;
                                }
                                return null;
                              },
                            ),

                            10.h.height,

                            AppCustomField(
                              hintText: context.l10n!.enter_email_address,
                              keyboardType: TextInputType.emailAddress,
                              labelTitle: context.l10n!.email_address,
                              controller: controller.emailController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return context.l10n!.email_is_required;
                                }
                                if (!_emailRegExp.hasMatch(val)) {
                                  return context.l10n!.enter_a_valid_email;
                                }
                                return null;
                              },
                            ),

                            10.h.height,

                            Obx(
                              () => CountryPickerWidget(
                                selectedCountry:
                                    controller.selectedCountry.value,
                                onCountrySelected: (con) {
                                  controller.selectedCountry.value = con;
                                },
                                onPhoneNumberChanged: (val) {
                                  controller.updateCompletePhoneNumber();
                                },
                                controller: controller.phoneNumberController,
                                labelText: context.l10n!.phone_number,
                                contentPadding: EdgeInsets.only(top: 15.h),
                              ),
                            ),

                            10.h.height,

                            // Nationality Dropdown
                            Obx(() {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                   context.l10n!.nationality,
                                    style: AppTextStyles.customText(
                                      fontSize: 16,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  DropdownButtonFormField<CountryModel>(
                                    initialValue: controller.selectedNationality.value,
                                    decoration: InputDecoration(
                                      hintText: context.l10n!.select_nationality,
                                      hintStyle: AppTextStyles.customText(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textLightBlack,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.transparent,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0.w,
                                        vertical: 15.h,
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.textLightBlack.withOpacity(0.4),
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.textLightBlack.withOpacity(0.4),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.negativeRed,
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                      errorStyle: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    isExpanded: true,
                                    icon: controller.isLoadingCountries.value
                                        ? SizedBox(
                                            width: 20.sp,
                                            height: 20.sp,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.secondaryBlack,
                                            ),
                                          )
                                        : Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: AppColors.textLightBlack,
                                          ),
                                    style: AppTextStyles.customText(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    items: controller.countriesList
                                        .map((country) => DropdownMenuItem<CountryModel>(
                                              value: country,
                                              child: Text(
                                                country.name,
                                                style: AppTextStyles.customText(
                                                  fontSize: 16,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      controller.selectedNationality.value = value;
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return context.l10n!.nationality_is_required;
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              );
                            }),

                            10.h.height,

                            AppCustomField(
                              hintText: context.l10n!.enter_city,
                              labelTitle: context.l10n!.city,
                              controller: controller.cityController,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return context.l10n!.city_is_required;
                                }
                                return null;
                              },
                            ),

                            10.h.height,

                            Obx(() {
                              return AppCustomField(
                                hintText: context.l10n!.enter_password,
                                labelTitle: context.l10n!.password,
                                controller: controller.passwordController,
                                obscureText: !controller.isVisible.value,
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
                                    controller.isVisible.value =
                                        !controller.isVisible.value;
                                  },
                                  child: Icon(
                                    controller.isVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 15.sp,
                                    color: AppColors.textLightBlack,
                                  ).paddingVertical(20.h).paddingLeft(30.w),
                                ),
                              );
                            }),

                            10.h.height,
                            Obx(() {
                              return AppCustomField(
                                hintText: context.l10n!.enter_confirm_password,
                                labelTitle: context.l10n!.confirm_password,
                                controller:
                                    controller.confirmPasswordController,
                                obscureText:
                                    !controller.isVisibleConfirmPassword.value,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return context.l10n!.confirm_your_password;
                                  }
                                  if (val != controller.passwordController.text) {
                                    return context.l10n!.passwords_do_not_match;
                                  }
                                  return null;
                                },
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    controller.isVisibleConfirmPassword.value =
                                        !controller
                                            .isVisibleConfirmPassword
                                            .value;
                                  },
                                  child: Icon(
                                    controller.isVisibleConfirmPassword.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 15.sp,
                                    color: AppColors.textLightBlack,
                                  ).paddingVertical(20.h).paddingLeft(30.w),
                                ),
                              );
                            }),

                            16.h.height,

                            // Privacy Policy Checkbox
                            Obx(
                              () => _buildCheckboxRow(
                                value: controller.acceptedPrivacyPolicy.value,
                                onChanged: (val) =>
                                    controller.acceptedPrivacyPolicy.value =
                                        val ?? false,
                                text: context.l10n!.i_agree_to_the,
                                linkText: context.l10n!.privacy_policy,
                                onLinkTap: () =>
                                    Get.toNamed(AppRoutes.privacyPolicyView),
                              ),
                            ),
 
                            8.h.height,

                            // Terms & Conditions Checkbox
                            Obx(
                              () => _buildCheckboxRow(
                                value: controller.acceptedTerms.value,
                                onChanged: (val) =>
                                    controller.acceptedTerms.value =
                                        val ?? false,
                                text: context.l10n!.i_agree_to_the,
                                linkText: context.l10n!.terms_conditions,
                                onLinkTap: () =>
                                    Get.toNamed(AppRoutes.termsConditionsView),
                              ),
                            ),

                            20.h.height,

                            Obx(
                                  () => AppCustomButton(
                                    title: 'Next',
                                    bgColor: controller.canSignUp
                                        ? null
                                        : Colors.grey.shade400,
                                    onPressed: () async {
                                      if (!controller.canSignUp) return;
                                      if (_formKey.currentState!.validate()) {
                                        Get.dialog(
                                          CustomLoader(),
                                          barrierDismissible: false,
                                        );
                                        // Ensure FCM token is available before signup
                                        final fcmToken = await messageController.ensureTokenAvailable();
                                        bool isSignUp = await controller
                                            .signUp(fcmToken);
                                        Get.back();
                                        if (isSignUp) {
                                          Get.toNamed(
                                            AppRoutes.otpCodeView,
                                            arguments: {
                                              'from': "register",
                                              'email': controller
                                                  .emailController
                                                  .text,
                                            },
                                          );
                                        }
                                      }
                                    },
                                  ),
                                )
                                .animate(delay: 200.ms)
                                .fadeIn(duration: 250.ms)
                                .scale(
                                  begin: const Offset(0.9, 0.9),
                                  end: const Offset(1, 1),
                                  duration: 250.ms,
                                ),
                            5.h.height,
                            Obx(() {
                              return controller.showError.value
                                  ? Text(
                                      GlobalVariables.errorMessages[0],
                                      style: AppTextStyles.customText16(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : SizedBox.shrink();
                            }),
                            10.h.height,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.l10n!.already_have_an_account,
                                  style: AppTextStyles.customText16(
                                    color: Colors.black,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.offAllNamed(
                                      AppRoutes.loginSelectionView,
                                    );
                                  },
                                  child: Text(
                                    context.l10n!.sign_in,
                                    style: AppTextStyles.customText16(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ).paddingFromAll(13.sp),
                      )
                      .paddingHorizontal(15.w)
                      .animate()
                      .fadeIn(duration: 250.ms)
                      .slideY(begin: 0.4, end: 0, duration: 250.ms),

                  30.h.height,
                ],
              ),
            ),
          ),
        ).paddingTop(60.h),
      ),
    );
  }

  Widget _buildCheckboxRow({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String text,
    required String linkText,
    required VoidCallback onLinkTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 24.sp,
          width: 24.sp,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.secondaryBlack,
            checkColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            side: BorderSide(color: AppColors.secondaryBlack, width: 1.5),
          ),
        ),
        8.w.width,
        Expanded(
          child: GestureDetector(
            onTap: onLinkTap,
            child: RichText(
              text: TextSpan(
                text: text,
                style: AppTextStyles.customText14(color: Colors.black),
                children: [
                  TextSpan(
                    text: linkText,
                    style: AppTextStyles.customText14(
                      color: AppColors.secondaryBlack,
                      fontWeight: FontWeight.w600,
                    ).copyWith(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
