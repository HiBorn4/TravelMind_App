import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../config/app_assets.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';
import '../../mvvm/view_model/suggest_place_controller.dart';
import '../custom_loader.dart';

class CitySelectionSheet extends StatefulWidget {
  const CitySelectionSheet({super.key});

  @override
  State<CitySelectionSheet> createState() => _CitySelectionSheetState();
}

class _CitySelectionSheetState extends State<CitySelectionSheet> {
  final SuggestPlaceController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                10.h.height,
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.sp),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24.sp),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          15.h.height,
                          Text(
                            context.l10n!.select_a_city,
                            style: AppTextStyles.customText22(
                              color: AppColors.secondaryBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ).paddingHorizontal(20.w),

                          15.h.height,
                          _buildSearchField(),
                          15.h.height,

                          // 🔹 Cities List
                          Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(child: CustomLoader()).paddingVertical(30.h);
                            }

                            final cities = controller.filteredCities;
                            if (cities.isEmpty) {
                              return Center(
                                child: Text(
                                  context.l10n!.no_cities_found,
                                  style: AppTextStyles.customText16(color: Colors.black54),
                                ),
                              ).paddingVertical(25.h);
                            }

                            return ListView.separated(
                              itemCount: cities.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (_, __) => Divider(color: Colors.grey.withOpacity(0.3), height: 15.h),
                              itemBuilder: (context, index) {
                                final city = cities[index];
                                final isSelected = controller.selectedCityId.value == city.id;
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectCity(city);
                                    controller.selectedCityId.value = city.id ?? '';
                                    controller.selectedCity.value = city;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12.sp),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                                      borderRadius: BorderRadius.circular(12.sp),
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                                        width: isSelected ? 1.2 : 0.6,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40.sp,
                                          width: 40.sp,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10.sp),
                                          ),
                                          child: Center(child: SvgPicture.asset(AppAssets.webIcon, height: 22.sp)),
                                        ),
                                        15.w.width,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                city.name ?? context.l10n!.unknown_city,
                                                style: AppTextStyles.customText16(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              5.h.height,
                                              Text(
                                                city.country ?? "",
                                                style: AppTextStyles.customText14(
                                                  color: AppColors.textLightBlack.withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isSelected) SvgPicture.asset(AppAssets.selectedTickIcon, height: 18.sp),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ).paddingHorizontal(20.w);
                          }),

                          25.h.height,
                          // AppCustomButton(
                          //   title: 'Confirm',
                          //   onPressed: () async {
                          //     Get.back();
                          //     LoggerService.i("Selected Id ${controller.selectedCityId}");
                          //   },
                          // ).paddingHorizontal(35.w).paddingBottom(20.h),
                        ],
                      ).paddingFromAll(10.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: TextFormField(
        controller: controller.searchQueryController,
        decoration: InputDecoration(
          prefixIcon: Padding(padding: EdgeInsets.all(12.sp), child: SvgPicture.asset(AppAssets.searchIcon)),
          hintText: context.l10n!.search_for_places_cities,
          hintStyle: AppTextStyles.customText14(color: AppColors.textLightBlack.withOpacity(0.6)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.sp), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.sp), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
