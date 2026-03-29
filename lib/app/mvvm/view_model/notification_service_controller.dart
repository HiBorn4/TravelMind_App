import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// Top-level function for background message handling (must be outside the class)
@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
  // Perform background tasks or show local notifications
}

class FirebaseMessagingController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  RxString token = ''.obs; // Observable to store the device token

  // Guards to prevent concurrent permission requests and double initialization
  bool _isRequestingPermission = false;
  Completer<bool>? _permissionCompleter;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializeFCM();
  }

  Future<bool> requestNotificationPermissions() async {
    // If already requesting, wait for the existing request to complete
    if (_isRequestingPermission && _permissionCompleter != null) {
      return _permissionCompleter!.future;
    }

    _isRequestingPermission = true;
    _permissionCompleter = Completer<bool>();

    try {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      final granted = settings.authorizationStatus == AuthorizationStatus.authorized;
      if (kDebugMode) {
        print(granted ? 'User granted permission' : 'User declined or has not accepted permission');
      }
      _permissionCompleter!.complete(granted);
      return granted;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permission: $e');
      }
      _permissionCompleter!.complete(false);
      return false;
    } finally {
      _isRequestingPermission = false;
    }
  }

  /// Ensures FCM token is available before use (e.g., during login)
  /// Requests permission if needed and waits for token retrieval
  Future<String?> ensureTokenAvailable() async {
    // If token is already available, return it
    if (token.value.isNotEmpty) {
      if (kDebugMode) {
        log('FCM Token already available: ${token.value}');
      }
      return token.value;
    }

    // Request permission first
    await requestNotificationPermissions();

    // Try to get the token
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        log('FCM TOKEN retrieved: $fcmToken');
      }

      if (fcmToken != null && fcmToken.isNotEmpty) {
        token.value = fcmToken;
        return fcmToken;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
    }

    return token.value.isEmpty ? null : token.value;
  }

  Future<void> _initializeFCM() async {
    // Prevent double initialization
    if (_isInitialized) return;
    _isInitialized = true;

    // Register background message handler (must be done outside try-catch)
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);

    try {
      final apnsToken = await _firebaseMessaging.getAPNSToken();
      if (kDebugMode) {
        log('APNS TOKEN: $apnsToken');
      }

      final fcmToken = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        log('FCM TOKEN: $fcmToken');
      }

      if (fcmToken != null && fcmToken.isNotEmpty) {
        token.value = fcmToken;
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing FCM: $e');
      }
    }

    // Setup message listeners (outside try-catch to ensure they're always registered)
    _setupMessageListeners();
  }

  void _setupMessageListeners() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print('Message also contained a notification: ${message.notification}');
        }
      }
    });

    // Handle messages when the app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (kDebugMode) {
          print('App opened from terminated state with message: ${message.data}');
        }
      }
    });

    // Handle messages when the app is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('App opened from background with message: ${message.data}');
      }
    });
  }
}
