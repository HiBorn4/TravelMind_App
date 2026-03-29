import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import '../config/app_colors.dart';
import '../config/app_text_style.dart';
import 'custom_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double? toolBarHeight;
  final Color? backButtonColor;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final double elevation;
  final double? titleTextFont;
  final Color backgroundColor;
  final Color shadowColor;
  final Color titleColor;
  final Widget? trailing;
  final Widget? leading;
  final bool shouldAddBG;
  final Widget? titleWidget;
  final double? leadingWidth;
  final double? borderRadius;
  final VoidCallback? onTrailingTap;
  final bool? isWhite;

  final SystemUiOverlayStyle? statusBarStyle;

  const CustomAppBar({
    super.key,
    this.title,
    this.leadingWidth,
    this.onBackPressed,
    this.centerTitle = true,
    this.elevation = 0.0,
    this.backgroundColor = AppColors.scaffoldBgColor,
    this.shadowColor = Colors.black,
    this.titleColor = Colors.black,
    this.trailing,
    this.leading,
    this.shouldAddBG = false,
    this.statusBarStyle,
    this.titleWidget,
    this.backButtonColor,
    this.toolBarHeight,
    this.borderRadius,
    this.titleTextFont,
    this.onTrailingTap,
    this.isWhite,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(borderRadius ?? 25.sp), // Adjust radius as needed
        ),
      ),
      automaticallyImplyLeading: false,
      titleSpacing: 10,
      toolbarHeight: toolBarHeight ?? kToolbarHeight,
      scrolledUnderElevation: 0.0,
      systemOverlayStyle:
          statusBarStyle ??
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.dark),
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      leadingWidth: leadingWidth ?? 70.w,
      elevation: elevation,

      shadowColor: shadowColor.withOpacity(0.3),
      centerTitle: centerTitle,
      leading:
          leading ??
          Container(
            color: Colors.transparent,
            child: Center(
              child:
                  leading ??
                  SizedBox(
                    width: 40.sp, // responsive width
                    height: 40.sp, // same as width → circle
                    child: CustomBackButton(isWhite: isWhite ?? false),
                  ).paddingLeft(15.w),
            ),
          ),
      // flexibleSpace: shouldAddBG,
      title: title != null
          ? Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: AppTextStyles.customText(fontSize: titleTextFont ?? 24, color: titleColor, fontWeight: FontWeight.bold, fontFamily: 'MontDark'),
            )
          : titleWidget,
      actions: [if (trailing != null) trailing!, 10.w.width],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight ?? kToolbarHeight);
}
