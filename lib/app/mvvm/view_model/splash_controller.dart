import 'dart:developer';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../config/app_routes.dart';
import '../../services/logger_service.dart';
import '../../services/shared_preferences_service.dart';
import '../model/api_response/login_resp_model.dart';

class SplashController extends GetxController {
  late VideoPlayerController videoController;
  var isLoading = true.obs;
  AppUser? userData;

  Future<void> checkUserData(context) async {
    try {
      isLoading.value = true;
      userData = await SharedPreferencesService().readUserData();
      if (userData == null) {
        Get.offAllNamed(AppRoutes.getStartedViewOne);
      } else {
        log(userData?.toJson().toString() ?? 'No user data found');
        LoggerService.i('User email: ${userData!.email}');
        Get.offNamed(AppRoutes.bottomBarView);
      }
    } catch (e, stackTrace) {
      LoggerService.e('Error during user data check: $e, Stack $stackTrace');
      Get.offAllNamed(AppRoutes.getStartedViewOne);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    videoController = VideoPlayerController.asset("assets/images/splash-vid.mp4")
      ..initialize().then((_) {
        videoController.play();
        update();
      });
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
