import 'package:get/get.dart';
import 'package:vlad_ai/app/mvvm/view/account_setting_view/account_setting_view.dart';
import 'package:vlad_ai/app/mvvm/view/all_last_trips_view/all_last_trips_view.dart';
import 'package:vlad_ai/app/mvvm/view/all_popular_cities_view/all_popular_cities_view.dart';
import 'package:vlad_ai/app/mvvm/view/bottom_bar_view/bottom_bar_view.dart';
import 'package:vlad_ai/app/mvvm/view/bottom_bar_views/map_view.dart';
import 'package:vlad_ai/app/mvvm/view/category_view/category_view.dart';
import 'package:vlad_ai/app/mvvm/view/faq_view/faq_view.dart';
import 'package:vlad_ai/app/mvvm/view/forgot_password_view/forgot_password_view.dart';
import 'package:vlad_ai/app/mvvm/view/get_started_view_one/get_started_view_one.dart';
import 'package:vlad_ai/app/mvvm/view/help_center_view/help_center_view.dart';
import 'package:vlad_ai/app/mvvm/view/hotel_detail_view/hotel_detail_view.dart';
import 'package:vlad_ai/app/mvvm/view/login_selection_view/login_selection_view.dart';
import 'package:vlad_ai/app/mvvm/view/login_view/login_view.dart';
import 'package:vlad_ai/app/mvvm/view/magic_happening_view/magic_happening_view.dart';
import 'package:vlad_ai/app/mvvm/view/new_place_view/new_place_view.dart';
import 'package:vlad_ai/app/mvvm/view/notifications_view/notifications_view.dart';
import 'package:vlad_ai/app/mvvm/view/otp_code_view/otp_code_view.dart';
import 'package:vlad_ai/app/mvvm/view/plan_trip_views/plan_trip_main_view.dart';
import 'package:vlad_ai/app/mvvm/view/report_an_issue_view/report_an_issue_view.dart';
import 'package:vlad_ai/app/mvvm/view/search_on_map_view/search_on_map_view.dart';
import 'package:vlad_ai/app/mvvm/view/sign_up_view/sign_up_view.dart';
import 'package:vlad_ai/app/mvvm/view/splash_view/splash_view.dart';
import 'package:vlad_ai/app/mvvm/view/subcategory_view/subcategory_view.dart';
import 'package:vlad_ai/app/mvvm/view/suggest_place_selection_view/suggest_place_selection_view.dart';
import 'package:vlad_ai/app/mvvm/view/forgot_password_view/password_reset_otp_view.dart';
import 'package:vlad_ai/app/mvvm/view/privacy_policy_view/privacy_policy_view.dart';
import 'package:vlad_ai/app/mvvm/view/set_password_view/set_password_view.dart';
import 'package:vlad_ai/app/mvvm/view/terms_conditions_view/terms_conditions_view.dart';
import 'package:vlad_ai/app/mvvm/view/tours_view/tours_view.dart';
import 'package:vlad_ai/app/mvvm/view_model/bottom_bar_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/chat_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/cities_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/forgot_password_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/hotel_detail_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/map_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/notification_service_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/plan_trip_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/profile_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/signup_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/splash_controller.dart';
import 'package:vlad_ai/app/mvvm/view_model/suggest_place_controller.dart';

import '../mvvm/view_model/login_controller.dart';

/// Defines navigation routes for the LayerX app.
abstract class AppRoutes {
  AppRoutes._();

  static const getStartedViewOne = '/getStartedViewOne';
  static const loginSelectionView = '/loginSelectionView';
  static const loginView = '/loginView';
  static const signUpView = '/signUpView';
  static const otpCodeView = '/otpCodeView';
  static const bottomBarView = '/bottomBarView';
  static const searchOnMapView = '/searchOnMapView';
  static const splashView = '/splashView';
  static const hotelDetailView = '/hotelDetailView';
  static const planTripView = '/planTripView';
  static const magicHappeningView = '/magicHappeningView';
  static const toursView = '/toursView';
  static const notificationsView = '/notificationsView';
  static const accountSettingView = '/accountSettingView';
  static const faqView = '/faqView';
  static const helpCenterView = '/helpCenterView';
  static const reportAnIssueView = '/reportAnIssueView';
  static const forgotPassView = '/forgotPassView';
  static const allPopularCitiesView = '/allPopularCitiesView';
  static const allLastTripsView = '/allLastTripsView';
  static const newPlaceView = '/newPlaceView';
  static const categoryView = '/categoryView';
  static const mapView = '/mapView';
  static const subcategoryView = '/subcategoryView';
  static const suggestPlaceSelectionView = '/suggestPlaceSelectionView';
  static const termsConditionsView = '/termsConditionsView';
  static const privacyPolicyView = '/privacyPolicyView';
  static const passwordResetOtpView = '/passwordResetOtpView';
  static const setPasswordView = '/setPasswordView';
}

