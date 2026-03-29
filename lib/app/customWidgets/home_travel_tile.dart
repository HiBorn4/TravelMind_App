import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';

import '../config/app_assets.dart';
import 'custom_cache_image/custom_cached_image.dart';

class HomeTravelTile extends StatelessWidget {
  final String? image;
  final String? tripType;
  final String? type;
  final String? duration;
  final String? title;
  final String? startDate;
  final double? width;
  final bool? isFav;
  final VoidCallback? onTap;
  final VoidCallback? onTapFav;
  final bool? showFavIcon;

  const HomeTravelTile({
    super.key,
    this.image,
    this.onTapFav,
    this.showFavIcon,
    this.tripType,
    this.type,
    this.duration,
    this.title,
    this.onTap,
    required this.isFav,
    this.width,
    this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CustomCachedImage(
            height: 200.h,
            width: width ?? ScreenUtil().screenWidth,
            imageUrl: image ?? 'https://images.unsplash.com/photo-1551836022-d5d88e9218df',
            borderRadius: 18.sp,
            fit: BoxFit.fill,
          ),
          if (showFavIcon == null)
            Positioned(
              top: 10.h,
              right: 10.w,
              child: GestureDetector(
                onTap: onTapFav,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(6.sp),
                      // ignore: deprecated_member_use
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                      child: Image.asset(AppAssets.heartIcon, height: 20.h, color: isFav == true ? Colors.red : null),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 10.w,
            left: 10.w,
            bottom: 10.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.sp),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? 'Northern Lights - Westcott ',
                        style: AppTextStyles.customText18(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      // 2.h.height,
                      // if (startDate != null)
                      //   Text(
                      //     // DateFormat('E, d MMM').format(DateTime.parse(startDate!)),
                      //     startDate.toString(),
                      //     style: AppTextStyles.customText12(color: Colors.white.withOpacity(0.8)),
                      //   ),
                      7.h.height,
                      Row(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppAssets.daysIcon),
                              5.w.width,
                              Text('${duration ?? '5'} Days', style: AppTextStyles.customText12(color: Colors.white)),
                            ],
                          ),
                          10.w.width,
                          Row(
                            children: [
                              SvgPicture.asset(AppAssets.coupleIcon),
                              5.w.width,
                              Text(type ?? 'Couple', style: AppTextStyles.customText12(color: Colors.white)),
                            ],
                          ),
                          10.w.width,
                          Row(
                            children: [
                              SvgPicture.asset(AppAssets.luxuryIcon),
                              5.w.width,
                              Text(tripType ?? 'Luxury', style: AppTextStyles.customText12(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
