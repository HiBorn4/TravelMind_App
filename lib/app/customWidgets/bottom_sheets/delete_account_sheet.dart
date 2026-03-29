import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/app_custom_field.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/profile_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_style.dart';
import '../../config/global_variables.dart';
import '../app_custom_button.dart';
import '../custom_snackbar/custom_snackbar.dart';

class DeleteAccountSheet extends StatefulWidget {
  const DeleteAccountSheet({super.key});

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.sp),
              ),
              child: Column(
                children: [
                  10.h.height,
                  Text(
                    context.l10n!.delete_account,
                    style: AppTextStyles.customText22(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    context.l10n!.are_you_sure_you_want_to_delete_your_account,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.customText12(
                      color: AppColors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ).paddingHorizontal(30.w),
                  15.h.height,
                  AppCustomField(
                    labelTitle: context.l10n!.password,
                    controller: controller.passwordController,
                    hintText: context.l10n!.enter_password,
                  ),
                  15.h.height,
                  AppCustomButton(
                    title: context.l10n!.delete_account,
                    onPressed: () async {
                      if (controller.passwordController.text.length < 8) {
                        CustomSnackbar.show(
                          textColor: AppColors.black,
                          title: context.l10n!.error,
                          message: "",
                          backgroundColor: AppColors.white,
                          iconColor: AppColors.black,
                          borderColor: AppColors.black,
                          messageText: [context.l10n!.kindly_enter_correct_password],
                        );
                      } else {
                        Get.dialog(CustomLoader(), barrierDismissible: false);
                        bool isDeleted = await controller.deleteUserApi();
                        Get.back();
                        if (isDeleted) {
                          CustomSnackbar.show(
                            title: context.l10n!.success,
                            message: "",
                            textColor: AppColors.black,
                            backgroundColor: AppColors.white,
                            iconColor: AppColors.black,
                            borderColor: AppColors.black,
                            messageText: [context.l10n!.account_deleted],
                          );
                          Get.offAllNamed(AppRoutes.getStartedViewOne);
                        } else {
                          CustomSnackbar.show(
                            iconData: Icons.warning_amber,
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
                  15.h.height,
                ],
              ).paddingHorizontal(12.w),
            ),
          ],
        ),
      ),
    );
  }
}
