import 'dart:ui';

import 'package:flutter/material.dart';

import '../config/app_colors.dart';

class BlurContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;

  const BlurContainer({super.key, this.height, this.width, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.blurContainerBg.withOpacity(0.1), // semi-transparent
              borderRadius: BorderRadius.circular(12), // optional rounding
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
