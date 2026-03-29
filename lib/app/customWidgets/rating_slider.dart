import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import '../config/app_colors.dart';

class RatingSlider extends StatelessWidget {
  final int rating;
  final double? size;
  final double? padding;
  final bool isChangeable;

  final ValueChanged<int>? onRatingChanged;
  final ValueChanged<int>? onDragChanged;

  const RatingSlider({
    super.key,
    required this.rating,
    required this.isChangeable,
    this.size,
    this.padding,
    this.onRatingChanged,
    this.onDragChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return GestureDetector(
            onTap: isChangeable
                ? () {
                    HapticFeedback.selectionClick();
                    onRatingChanged?.call(index + 1);
                  }
                : null,
            onHorizontalDragUpdate: isChangeable
                ? (details) {
                    RenderBox box = context.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(details.globalPosition);
                    double screenWidth = box.size.width;
                    int newRating = ((localPosition.dx / screenWidth) * 5).clamp(0, 4).round() + 1;
                    HapticFeedback.selectionClick();
                    onDragChanged?.call(newRating);
                  }
                : null,
            child: Icon(
              Icons.star_rate_rounded,
              size: size ?? 40.sp,
              color: index < rating ? Colors.orangeAccent : AppColors.textLightBlack.withOpacity(0.5),
            ).paddingLeft(1.w),
          );
        }),
      ).paddingSymmetric(horizontal: padding ?? 0.w, vertical: padding ?? 5.h),
    );
  }
}
