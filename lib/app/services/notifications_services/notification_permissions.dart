// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class NotificationPermissions {
//   final FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   // Add platform check and debug information
//   Future<void> requestNotificationPermission(BuildContext context) async {
//     try {
//       print('Starting notification permission request');
//
//       final NotificationSettings currentSettings = await messaging.getNotificationSettings();
//       print('Current auth status: ${currentSettings.authorizationStatus}');
//
//       if (Platform.isIOS) {
//         // iOS specific handling
//         await _handleIOSPermissions(currentSettings, context);
//       } else if (Platform.isAndroid) {
//         // Android specific handling
//         await _handleAndroidPermissions(currentSettings, context);
//       }
//
//       // Always check token availability regardless of permission flow
//       // final token = await getDeviceToken();
//       // print('FCM Token available: ${token != null}');
//     } catch (e) {
//       print('Error requesting notifications permission: $e');
//     }
//   }
//
//   Future<void> _handleIOSPermissions(NotificationSettings currentSettings, BuildContext context) async {
//     if (currentSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
//       print('iOS: First time asking permission');
//
//       // On iOS, we use the Firebase API
//       final NotificationSettings newSettings = await messaging.requestPermission(
//         alert: true,
//         announcement: true,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//
//       _logPermissionResult(newSettings.authorizationStatus);
//
//       if (newSettings.authorizationStatus == AuthorizationStatus.denied) {
//         _showPermissionDialog(context);
//       }
//     } else if (currentSettings.authorizationStatus == AuthorizationStatus.denied) {
//       print('iOS: Permission previously denied');
//       _showPermissionDialog(context);
//     } else {
//       print('iOS: Permission already granted');
//     }
//   }
//
//   Future<void> _handleAndroidPermissions(NotificationSettings currentSettings, BuildContext context) async {
//     // For Android 13+ (API 33+), we need both notification permission via permission_handler
//     // AND Firebase permission
//
//     if (await Permission.notification.status.isDenied) {
//       print('Android: Requesting notification permission via permission_handler');
//       final status = await Permission.notification.request();
//       print('Android notification permission status: $status');
//
//       if (status.isDenied || status.isPermanentlyDenied) {
//         _showPermissionDialog(context);
//       }
//     }
//
//     // Always request Firebase permission as well
//     if (currentSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
//       print('Android: Requesting FCM permission');
//       final NotificationSettings newSettings = await messaging.requestPermission();
//       _logPermissionResult(newSettings.authorizationStatus);
//     }
//
//     // Handle exact alarm separately (if needed)
//     await _handleExactAlarmPermission();
//   }
//
//   Future<void> _handleExactAlarmPermission() async {
//     if (Platform.isAndroid) {
//       final PermissionStatus alarmPermission = await Permission.scheduleExactAlarm.request();
//
//       if (alarmPermission.isGranted) {
//         print('Exact Alarm Permission Granted');
//       } else {
//         print('Exact Alarm Permission Status: $alarmPermission');
//       }
//     }
//   }
//
//   void _logPermissionResult(AuthorizationStatus status) {
//     if (status == AuthorizationStatus.authorized) {
//       print('Notification Permission Granted');
//     } else if (status == AuthorizationStatus.provisional) {
//       print('Provisional Permission Granted');
//     } else if (status == AuthorizationStatus.denied) {
//       print('Notification Permission Denied');
//     } else {
//       print('Notification Permission Status: $status');
//     }
//   }
//
//   void _showPermissionDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Notifications Disabled'),
//           content: Text('To receive important updates, please enable notifications for this app in your device settings.'),
//           actions: [
//             TextButton(
//               child: Text('Not Now'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Open Settings'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 openAppSettings();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Future<String?> getDeviceToken() async {
//   //   try {
//   //     final NotificationSettings currentSettings = await messaging.getNotificationSettings();
//   //     print('Getting token, current auth status: ${currentSettings.authorizationStatus}');
//   //
//   //     if (currentSettings.authorizationStatus == AuthorizationStatus.authorized ||
//   //         currentSettings.authorizationStatus == AuthorizationStatus.provisional) {
//   //       // Good to get token
//   //       String? token = await messaging.getToken();
//   //       return token;
//   //     } else {
//   //       print('Notifications not allowed, cannot fetch token.');
//   //       return null;
//   //     }
//   //   } catch (e) {
//   //     print('Error getting FCM token: $e');
//   //     return null;
//   //   }
//   // }
//
//   Future<String?> getDeviceToken() async {
//     try {
//       final NotificationSettings currentSettings = await messaging.getNotificationSettings();
//       print('Getting fresh token, current auth status: ${currentSettings.authorizationStatus}');
//
//       if (currentSettings.authorizationStatus == AuthorizationStatus.authorized || currentSettings.authorizationStatus == AuthorizationStatus.provisional) {
//         // 🔥 Step 1: Delete existing token (forces Firebase to generate a new one)
//         await messaging.deleteToken();
//
//         // 🔥 Step 2: Get the fresh new token
//         String? newToken = await messaging.getToken();
//
//         print('New FCM Token: $newToken');
//         return newToken;
//       } else {
//         print('Notifications not allowed, cannot fetch token.');
//         return null;
//       }
//     } catch (e) {
//       print('Error getting fresh FCM token: $e');
//       return null;
//     }
//   }
// }
