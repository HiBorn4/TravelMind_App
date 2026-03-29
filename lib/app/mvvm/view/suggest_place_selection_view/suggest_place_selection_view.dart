import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_colors.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/global_variables.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/bottom_sheets/location_style_sheet.dart';
import 'package:vlad_ai/app/customWidgets/bottom_sheets/search_city_sheet.dart';
import 'package:vlad_ai/app/customWidgets/bottom_sheets/season_selection_sheet.dart';
import 'package:vlad_ai/app/customWidgets/custom_app_bar.dart';
import 'package:vlad_ai/app/customWidgets/custom_loader.dart';
import 'package:vlad_ai/app/customWidgets/dialogs/thankyou_dialog.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/mvvm/view_model/suggest_place_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';
import '../../../config/app_assets.dart';
import '../../../config/utils.dart';
import '../../../customWidgets/bottom_sheets/budget_sheet.dart';
import '../../../customWidgets/custom_snackbar/custom_snackbar.dart';

class SuggestPlaceSelectionView extends StatefulWidget {
  const SuggestPlaceSelectionView({super.key});

  @override
  State<SuggestPlaceSelectionView> createState() => _SuggestPlaceSelectionViewState();
}

class _SuggestPlaceSelectionViewState extends State<SuggestPlaceSelectionView> {
  final SuggestPlaceController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        title: context.l10n!.suggest_a_place,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20.sp),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // ignore: deprecated_member_use
              Color(0xffD9D9D9).withOpacity(0), // very light transparent black at top
              Color(0xffCACACA), // more opaque black toward bottom
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Utils.showBottomSheet(context: context, child: BudgetSheet());
              },
              child: Container(
                height: 45.h,
                width: 75.w,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50.sp)),
                child: Center(
                  child: Obx(() {
                    return Text(
                      controller.sliderValue.value == 0
                          ? '\$'
                          : controller.sliderValue.value == 5
                          ? '\$\$'
                          : '\$\$\$',
                      style: AppTextStyles.customText16(color: AppColors.secondaryBlack, fontWeight: FontWeight.w600),
                    );
                  }),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (controller.titleController.text == '') {
                  CustomSnackbar.show(
                    // iconData: Icons.warning_amber,
                    textColor: AppColors.black,
                    title: context.l10n!.error,
                    message: "",
                    backgroundColor: AppColors.white,
                    iconColor: AppColors.black,
                    borderColor: AppColors.black,
                    messageText: [context.l10n!.please_enter_title],
                  );
                } else if (controller.selectedSeason.isEmpty || controller.selectedSeason == ['']) {
                  CustomSnackbar.show(
                    // iconData: Icons.warning_amber,
                    textColor: AppColors.black,
                    title: context.l10n!.error,
                    message: "",
                    backgroundColor: AppColors.white,
                    iconColor: AppColors.black,
                    borderColor: AppColors.black,
                    messageText: [context.l10n!.please_select_a_season],
                  );
                } else if (controller.selectedLocationStyle.length == 1) {
                  CustomSnackbar.show(
                    iconData: Icons.warning_amber,
                    textColor: AppColors.black,
                    title: context.l10n!.error,
                    message: "",
                    backgroundColor: AppColors.white,
                    iconColor: AppColors.black,
                    borderColor: AppColors.black,
                    messageText: [context.l10n!.please_select_a_location_style],
                  );
                } else if (controller.selectedCityId.value == '') {
                  CustomSnackbar.show(
                    // iconData: Icons.warning_amber,
                    textColor: AppColors.black,
                    title: context.l10n!.error,
                    message: "",
                    backgroundColor: AppColors.white,
                    iconColor: AppColors.black,
                    borderColor: AppColors.black,
                    messageText: [context.l10n!.please_select_a_city],
                  );
                } else {
                  Get.dialog(CustomLoader(), barrierDismissible: false);
                  bool isSuggested = await controller.suggestPlaceApi();
                  Get.back();
                  if (isSuggested) {
                    // ignore: use_build_context_synchronously
                    Utils.showBlurryDialog(context: context, child: ThankyouDialog());
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
                }
              },
              child: Container(
                height: 45.h,
                width: 75.w,
                decoration: BoxDecoration(color: AppColors.secondaryBlack, borderRadius: BorderRadius.circular(50.sp)),
                child: Center(
                  child: Text(
                    context.l10n!.done,
                    style: AppTextStyles.customText16(color: AppColors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ).paddingHorizontal(20.w),
      ),
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.scaffoldBg), fit: BoxFit.cover),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildSearchBar(),
                15.h.height,
                /// ✅ FIX: Stack wrapped inside SizedBox to give finite height
                Center(
                  child: SizedBox(
                    height: 750.h,
                    width: ScreenUtil().screenWidth,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // ✅ Bottom Card (Season Selection)
                        Positioned(
                          top: 440.h,
                          left: 20.w,
                          child: Transform.rotate(
                            angle: -0.03,
                            child: GestureDetector(
                              onTap: () {
                                Utils.showBottomSheet(context: context, child: LocationStyleSheet());
                              },
                              child: Container(
                                height: 250.h,
                                width: 220.w,
                                decoration: DottedDecoration(
                                  color: AppColors.textLightBlack,
                                  borderRadius: BorderRadius.circular(20.r),
                                  shape: Shape.box,
                                  dash: [3, 3, 3, 3, 3, 3, 3],
                                ),
                                child: Container(
                                  height: 250.h,
                                  width: 220.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Obx(() {
                                    return controller.selectedLocationStyle.length > 1
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                context.l10n!.location_style_label,
                                                style: AppTextStyles.customText18(
                                                  color: AppColors.secondaryBlack,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              20.h.height,
                                              _locationItem(context.l10n!.solo, "Solo"),
                                              16.h.height,
                                              _locationItem(context.l10n!.couple, "Couple"),
                                              16.h.height,
                                              _locationItem(context.l10n!.family, "Family"),
                                              16.h.height,
                                              _locationItem(context.l10n!.friends, "Friends"),
                                            ],
                                          ).paddingLeft(25.w)
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Transform.rotate(
                                                angle: 0.05,
                                                child: Image.asset(AppAssets.suggestHeartIcon, height: 40.h),
                                              ),
                                              SizedBox(height: 10.h),
                                              Text(
                                                context.l10n!.whats_your_location_style,
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ✅ Middle Card (Map)
                        Positioned(
                          top: 220.h,
                          right: 20.w,
                          child: Transform.rotate(
                            angle: 0.04,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => CitySelectionSheet());
                              },
                              child: Obx(() {
                                return Container(
                                  height: 250.h,
                                  width: 220.w,
                                  decoration: DottedDecoration(
                                    color: AppColors.textLightBlack,
                                    borderRadius: BorderRadius.circular(20.r),
                                    shape: Shape.box,
                                    dash: [3, 3, 3, 3, 3, 3, 3],
                                  ),
                                  child: Container(
                                    height: 250.h,
                                    width: 220.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (controller.selectedCity.value != null) ...[
                                          Transform.rotate(
                                            angle: -0.03,
                                            child: Image.asset(AppAssets.suggestMapIcon, height: 40.h),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            "${context.l10n!.country}: ${controller.selectedCity.value?.country.toString() ?? ''}",
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "${context.l10n!.city}: ${controller.selectedCity.value?.name?.toString() ?? ''}",
                                            style: TextStyle(color: AppColors.textLightBlack, fontSize: 13),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 6.h),
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(horizontal: 8.w),
                                          //   child: Text(
                                          //     city.description ?? '',
                                          //     style: TextStyle(color: AppColors.black.withOpacity(0.4), fontSize: 12),
                                          //     textAlign: TextAlign.center,
                                          //     maxLines: 2,
                                          //     overflow: TextOverflow.ellipsis,
                                          //   ),
                                          // ),
                                        ] else ...[
                                          Transform.rotate(
                                            angle: -0.03,
                                            child: Image.asset(AppAssets.suggestMapIcon, height: 40.h),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            context.l10n!.where_are_you_meeting,
                                            style: TextStyle(fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                        // ✅ Top Card (Calendar + Season Selection)
                        Positioned(
                          top: 0, // 👈 Move this card to the top of the Stack
                          left: 30.w,
                          child: Transform.rotate(
                            angle: -0.05,
                            child: GestureDetector(
                              onTap: () {
                                Utils.showBottomSheet(context: context, child: SeasonSelectionSheet());
                              },
                              child: Container(
                                height: 250.h,
                                width: 220.w,
                                decoration: DottedDecoration(
                                  color: AppColors.textLightBlack,
                                  borderRadius: BorderRadius.circular(20.r),
                                  shape: Shape.box,
                                  dash: [3, 3, 3, 3, 3, 3, 3],
                                ),
                                child: Container(
                                  height: 250.h,
                                  width: 220.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Obx(() {
                                    return controller.selectedSeason.length > 1
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                context.l10n!.best_seasons,
                                                style: AppTextStyles.customText18(
                                                  color: AppColors.secondaryBlack,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              20.h.height,
                                              _seasonItem(context.l10n!.spring, "Spring"),
                                              16.h.height,
                                              _seasonItem(context.l10n!.summer, "Summer"),
                                              16.h.height,
                                              _seasonItem(context.l10n!.autumn, "Autumn"),
                                              16.h.height,
                                              _seasonItem(context.l10n!.winter, "Winter"),
                                            ],
                                          ).paddingLeft(25.w)
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Transform.rotate(
                                                angle: 0.05,
                                                child: Image.asset(AppAssets.suggestCalenderIcon, height: 40.h),
                                              ),
                                              SizedBox(height: 10.h),
                                              Text(
                                                context.l10n!.which_is_the_best_season,
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).paddingHorizontal(20.w),
          ),
        ),
      ),
    );
  }

  Widget _seasonItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() {
          return controller.selectedSeason.contains(value)
              ? SvgPicture.asset(AppAssets.selectedTickIcon)
              : Container(
                  height: 15.h,
                  width: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(2.sp),
                    border: Border.all(color: AppColors.textLightBlack, width: 2),
                  ),
                );
        }),
        10.w.width,
        GestureDetector(
          child: Text(title, style: AppTextStyles.customText18(color: Colors.black)),
        ),
      ],
    );
  }

  Widget _locationItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() {
          return controller.selectedLocationStyle.contains(value)
              ? SvgPicture.asset(AppAssets.selectedTickIcon)
              : Container(
                  height: 15.h,
                  width: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(2.sp),
                    border: Border.all(color: AppColors.textLightBlack, width: 2),
                  ),
                );
        }),
        10.w.width,
        GestureDetector(
          child: Text(title, style: AppTextStyles.customText18(color: Colors.black)),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            textInputAction: TextInputAction.go,
            controller: controller.titleController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.sp),
                child: Icon(
                  Icons.abc, // 🟢 Flutter Material icon for title input
                  // ignore: deprecated_member_use
                  color: AppColors.textLightBlack.withOpacity(0.7),
                  size: 22.sp,
                ),
              ),
              hintText: context.l10n!.enter_title,
              // ignore: deprecated_member_use
              hintStyle: AppTextStyles.customText14(color: AppColors.textLightBlack.withOpacity(0.6)),
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
      ],
    );
  }
}
