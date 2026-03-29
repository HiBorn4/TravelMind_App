import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../config/app_assets.dart';

class CustomLoader extends StatelessWidget {
  final double? height;
  final double? width;

  const CustomLoader({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Center(child: Lottie.asset(AppAssets.heartCountdown, height: 70.h)),
      ),
    );
    // return Center(
    //   child: Lottie.asset(AppAssets.loaderAnimation, height: height ?? 200.sp, width: width ?? 200.sp),
    // );
  }
}
