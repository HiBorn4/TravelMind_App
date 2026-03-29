import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_routes.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/blur_container.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/suggest_place_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';

class SubcategoryView extends StatefulWidget {
  const SubcategoryView({super.key});

  @override
  State<SubcategoryView> createState() => _SubcategoryViewState();
}

class _SubcategoryViewState extends State<SubcategoryView> {
  final SuggestPlaceController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.getSubCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: Obx(() {
          if (controller.isCategoriesLoading.value) {
            return const Center(child: CustomLoader());
          }

          final subCategories = controller.subCategoriesList.value ?? [];

          // 🔹 Show message if empty
          if (subCategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n!.no_categories_available,
                    style: AppTextStyles.customText20(color: AppColors.textLightBlack, fontWeight: FontWeight.w600),
                  ),
                  15.h.height,
                  GestureDetector(
                    onTap: () {
                      controller.getSubCategories();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(50.sp),
                      ),
                      child: Text(
                        context.l10n!.retry,
                        style: AppTextStyles.customText16(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(AppAssets.newPlaceAllIcons, height: 70.h),
                30.h.height,
                BlurContainer(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n!.subcategory,
                        style: AppTextStyles.customText24(color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      15.h.height,

                      // 🔹 Subcategories List
                      Column(
                        children: subCategories.map((subCat) {
                          final isSelected = controller.selectedSubcategoriesIds.contains(subCat.id);
                          return GestureDetector(
                            onTap: () {
                              if (controller.selectedCategory.value == "Restaurant") {
                                controller.toggleSelection(subCat.id ?? '');
                              } else {
                                controller.selectedSubcategoriesIds.clear();
                                controller.toggleSelection(subCat.id ?? '');
                              }
                              print('This the List :: ${controller.selectedSubcategoriesIds}');
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10.h),
                              height: 40.h,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.sp)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  isSelected
                                      ? SvgPicture.asset(AppAssets.selectedTickIcon)
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
                                    subCat.name ?? "",
                                    style: AppTextStyles.customText16(color: AppColors.textLightBlack, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ).paddingHorizontal(15.w),
                            ),
                          );
                        }).toList(),
                      ),

                      20.h.height,

                      // 🔹 Next Button
                      GestureDetector(
                        onTap: () {
                          if (controller.selectedSubcategoriesIds.isEmpty) {
                            CustomSnackbar.show(
                              // iconData: Icons.warning_amber,
                              textColor: AppColors.black,
                              title: context.l10n!.error,
                              message: "",
                              backgroundColor: AppColors.white,
                              iconColor: AppColors.black,
                              borderColor: AppColors.black,
                              messageText: [context.l10n!.please_select_subcategory],
                            );
                          } else {
                            Get.toNamed(AppRoutes.suggestPlaceSelectionView);
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
          );
        }),
      ),
    );
  }
}
