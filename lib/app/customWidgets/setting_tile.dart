import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import '../config/app_colors.dart';
import '../config/app_text_style.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String iconPath; // SVG icon path
  final bool showToggle;
  final bool toggleValue;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleChanged;
  final bool isToggleLoading;

  const SettingsTile({
    super.key,
    required this.title,
    required this.iconPath,
    this.showToggle = false,
    this.toggleValue = false,
    this.onTap,
    this.onToggleChanged,
    this.isToggleLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showToggle ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, height: 25.h, width: 20.w,),
            12.w.width,
            // Title
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.customText16(color: AppColors.black, fontWeight: FontWeight.w600),
              ),
            ),
            // Right Side Widget
            if (showToggle)
              Align(
                alignment: Alignment.centerRight,
                child: isToggleLoading
                    ? Center(
                        child: CupertinoActivityIndicator(color: AppColors.secondaryBlack, radius: 12.sp),
                      )
                    : SizedBox(
                        height: 23.h,
                        child: Transform.scale(
                          scale: 0.8, // slightly smaller to match deszign
                          child: CupertinoSwitch(
                            inactiveTrackColor: AppColors.grey.withOpacity(0.3),
                            inactiveThumbColor: AppColors.white,
                            value: toggleValue,
                            activeTrackColor: AppColors.secondaryBlack,
                            onChanged: onToggleChanged,
                          ),
                        ),
                      ),
              )
            else
              Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.grey.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}
