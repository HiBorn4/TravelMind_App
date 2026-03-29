import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/profile_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../config/global_variables.dart';
import '../../../config/utils.dart';
import '../../../customWidgets/app_custom_field.dart';
import '../../../customWidgets/custom_app_bar.dart';
import '../../../customWidgets/custom_cache_image/custom_cached_image.dart';
import '../../../customWidgets/custom_loader.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';

class AccountSettingView extends StatefulWidget {
  const AccountSettingView({super.key});

  @override
  State<AccountSettingView> createState() => _AccountSettingViewState();
}

class _AccountSettingViewState extends State<AccountSettingView> {
  final ProfileController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        title: context.l10n!.account_settings,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20.sp),
        ),
      ),
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: SafeArea(
          top: true,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.sp),
                            topRight: Radius.circular(32.sp),
                          ),
                        ),
                        child: Column(
                          children: [
                            20.h.height,
                            AppCustomField(
                              hintText: context.l10n!.enter_first_name,
                              labelTitle: context.l10n!.first_name,
                              controller: controller.firstNameController,
                            ),
                            10.h.height,
                            AppCustomField(
                              hintText: context.l10n!.enter_last_name,
                              labelTitle: context.l10n!.last_name,
                              controller: controller.lastNameController,
                            ),
                            10.h.height,
                            AppCustomField(
                              hintText: context.l10n!.enter_email_address,
                              keyboardType: TextInputType.emailAddress,
                              labelTitle: context.l10n!.email_address,
                              isReadOnly: true,
                              controller: controller.emailController,
                            ),
                            10.h.height,
                            AppCustomField(
                              hintText: context.l10n!.enter_phone,
                              labelTitle: context.l10n!.phone_number,
                              controller: controller.phoneNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            10.h.height,
                            AppCustomField(
                              hintText: context.l10n!.enter_nation,
                              labelTitle: context.l10n!.nationality,
                              controller: controller.nationalityController,
                            ),
                            10.h.height,
                            AppCustomField(
                              hintText: context.l10n!.enter_city,
                              labelTitle: context.l10n!.city,
                              controller: controller.cityController,
                            ),
                            20.h.height,
                            AppCustomButton(
                              title: context.l10n!.save,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  Get.dialog(CustomLoader(), barrierDismissible: false);
                                  bool isLogin = await controller.updateProfileApi();
                                  Get.back();
                                  if (isLogin) {
                                    Get.back();
                                    CustomSnackbar.show(
                                      // iconData: Icons.check_circle,
                                      title: context.l10n!.success,
                                      message: "",
                                      textColor: AppColors.black,
                                      backgroundColor: AppColors.white,
                                      iconColor: AppColors.black,
                                      borderColor: AppColors.black,
                                      messageText: [context.l10n!.profile_updated],
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
                            ).paddingHorizontal(35.w),
                            70.h.height,
                          ],
                        ).paddingHorizontal(15.w).paddingTop(50.h),
                      ),
                      // Avatar on top
                      Positioned(
                        top: -60.h,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Obx(() {
                              return controller.rXfile.value == null
                                  ? CustomCachedImage(
                                          height: 100.sp,
                                          width: 100.sp,
                                          imageUrl: controller.user?.profileImage ?? '',
                                          borderRadius: 100.sp,
                                          name: "${controller.user?.firstName} ${controller.user?.lastName}",
                                        )
                                        .animate()
                                        .fadeIn(duration: 250.ms)
                                        .scale(begin: Offset(0.9, 0.9), end: Offset(1, 1), duration: 250.ms)
                                  : Container(
                                          height: 100.sp,
                                          width: 100.sp,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100.sp),
                                            color: AppColors.white,
                                            image: DecorationImage(
                                              image: FileImage(controller.rXfile.value!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(duration: 250.ms)
                                        .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1), duration: 250.ms)
                                        .slideY(begin: 0.2, end: 0, duration: 250.ms, curve: Curves.easeOut);
                            }),
                            Positioned(
                              right: 0,
                              left: 0,
                              bottom: -10.h,
                              child: GestureDetector(
                                onTap: () {
                                  Utils.showPickImageOptionsDialog(
                                    context,
                                    onCameraTap: () async {
                                      Navigator.of(context).pop();
                                      await controller.pickImageFromCamera();
                                    },
                                    onGalleryTap: () async {
                                      Navigator.of(context).pop();
                                      await controller.pickImageFromGallery();
                                    },
                                  );
                                },
                                child: SvgPicture.asset(AppAssets.cameraIcon, height: 30.h, color: AppColors.secondary)
                                    .animate()
                                    .fadeIn(duration: 250.ms)
                                    .scale(begin: Offset(0.7, 0.7), end: Offset(1, 1), duration: 250.ms),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ).paddingTop((kToolbarHeight + 20).h),
            ),
          ),
        ),
      ),
    );
  }
}