abstract class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(name: AppRoutes.getStartedViewOne, page: () => GetStartedViewOne()),
    GetPage(name: AppRoutes.loginSelectionView, page: () => LoginSelectionView()),
    GetPage(
      name: AppRoutes.loginView,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: AppRoutes.signUpView,
      page: () => SignUpView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SignUpController>(() => SignUpController());
      }),
    ),
    GetPage(
      name: AppRoutes.otpCodeView,
      page: () => OtpCodeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: AppRoutes.bottomBarView,
      page: () => BottomBarView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BottomBarController>(() => BottomBarController());
        Get.lazyPut<ProfileController>(() => ProfileController());
        Get.put<AppMapController>(AppMapController(), permanent: true); // 🔹 permanent
        Get.lazyPut<CitiesController>(() => CitiesController());
        Get.lazyPut<ChatController>(() => ChatController());
        Get.lazyPut<FirebaseMessagingController>(() => FirebaseMessagingController());
      }),
    ),
    GetPage(
      name: AppRoutes.searchOnMapView,
      page: () => SearchOnMapView(),
      binding: BindingsBuilder(() {
        // Use the permanent AppMapController already in memory
      }),
    ),
    GetPage(
      name: AppRoutes.splashView,
      page: () => SplashView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(() => SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.hotelDetailView,
      page: () => HotelDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HotelDetailController>(() => HotelDetailController());
      }),
    ),
    GetPage(
      name: AppRoutes.planTripView,
      page: () => PlanTripMainView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PlanTripController>(() => PlanTripController());
      }),
    ),
    GetPage(
      name: AppRoutes.magicHappeningView,
      page: () => MagicHappeningView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PlanTripController>(() => PlanTripController());
      }),
    ),
    GetPage(
      name: AppRoutes.toursView,
      page: () => ToursView(),
    ),
    GetPage(name: AppRoutes.notificationsView, page: () => NotificationsView()),
    GetPage(
      name: AppRoutes.accountSettingView,
      page: () => AccountSettingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProfileController>(() => ProfileController());
      }),
    ),
    GetPage(name: AppRoutes.faqView, page: () => FaqView()),
    GetPage(name: AppRoutes.helpCenterView, page: () => HelpCenterView()),
    GetPage(name: AppRoutes.reportAnIssueView, page: () => ReportIssueView()),
    GetPage(
      name: AppRoutes.forgotPassView,
      page: () => ForgotPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: AppRoutes.allPopularCitiesView,
      page: () => AllPopularCitiesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CitiesController>(() => CitiesController());
      }),
    ),
    GetPage(
      name: AppRoutes.allLastTripsView,
      page: () => AllLastTripsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CitiesController>(() => CitiesController());
      }),
    ),
    GetPage(
      name: AppRoutes.newPlaceView,
      page: () => NewPlaceView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SuggestPlaceController>(() => SuggestPlaceController());
      }),
    ),
    GetPage(
      name: AppRoutes.categoryView,
      page: () => CategoryView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SuggestPlaceController>(() => SuggestPlaceController());
      }),
    ),
    GetPage(
      name: AppRoutes.subcategoryView,
      page: () => SubcategoryView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SuggestPlaceController>(() => SuggestPlaceController());
      }),
    ),
    GetPage(
      name: AppRoutes.suggestPlaceSelectionView,
      page: () => SuggestPlaceSelectionView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SuggestPlaceController>(() => SuggestPlaceController());
      }),
    ),
    GetPage(
      name: AppRoutes.mapView,
      page: () => MapView(),
      binding: BindingsBuilder(() {
        // Use permanent AppMapController
      }),
    ),
    GetPage(name: AppRoutes.termsConditionsView, page: () => TermsConditionsView()),
    GetPage(name: AppRoutes.privacyPolicyView, page: () => PrivacyPolicyView()),
    GetPage(name: AppRoutes.passwordResetOtpView, page: () => PasswordResetOtpView()),
    GetPage(name: AppRoutes.setPasswordView, page: () => SetPasswordView()),
  ];
}
