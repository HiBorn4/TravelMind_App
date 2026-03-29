import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vlad_ai/app/config/app_assets.dart';

import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/custom_cache_image/custom_cached_image.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/model/body_model/notifications_model.dart';

import '../config/app_colors.dart';
import '../config/app_text_style.dart';

class NotificationTile extends StatelessWidget {
  final Notification notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final hasImage = notification.itinerary?.image?.isNotEmpty == true;
    final cityName = notification.itinerary?.city?.name ?? 'Notification';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (notification.type) == 'trip_starting_soon' || !hasImage
                ? SvgPicture.asset(AppAssets.loveLogo, height: 50.sp, width: 50.sp)
                : CustomCachedImage(
                    height: 50.sp,
                    width: 50.sp,
                    imageUrl: notification.itinerary!.image!.first,
                    borderRadius: 14.sp,
                  ),
            15.w.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cityName,
                    style: AppTextStyles.customText16(fontWeight: FontWeight.w600, color: AppColors.black),
                  ),
                  3.h.height,
                  Text(
                    notification.message,
                    style: AppTextStyles.customText14(fontWeight: FontWeight.w400, color: AppColors.textLightBlack),
                  ),
                ],
              ),
            ),
            Text(
              DateFormat.Hm().format(DateTime.parse(notification.createdAt)),
              // ignore: deprecated_member_use
              style: AppTextStyles.customText12(color: AppColors.textLightBlack.withOpacity(0.6)),
            ),
          ],
        ),
        10.h.height,
        // ignore: deprecated_member_use
        Divider(color: AppColors.textLightBlack.withOpacity(0.2)),
      ],
    ).paddingBottom(10.h);
  }
}
