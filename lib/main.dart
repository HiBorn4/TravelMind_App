import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:vlad_ai/app/utils/language_controller.dart';
import 'app/app_widget.dart';
import 'app/mvvm/view_model/notification_service_controller.dart';
import 'firebase_options.dart';

// TODO: check maps why not accurate.
///// TODO: remove image from create new trip, city and regon, make it right aligned.
///// TODO: check the text sizes too.
///// TODO: remove disabled person.
///// TODO: can we merge the two popups.
///// TODO: remove all day and reset.
///// TODO: remove popular destinations text.
///// TODO: when press on the card open itenerary details and on cards check if the details are coming from API and similar.
// TODO: implement notifications on the fronend.
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
  // Perform background tasks or show local notifications
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put(LanguageController());

  await Firebase.initializeApp(
    name: 'ValidAi',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (FlutterErrorDetails details) {
    final errorString = details.exception.toString();

    // Handle non-fatal network/loading errors
    if (errorString.contains('Failed to load font') ||
        errorString.contains('fonts.gstatic.com') ||
        errorString.contains('Connection timed out') ||
        errorString.contains('SocketException') ||
        errorString.contains('ClientException') ||
        errorString.contains('NetworkImageLoadException') ||
        errorString.contains('HttpException') ||
        errorString.contains('Connection refused') ||
        errorString.contains('Connection reset')) {
      FirebaseCrashlytics.instance.recordError(
        details.exception,
        details.stack,
        fatal: false,
        reason: 'Network/loading error - non-fatal',
      );
      return; // Don't propagate
    }
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  // Configure Google Fonts to handle network errors gracefully
  // This prevents crashes when font download fails due to poor network
  GoogleFonts.config.allowRuntimeFetching = true;

  PlatformDispatcher.instance.onError = (error, stack) {
    final errorString = error.toString();

    // Handle non-fatal network/loading errors
    if (errorString.contains('Failed to load font') ||
        errorString.contains('fonts.gstatic.com') ||
        errorString.contains('Connection timed out') ||
        errorString.contains('SocketException') ||
        errorString.contains('ClientException') ||
        errorString.contains('NetworkImageLoadException') ||
        errorString.contains('HttpException') ||
        errorString.contains('Connection refused') ||
        errorString.contains('Connection reset')) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
      return true; // Error handled, don't propagate
    }
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Initialize FCM Controller early so token is available for login
  Get.put(FirebaseMessagingController(), permanent: true);

  runApp(
    DevicePreview(
      enabled: false, // Only enable in debug/profile mode
      builder: (context) => VladAi(analytics: analytics), // Your main app
    ),
  );
}
