import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:vlad_ai/app/config/app_assets.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/app/mvvm/view_model/notification_service_controller.dart';
import '../../view_model/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final FirebaseMessagingController messagecontroller = Get.put(FirebaseMessagingController());

  @override
  void initState() {
    super.initState();
    messagecontroller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.find();
    Future.delayed(Duration(seconds: 4), () {
      controller.checkUserData(context);
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔥 Background Video
          GetBuilder<SplashController>(
            builder: (c) {
              return controller.videoController.value.isInitialized
                  ? SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.videoController.value.size.width,
                          height: controller.videoController.value.size.height,
                          child: VideoPlayer(controller.videoController),
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          ),

          // 🔥 Animated Logo on Top
          Center(
            child: Lottie.asset(AppAssets.dancingLottie, height: 70.h)
                .paddingTop(50.h)
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 1200), duration: 800.ms)
                .scale(
                  begin: const Offset(0.2, 0.2),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                  duration: 600.ms,
                  delay: const Duration(seconds: 1),
                ),
          ),
        ],
      ),
    );
  }
}
