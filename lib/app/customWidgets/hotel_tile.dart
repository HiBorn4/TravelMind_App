import 'dart:ui'; // <-- needed for ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';

import '../config/app_text_style.dart';
import 'custom_cache_image/custom_cached_image.dart';

class MainHotelTile extends StatefulWidget {
  final String images;
  final String? ratings;
  final String? ratingsOutOf;
  final String? hotelTitle;
  final String? location;
  final VoidCallback? onTap;
  final VoidCallback? onClose; // <-- new
  final String? address;
  final bool? isFavScreen;
  final String? categoryName;
  const MainHotelTile({
    super.key,
    this.isFavScreen,
    required this.images,
    this.onTap,
    this.ratings,
    this.address,
    this.categoryName,
    this.ratingsOutOf,
    this.hotelTitle,
    this.location,
    this.onClose, // <-- new
  });

  @override
  State<MainHotelTile> createState() => _MainHotelTileState();
}

class _MainHotelTileState extends State<MainHotelTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.sp),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.95),
                    Colors.white.withOpacity(0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.sp),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// Image section - compact square
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.sp),
                          child: CustomCachedImage(
                            height: 95.h,
                            width: 95.w,
                            imageUrl: widget.images,
                            borderRadius: 12.sp,
                          ),
                        ),
                      ),

                      /// Details section
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 12.h,
                            right: 40.w,
                            bottom: 12.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.hotelTitle ?? 'Unknown Place',
                                style: AppTextStyles.customText18(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.address != null) ...[
                                6.h.height,
                                Text(
                                  widget.address!,
                                  style: AppTextStyles.customText16(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                                if (widget.categoryName != null) ...[
                                  // 8.h.height,
                                  Spacer(),
                                  Text(
                                    widget.categoryName ?? 'Unknown Category',
                                    style: AppTextStyles.customText14(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// Close button - refined
                  // if (widget.isFavScreen == null)
                  //   Positioned(
                  //     top: 8.h,
                  //     right: 8.w,
                  //     child: GestureDetector(
                  //       onTap: widget.onClose,
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.black.withOpacity(0.6),
                  //           shape: BoxShape.circle,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.black.withOpacity(0.2),
                  //               blurRadius: 4,
                  //               offset: const Offset(0, 2),
                  //             ),
                  //           ],
                  //         ),
                  //         padding: EdgeInsets.all(5.sp),
                  //         child: Icon(
                  //           Icons.close_rounded,
                  //           color: Colors.white,
                  //           size: 14.sp,
                  //         ),
                  //       ),
                  //     ),
                  //   ),

                  /// Tap indicator arrow
                  Positioned(
                    right: 12.w,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.sp,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
