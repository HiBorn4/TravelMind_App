import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/suggest_place_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../config/app_assets.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';
import '../app_custom_button.dart';

class BudgetSheet extends StatefulWidget {
  const BudgetSheet({super.key});

  @override
  State<BudgetSheet> createState() => _BudgetSheetState();
}

class _BudgetSheetState extends State<BudgetSheet> {
  final SuggestPlaceController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                              child: Icon(Icons.close, color: Colors.black, size: 20.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).paddingHorizontal(18.w),
                  10.h.height,
                  // 🔹 Blurred container with Calendar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.sp),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(24.sp),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Budget',
                              style: AppTextStyles.customText22(
                                color: AppColors.secondaryBlack,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            20.h.height,
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.sp),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '  \$',
                                        style: AppTextStyles.customText16(
                                          color: AppColors.secondaryBlack,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '  \$\$',
                                        style: AppTextStyles.customText16(
                                          color: AppColors.secondaryBlack,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '\$\$\$',
                                        style: AppTextStyles.customText16(
                                          color: AppColors.secondaryBlack,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ).paddingHorizontal(16.w),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Color(0xffE0F97D),
                                      inactiveTrackColor: Color(0xffE5E5EA),
                                      thumbColor: Color(0xFF2196F3),
                                      trackHeight: 6.0,
                                      thumbShape: ImageThumbShapeSuggest(
                                        imageAsset: AppAssets.thumbGreenImg,
                                        size: 50.h,
                                      ),
                                      overlayColor: Color(0xFF2196F3).withOpacity(0.2),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                                      trackShape: RoundedRectSliderTrackShape(),
                                    ),
                                    child: Obx(() {
                                      return Slider(
                                        value: controller.sliderValue.value,
                                        min: 0,
                                        max: 10,
                                        divisions: 2,
                                        // divides into 0, 5, 10
                                        onChanged: (double value) {
                                          // Snap to nearest fixed point
                                          double snappedValue;
                                          if (value < 2.5) {
                                            snappedValue = 0;
                                          } else if (value < 7.5) {
                                            snappedValue = 5;
                                          } else {
                                            snappedValue = 10;
                                          }
                                          controller.sliderValue.value = snappedValue;
                                        },
                                      );
                                    }),
                                  ),
                                ],
                              ).paddingHorizontal(13.sp).paddingTop(13.sp),
                            ).paddingHorizontal(10.w),
                            25.h.height,
                            AppCustomButton(
                              title: context.l10n!.next,
                              onPressed: () {
                                Get.back();
                              },
                            ).paddingHorizontal(35.w),
                          ],
                        ).paddingFromAll(12.sp).paddingHorizontal(6.w),
                      ).paddingHorizontal(10.w).paddingBottom(10.h),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _seasonItem(String title, String value) {
  //   return GestureDetector(
  //     onTap: () {
  //       controller.selectedLocationStyle.value = value;
  //     },
  //     child: Container(
  //       height: 45.h,
  //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.sp)),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Obx(() {
  //             return controller.selectedLocationStyle.value == value
  //                 ? SvgPicture.asset(AppAssets.selectedTickIcon)
  //                 : Container(
  //                     height: 15.h,
  //                     width: 15.w,
  //                     decoration: BoxDecoration(
  //                       color: Colors.transparent,
  //                       borderRadius: BorderRadius.circular(2.sp),
  //                       border: Border.all(color: AppColors.textLightBlack, width: 2),
  //                     ),
  //                   );
  //           }),
  //           10.w.width,
  //           Text(title, style: AppTextStyles.customText18(color: Colors.black)),
  //         ],
  //       ).paddingHorizontal(15.w),
  //     ),
  //   );
  // }
}

class ImageThumbShapeSuggest extends SliderComponentShape {
  final String imageAsset;
  final double size;
  static final Map<String, ui.Image> _cache = {}; // 🔹 cache images

  const ImageThumbShapeSuggest({required this.imageAsset, this.size = 30});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(size, size);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    double topPadding = 3.h; // 🔹 Adjust this for more/less padding

    // if image is cached, draw immediately
    if (_cache.containsKey(imageAsset)) {
      final img = _cache[imageAsset]!;
      final dst = Rect.fromCenter(
        center: center.translate(0, topPadding), // 🔹 shift down
        width: size,
        height: size,
      );

      paintImage(canvas: canvas, rect: dst, image: img, fit: BoxFit.contain);
      return;
    }

    // if not cached, load once
    final assetImage = AssetImage(imageAsset);
    assetImage
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            _cache[imageAsset] = info.image; // cache it
            SchedulerBinding.instance.addPostFrameCallback((_) {
              parentBox.markNeedsPaint();
            });
          }),
        );
  }
}
