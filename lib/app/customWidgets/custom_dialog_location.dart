import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';

/// ✅ Cupertino Location Info Dialog (Displays Snackbar Info)
class CupertinoLocationInfoDialog extends StatelessWidget {
  final String city;
  final String country;
  final String address;

  const CupertinoLocationInfoDialog({super.key, required this.city, required this.country, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 38.sp),
        10.verticalSpace,
        Text(
          "Location Selected",
          style: AppTextStyles.customText18(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        15.verticalSpace,
        _infoRow("City", city),
        _infoRow("Country", country),
        _infoRow("Address", address),
        25.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _button(context, "Accept", AppColors.primary, Colors.black),
            15.horizontalSpace,
            _button(context, "Close", Colors.black, Colors.white),
          ],
        ),
      ],
    );
  }

  Widget _button(BuildContext context, String text, Color bg, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          text.toLowerCase() == 'accept' ? Get.toNamed(AppRoutes.suggestPlaceSelectionView) : Get.back();
        },
        child: Container(
          height: 45.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12.sp)),
          child: Text(
            text,
            style: AppTextStyles.customText16(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: AppTextStyles.customText16(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.customText16(color: Colors.black87, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
