import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/customWidgets/sizedbox_extension.dart';
import 'package:vlad_ai/app/utils/language_controller.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../config/app_text_style.dart';
import '../app_custom_button.dart';

class LanguageSheet extends StatefulWidget {

  const LanguageSheet({
    super.key,
  });

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  final languageController = Get.find<LanguageController>();
  Locale selectedLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    selectedLocale = languageController.selectedLocale.value;
  }

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: EdgeInsets.all(10.sp),
                              // ignore: deprecated_member_use
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                              child: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
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
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(24.sp),
                        ),
                        child: Column(
                          children: [
                            10.h.height,
                            Text(
                              context.l10n!.language,
                              style: AppTextStyles.customText22(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            25.h.height,
                            languageItem(
                              text: context.l10n!.english,
                              image: "assets/images/uk_flag.png",
                              isSelected: selectedLocale.languageCode == 'en',
                              onTap: () {
                                setState(() {
                                  selectedLocale = const Locale('en');
                                });
                              }
                            ),
                            10.h.height,
                            languageItem(
                              text: context.l10n!.romanian,
                              image: "assets/images/romania_flag.png",
                              isSelected: selectedLocale.languageCode == 'ro',
                              onTap: () {
                                setState(() {
                                  selectedLocale = const Locale('ro');
                                });
                              }
                            ),
                            20.h.height,
                            AppCustomButton(
                              title: context.l10n!.select,
                              onPressed: () {
                                languageController.changeLanguage(selectedLocale);
                                Get.back(); 
                              },
                            )
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

  Widget languageItem({
    required String text, required String image, required bool isSelected, required VoidCallback onTap,
  }) {
       return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white.withAlpha(120), borderRadius: BorderRadius.circular(12.sp)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              foregroundImage: AssetImage(image),
            ),
            10.w.width,
            Expanded(
              child: Text(text, style: AppTextStyles.customText18(color: Colors.black)),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.green,)
          ],
        ),
      ),
    );
  }
}
