import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_style.dart';
import '../../../config/global_variables.dart';
import '../../../customWidgets/custom_loader.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';
import '../../../customWidgets/sizedbox_extension.dart';
import '../../../config/padding_extensions.dart';
import '../../../services/shared_preferences_service.dart';
import '../../view_model/map_controller.dart';

class SearchOnMapView extends StatelessWidget {
  SearchOnMapView({super.key});

  final AppMapController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.scaffoldBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            50.h.height,
            _buildSearchBar(context),
            20.h.height,
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoader());
                }

                final cities = controller.filteredCities;

                if (cities.isEmpty) {
                  return Center(child: Text(context.l10n!.no_cities_found));
                }

                return ListView.separated(
                  itemCount: cities.length,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (_, __) => Divider(
                    color: Colors.grey.withOpacity(0.3),
                    height: 20.h,
                  ),
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return InkWell(
                      onTap: () async {
                        Get.dialog(CustomLoader(), barrierDismissible: false);
                        await controller.selectCity(city.id ?? "");
                        controller.selectedCity.value = city;
                        await SharedPreferencesService().saveSelectedCityModel(
                          city,
                        );

                        bool isMapDataFetched = await controller.getMapDataApi(
                          city.id,
                        );
                        Get.back();

                        if (isMapDataFetched) {
                          Get.back();
                        } else {
                          CustomSnackbar.show(
                            // iconData: Icons.warning_amber,
                            textColor: AppColors.black,
                            title: context.l10n!.error,
                            message: "",
                            backgroundColor: AppColors.white,
                            iconColor: AppColors.black,
                            borderColor: AppColors.black,
                            messageText: GlobalVariables.errorMessages,
                          );
                        }
                      },

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.sp),
                            ),
                            child: Center(
                              child: SvgPicture.asset(AppAssets.webIcon),
                            ).paddingFromAll(15.sp),
                          ),
                          15.w.width,
                          Expanded(
                            // ✅ Prevent overflow
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  city.name ?? context.l10n!.unknown_city,
                                  style: AppTextStyles.customText18(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                5.h.height,
                                Text(
                                  city.region ?? '',
                                  style: AppTextStyles.customText16(
                                    color: AppColors.textLightBlack.withOpacity(
                                      0.5,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).paddingBottom(5.h);
                  },
                );
              }),
            ),
          ],
        ).paddingHorizontal(17.w),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.sp),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: controller.searchQueryController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 5,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: SvgPicture.asset(AppAssets.searchIcon),
                ),
                hintText: context.l10n!.search_for_places_cities,
                hintStyle: AppTextStyles.customText14(
                  color: AppColors.textLightBlack.withOpacity(0.6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.sp),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.sp),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        10.w.width,
        InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(50.sp),
          child: Container(
            height: 45.sp,
            width: 45.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, color: Colors.black, size: 22.sp),
          ),
        ),
      ],
    );
  }
}
