import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../app_custom_button.dart';

class ThankyouDialog extends StatelessWidget {
  const ThankyouDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n!.thank_you_for_your_confirmation,
            textAlign: TextAlign.center,
            style: AppTextStyles.customText22(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          15.h.height,
          AppCustomButton(
            title: context.l10n!.go_to_home,
            onPressed: () {
              Get.offAllNamed(AppRoutes.bottomBarView);
            },
          ).paddingHorizontal(35.w),
        ],
      ).paddingFromAll(15.sp),
    );
  }
}
