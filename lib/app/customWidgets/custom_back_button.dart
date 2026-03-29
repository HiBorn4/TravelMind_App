import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../config/app_assets.dart';
import '../services/logger_service.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool? isWhite;

  const CustomBackButton({super.key, this.onTap, this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    LoggerService.i('White Status $isWhite');
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        if (onTap == null) {
          // Get.back();
          Navigator.pop(context);
        } else {
          onTap!();
        }
      },
      child: SvgPicture.asset(isWhite ?? false ? AppAssets.whiteBackButton : AppAssets.greyBackButton, height: 40.sp, width: 40.sp),
    );
  }
}
