import 'package:get/get.dart';
import 'package:vlad_ai/app/mvvm/view_model/map_controller.dart';

import '../../config/app_routes.dart';

class BottomBarController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeView(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      var mapController = Get.find<AppMapController>();
      if (index == 1 && mapController.selectedCity.value == null) {
        Get.toNamed(AppRoutes.searchOnMapView);
      }
    }
  }
}
