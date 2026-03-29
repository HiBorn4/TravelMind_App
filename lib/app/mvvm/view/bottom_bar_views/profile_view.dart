import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/bottom_sheets/delete_account_sheet.dart';
import 'package:vlad_ai/app/customWidgets/custom_app_bar.dart';
import 'package:vlad_ai/app/customWidgets/custom_cache_image/custom_cached_image.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/setting_tile.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../config/utils.dart';
import '../../../customWidgets/bottom_sheets/language_sheet.dart';
import '../../../services/shared_preferences_service.dart';
import '../../view_model/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.fetchUserData();
    super.initState();
  }

  Future<void> _onRefresh() async {
    await controller.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: context.l10n!.my_profile, backgroundColor: Colors.transparent, leading: const SizedBox.shrink()),
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: Obx(() {
          return controller.isUserLoading.value
              ? const CustomLoader().paddingBottom(100.h)
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      /// --- Profile Image with animation ---
                      CustomCachedImage(
                            height: 100.sp,
                            width: 100.sp,
                            imageUrl: controller.user?.profileImage ?? '',
                            borderRadius: 100.sp,
                            name: "${controller.user?.firstName} ${controller.user?.lastName}",
                          )
                          .animate()
                          .fadeIn(duration: 250.ms)
                          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 250.ms),

                      10.h.height,

                      /// --- Name ---
                      Text(
                        "${controller.user?.firstName} ${controller.user?.lastName}",
                        style: AppTextStyles.customText20(color: Colors.black, fontWeight: FontWeight.w600),
                      ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                      3.h.height,

                      /// --- Email ---
                      Text(
                            controller.user?.email ?? 'N/A',
                            style: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w500),
                          )
                          .animate()
                          .fadeIn(duration: 250.ms)
                          .slideY(begin: 0.2, end: 0, duration: 250.ms, delay: 100.ms),

                      20.h.height,

                      /// --- Settings Section ---
                      Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32.sp)),
                        child: Column(
                          children: [
                            SettingsTile(
                              title: context.l10n!.account_settings,
                              iconPath: AppAssets.accountSettingIcon,
                              onTap: () => Get.toNamed(AppRoutes.accountSettingView),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.4)),
                            // Obx(
                            //   () => GestureDetector(
                            //     onTap: () {
                            //       // 🔁 Toggle the value when tapping the entire tile
                            //       controller.pushNotificationsValue.value = !controller.pushNotificationsValue.value;

                            //       LoggerService.i(
                            //         '🔔 Push Notifications toggled via tap → ${controller.pushNotificationsValue.value}',
                            //       );
                            //     },
                            //     child: SettingsTile(
                            //       title: 'Push Notifications',
                            //       iconPath: AppAssets.pushNotificationIcon,
                            //       showToggle: true,
                            //       onToggleChanged: (val) {
                            //         controller.pushNotificationsValue.value = val;

                            //         LoggerService.i(
                            //           '🔔 Push Notifications toggled via switch → ${controller.pushNotificationsValue.value}',
                            //         );
                            //       },
                            //       toggleValue: controller.pushNotificationsValue.value,
                            //     ),
                            //   ),
                            // ),

                            // Divider(color: Colors.grey.withOpacity(0.4)),
                            SettingsTile(
                              title: context.l10n!.language,
                              iconPath: AppAssets.languageIcon,
                              onTap: () {
                                Utils.showBottomSheet(
                                  context: context,
                                  child: LanguageSheet(),
                                );
                              },
                            ),                            Divider(color: Colors.grey.withOpacity(0.4)),
                            SettingsTile(
                              title: context.l10n!.faq,
                              iconPath: AppAssets.faqIcon,
                              onTap: () => Get.toNamed(AppRoutes.helpCenterView),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.4)),
                            SettingsTile(
                              title: context.l10n!.privacy_policy,
                              iconPath: AppAssets.privacyPolicyIcon,
                              onTap: () => Get.toNamed(AppRoutes.privacyPolicyView),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.4)),
                            SettingsTile(
                              title: context.l10n!.terms_conditions,
                            iconPath: AppAssets.termsIcon,
                            onTap: () => Get.toNamed(AppRoutes.termsConditionsView),
                          ),
                            Divider(color: Colors.grey.withOpacity(0.4)),
                            SettingsTile(
                              title: context.l10n!.logout,
                              iconPath: AppAssets.logoutIcon,
                              onTap: () {
                                SharedPreferencesService().clearAllPreferences();
                                Get.offAllNamed(AppRoutes.getStartedViewOne);
                              },
                            ),
                            Divider(color: Colors.grey.withOpacity(0.4)),
                            SettingsTile(
                              title: context.l10n!.delete_account,
                              iconPath: AppAssets.deleteAccountIcon,
                              onTap: () {
                                Utils.showBottomSheet(context: context, child: DeleteAccountSheet());
                              },
                            ),
                          ],
                        ).paddingFromAll(8.sp),
                      ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0, duration: 250.ms),

                      120.h.height,
                    ],
                  ).paddingHorizontal(20.w),
                );
        }).paddingTop((kToolbarHeight + 40).h),
      ),
    );
  }
}
