import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/utils/language_controller.dart';

import '../l10n/generated/app_localizations.dart';
import 'config/app_colors.dart';
import 'config/app_routes.dart';

class VladAi extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const VladAi({super.key, required this.analytics});

  @override
  State<VladAi> createState() => _VladAiState();
}

class _VladAiState extends State<VladAi> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Get.find<LanguageController>().selectedLocale.value,
          fallbackLocale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldBgColor,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
          ),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: widget.analytics),
          ],
          initialRoute: AppRoutes.splashView,
          getPages: AppPages.routes,
          title: "VLAD",
        );
      },
    );
  }
}
