// import 'dart:async';
// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:get/get.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import '../../config/app_enums.dart';
// import '../../config/app_routes.dart';
// import '../../mvvm/model/api_reponse/login_resp_model.dart';
// import '../logger_service.dart';
// import '../shared_preferences_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   static int id = 0;
//
//   AppUser? appUser;
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize(BuildContext context) async {
//     await _configureLocalTimeZone();
//     DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings();
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/notification');
//     final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: darwinInitializationSettings);
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
//         LoggerService.i("Notification tapped with payload: ${notificationResponse.payload}");
//         final payload = notificationResponse.payload;
//         if (payload != null && payload.isNotEmpty) {
//           try {
//             final data = jsonDecode(payload) as Map<String, dynamic>;
//             final message = RemoteMessage(data: data);
//             // await handleMessage(navigatorKey.currentContext!, message);
//           } catch (e) {
//             LoggerService.e("Failed to parse payload: $e");
//           }
//         } else {
//           LoggerService.w("No payload received on notification tap");
//         }
//       },
//     );
//   }
//
//   void firebaseInit(BuildContext context) {
//     Array.variable();
//
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//
//       LoggerService.i('Received notification: ${notification?.title}, ${notification?.body}, data: ${message.data}');
//
//       if (Platform.isIOS) {
//         iosForeGroundMessage();
//       }
//
//       if (Platform.isAndroid) {
//         showFcmNotifications(message);
//       }
//     });
//   }
//
//   Future<void> bgAndTrState(BuildContext context) async {
//     // For background state
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       await Future.delayed(Duration(milliseconds: 500));
//       // appUser = await SharedPreferencesService().readUserData();
//       LoggerService.i("Handling background notification with data: ${message.data}");
//       handleMessage(context, message);
//     });
//
//     // For terminated state
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
//       if (message != null && message.data.isNotEmpty) {
//         await Future.delayed(Duration(seconds: 1));
//         LoggerService.i("Handling terminated state notification with data: ${message.data}");
//         handleMessage(context, message);
//       }
//     });
//   }
//
//   Future<void> handleMessage(BuildContext context, RemoteMessage message) async {
//     appUser = await SharedPreferencesService().readUserData();
//     LoggerService.i("Handling notification tap with role: ${appUser?.role}, data: ${message.data}");
//
//     if (context == null) {
//       LoggerService.e("Context is null, cannot navigate");
//       return;
//     }
//
//     try {
//       final data = message.data;
//       final jobId = int.tryParse(data['job_id'] ?? '') ?? 0;
//
//       if (appUser?.role == 'engineer') {
//         _handleMechanicJobNotifications(context, jobId);
//       } else {
//         _handleUserJobNotification(context, jobId);
//       }
//     } catch (e, stackTrace) {
//       LoggerService.w("Error handling notification tap: $e\n$stackTrace");
//       // Get.offAllNamed(AppRoutes.userHomeView);
//     }
//   }
//
//   void _handleMechanicJobNotifications(BuildContext context, int jobId) {
//     if (appUser?.role == "engineer") {
//       LoggerService.i("Navigating to mechanic job detail: $jobId");
//       // Get.toNamed(AppRoutes.engineerJobDetailView, arguments: {'jobId': jobId.toString()});
//     } else {
//       LoggerService.w("Mechanic notification received, but current role is: ${appUser?.role}");
//       // Get.offAllNamed(AppRoutes.engineerHomeView);
//     }
//   }
//
//   void _handleUserJobNotification(BuildContext context, int jobId) {
//     if (appUser?.role == "user") {
//       LoggerService.i("Navigating to user job detail: $jobId");
//       // Get.toNamed(AppRoutes.userJobDetailView, arguments: {'jobId': jobId.toString()});
//     } else {
//       LoggerService.w("User notification received, but current role is: ${appUser?.role}");
//       // Get.offAllNamed(AppRoutes.userHomeView);
//     }
//   }
//
//   Future<void> showFcmNotifications(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       message.notification?.android?.channelId.toString() ?? "default_channel",
//       message.notification?.android?.channelId.toString() ?? "Default Channel",
//       importance: Importance.high,
//       playSound: true,
//       showBadge: true,
//     );
//
//     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
//       channel.id.toString(),
//       channel.name.toString(),
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       icon: '@drawable/notification',
//     );
//
//     NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
//
//     LoggerService.i("Showing notification with payload: ${jsonEncode(message.data)}");
//     await flutterLocalNotificationsPlugin.show(
//       id++,
//       message.notification?.title.toString(),
//       message.notification?.body.toString(),
//       notificationDetails,
//       payload: jsonEncode(message.data),
//     );
//   }
//
//   Future iosForeGroundMessage() async {
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
//   }
//
//   Future<void> _configureLocalTimeZone() async {
//     tz.initializeTimeZones();
//     final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZoneName!));
//   }
//
//   NotificationDetails notificationDetailsWithoutSound() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         "noSoundChannel",
//         'channelName',
//         channelDescription: 'Channel description',
//         importance: Importance.max,
//         playSound: false,
//         enableVibration: true,
//         sound: null,
//       ),
//     );
//   }
// }
