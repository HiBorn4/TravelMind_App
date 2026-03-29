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
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/notification_service_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../config/global_variables.dart';
import '../../../customWidgets/custom_loader.dart';
import '../../view_model/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FirebaseMessagingController messagecontroller = Get.find();
  final LoginController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.loginBg), fit: BoxFit.cover),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Logo
              // Image.asset(AppAssets.vladTextLogo, height: 50.h).animate().fadeIn(duration: 250.ms).slideY(begin: -0.3, end: 0, duration: 250.ms),
              // 10.h.height,
              // Blurry Card
              BlurContainer(
                width: double.infinity,
                child: Column(
                  children: [
                    // Title
                    Text(
                      context.l10n!.continue_with_email,
                      style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.bold),
                    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                    5.h.height,

                    // Subtitle
                    Text(
                      context.l10n!.sign_in_or_sign_up_with_your_email,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.customText16(color: Colors.black),
                    ).animate(delay: 100.ms).fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                    20.h.height,
                    AppCustomField(
                      hintText: context.l10n!.enter_email_address,
                      labelTitle: context.l10n!.email,
                      controller: controller.emailController,
                    ),
                    10.h.height,
                    Obx(() => AppCustomField(
                      hintText: context.l10n!.enter_password,
                      labelTitle: context.l10n!.password,
                      controller: controller.passwordController,
                      obscureText: !controller.isVisible.value,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.isVisible.value = !controller.isVisible.value;
                        },
                        child: Icon(
                          controller.isVisible.value ? Icons.visibility_off : Icons.visibility,
                          size: 15.sp,
                          color: AppColors.textLightBlack,
                        ).paddingVertical(20.h).paddingLeft(30.w),
                      ),
                    )),
                    15.h.height,
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.forgotPassView);
                      },
                      child: Text(
                        context.l10n!.forgot_password,
                        style: AppTextStyles.customText18(color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    15.h.height,

                    // Sign up button
                    AppCustomButton(
                          title: 'Login',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              Get.dialog(CustomLoader(), barrierDismissible: false);
                              // Ensure FCM token is available before login
                              debugPrint('=== FETCHING FCM TOKEN ===');
                              final fcmToken = await messagecontroller.ensureTokenAvailable();
                              debugPrint('FCM Token returned: $fcmToken');
                              debugPrint('FCM Token is null: ${fcmToken == null}');
                              debugPrint('FCM Token is empty: ${fcmToken?.isEmpty ?? true}');
                              bool isLogin = await controller.login(fcmToken ?? '');
                              Get.back();
                              if (isLogin) {
                                // CustomSnackbar.show(
                                //   iconData: Icons.check_circle,
                                //   title: "Success",
                                //   message: "",
                                //   textColor: AppColors.positiveGreen,
                                //   backgroundColor: AppColors.white,
                                //   iconColor: Colors.green,
                                //   borderColor: AppColors.positiveGreen,
                                //   messageText: ["User logged in Successfully"],
                                // );
                                Get.offAllNamed(AppRoutes.bottomBarView);
                              } else {
                                if (GlobalVariables.errorMessages.first.contains(
                                  "Please verify your email before logging in",
                                )) {
                                  Get.toNamed(
                                    AppRoutes.otpCodeView,
                                    arguments: {'from': "login", 'email': controller.emailController.text},
                                  );
                                }
                                // CustomSnackbar.show(
                                //   iconData: Icons.warning_amber,
                                //   textColor: AppColors.negativeRed,
                                //   title: "Error",
                                //   message: "",
                                //   backgroundColor: AppColors.white,
                                //   iconColor: AppColors.negativeRed,
                                //   borderColor: AppColors.negativeRed,
                                //   messageText: GlobalVariables.errorMessages,
                                // );
                              }
                            }
                          },
                        )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 250.ms)
                        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 250.ms),
                    5.h.height,
                    Obx(() {
                      return controller.showError.value
                          ? Text(
                              GlobalVariables.errorMessages[0],
                              style: AppTextStyles.customText16(color: Colors.red, fontWeight: FontWeight.w500),
                            )
                          : SizedBox.shrink();
                    }),
                    10.h.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.l10n!.dont_have_an_account, style: AppTextStyles.customText16(color: Colors.black)),
                        InkWell(
                          onTap: () {
                            Get.offAllNamed(AppRoutes.loginSelectionView);
                          },
                          child: Text(
                            context.l10n!.sign_up,
                            style: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ).paddingFromAll(13.sp),
              ).paddingHorizontal(15.w).animate().fadeIn(duration: 250.ms).slideY(begin: 0.4, end: 0, duration: 250.ms),

              30.h.height,
            ],
          ),
        ),
      ),
    );
  }
}
