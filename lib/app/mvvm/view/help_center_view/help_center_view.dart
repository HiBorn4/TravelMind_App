import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/utils/localization_helper.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../config/app_text_style.dart';
import '../../../customWidgets/custom_app_bar.dart';

class HelpCenterController extends GetxController {
  final faqList = <Map<String, String>>[
    {
      'id': '1',
      'titleKey': 'help_about',
      'answerKey': 'help_about_answer',
    },
    {
      'id': '2',
      'titleKey': 'help_support',
      'answerKey': 'help_support_answer',
    },
    {
      'id': '3',
      'titleKey': 'help_accountInfo',
      'answerKey': 'help_accountInfo_answer',
    },
    {
      'id': '4',
      'titleKey': 'help_tech',
      'answerKey': 'help_tech_answer',
    },
    {
      'id': '5',
      'titleKey': 'help_privacySecurity',
      'answerKey': 'help_privacySecurity_answer',
    },
  ].obs;
}

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {
  final HelpCenterController controller = Get.put(HelpCenterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        toolBarHeight: 70.h,
        title: context.l10n!.how_can_we_help,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
      ),
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.scaffoldBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.faqList.length,
                    itemBuilder: (context, index) {
                      final faq = controller.faqList[index];
                      return GestureDetector(
                        onTap: () {
                          // Pass the category title to filter FAQs
                          Get.toNamed(AppRoutes.faqView, arguments: faq["titleKey"]!);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocalizationHelper.get(context, faq['titleKey']!),
                                style: AppTextStyles.customText16(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15.sp,
                                color: AppColors.textLightBlack,
                              ),
                            ],
                          ),
                        ),
                      ).paddingBottom(10.h);
                    },
                  ).paddingHorizontal(20.sp).paddingTop(20.h);
                }),
              ),
              AppCustomButton(
                title: "Report An Issue",
                onPressed: () async {
                  final Uri emailUri = Uri.parse(
                    'mailto:vladairomania@gmail.com?subject=Issue%20Report%20-%20Vlad%20AI%20App&body=Please%20describe%20your%20issue:',
                  );
                  await launchUrl(
                    emailUri,
                    mode: LaunchMode.externalApplication,
                  );
                },
              ).paddingHorizontal(20.w),
              60.h.height,
            ],
          ),
        ),
      ),
    );
  }
}
