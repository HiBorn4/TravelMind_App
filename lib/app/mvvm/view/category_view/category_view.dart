import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/blur_container.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/suggest_place_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final SuggestPlaceController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(AppAssets.newPlaceAllIcons, height: 70.h),
              30.h.height,
              BlurContainer(
                width: double.infinity,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.l10n!.category,
                        style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    15.h.height,
                    Obx(() {
                      return _buildCategorySelectionWidget(
                        title: context.l10n!.restaurant,
                        value: "Restaurant",
                        selectedText: "🍝",
                        selectedValue: controller.selectedCategory.value,
                        onTap: () {
                          controller.selectedCategory.value = "Restaurant";
                          controller.selectedSubcategoriesIds.clear();
                        },
                      );
                    }),
                    10.h.height,
                    Obx(() {
                      return _buildCategorySelectionWidget(
                        title: context.l10n!.accommodation,
                        value: "Accommodation",
                        selectedText: "🛏️",
                        selectedValue: controller.selectedCategory.value,
                        onTap: () {
                          controller.selectedCategory.value = "Accommodation";
                          controller.selectedSubcategoriesIds.clear();
                        },
                      );
                    }),
                    10.h.height,
                    Obx(() {
                      return _buildCategorySelectionWidget(
                        title: context.l10n!.touristic_attraction,
                        value: "Touristic Attraction",
                        selectedText: "🗺️",
                        selectedValue: controller.selectedCategory.value,
                        onTap: () {
                          controller.selectedCategory.value = "Touristic Attraction";
                          controller.selectedSubcategoriesIds.clear();
                        },
                      );
                    }),
                    20.h.height,
                    GestureDetector(
                      onTap: () {
                        if (controller.selectedCategory.value.isNotEmpty) {
                          Get.toNamed(AppRoutes.subcategoryView);
                        }else{
                          CustomSnackbar.show(
                            // iconData: Icons.warning_amber,
                            textColor: AppColors.black,
                            title: context.l10n!.error,
                            message: "",
                            backgroundColor: AppColors.white,
                            iconColor: AppColors.black,
                            borderColor: AppColors.black,
                            messageText: [context.l10n!.please_select_category],
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(50.sp)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.l10n!.next,
                              style: AppTextStyles.customText18(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            7.w.width,
                            SvgPicture.asset(AppAssets.sendIcon, color: Colors.white),
                          ],
                        ).paddingVertical(15.h),
                      ).paddingHorizontal(20.w),
                    ),
                  ],
                ).paddingFromAll(12.sp),
              ),
            ],
          ).paddingHorizontal(20.w).paddingBottom(15.h),
        ),
      ),
    );
  }

  Widget _buildCategorySelectionWidget({required String title, required String value, required String selectedText, required String selectedValue, required VoidCallback onTap}) {
    bool isSelected = selectedValue == value;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.sp)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isSelected
                ? Text(selectedText, style: AppTextStyles.customText24())
                : Container(
                    height: 15.h,
                    width: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(2.sp),
                      border: Border.all(color: AppColors.textLightBlack, width: 2),
                    ),
                  ),
            9.w.width,
            Text(
              title,
              style: AppTextStyles.customText16(color: AppColors.textLightBlack, fontWeight: FontWeight.w500),
            ),
          ],
        ).paddingHorizontal(15.w),
      ),
    );
  }
}
