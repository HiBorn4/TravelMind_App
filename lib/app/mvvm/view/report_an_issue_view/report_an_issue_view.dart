import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/config/utils.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_button.dart';
import 'package:vlad_ai/app/customWidgets/bottom_sheets/thanks_contacting_sheet.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_style.dart';
import '../../../customWidgets/custom_app_bar.dart';

class ReportIssueView extends StatefulWidget {
  const ReportIssueView({super.key});

  @override
  State<ReportIssueView> createState() => _ReportIssueViewState();
}

class _ReportIssueViewState extends State<ReportIssueView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        toolBarHeight: 70.h,
        title: context.l10n!.report_an_issue,
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
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: SizedBox(
          height: 1.sh - kToolbarHeight,
          width: 1.sw,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.h.height,
                Text(context.l10n!.report_an_issue, style: AppTextStyles.customText24(fontWeight: FontWeight.w500)),
                Text(
                  context.l10n!.report_an_issue_you_are_facing,
                  style: AppTextStyles.customText14(fontWeight: FontWeight.w400, color: AppColors.textLightBlack),
                ),
                15.h.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n!.enter_issue,
                    style: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                6.h.height,
                TextFormField(
                  style: TextStyle(color: AppColors.darkTextColor),
                  textInputAction: TextInputAction.done,
                  minLines: 6,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintStyle: AppTextStyles.customText14(color: AppColors.textLightBlack),
                    hintText: context.l10n!.enter_here,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                    filled: true,
                    fillColor: AppColors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.sp),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.sp),
                      borderSide: BorderSide(color: AppColors.darkTextColor), // optional focus color
                    ),
                  ),
                ),

                20.h.height,
              ],
            ).paddingHorizontal(20.sp),
          ).paddingTop((kToolbarHeight + 40.h)),
        ),
      ),
      bottomNavigationBar: AppCustomButton(
        title: "Send",
        onPressed: () {
         Utils.showBottomSheet(context: context, child: ThanksContactingSheet());
        },
      ).paddingHorizontal(30.sp).paddingBottom(MediaQuery.viewInsetsOf(context).bottom + 30.h),
    );
  }
}
