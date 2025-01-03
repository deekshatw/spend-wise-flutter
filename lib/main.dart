import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/features/splash/splash_screen.dart';

import 'features/notification/notification_body.dart';
import 'features/notification/notification_helper.dart';
import 'firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("User granted permission for notifications.");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print("User granted provisional permission.");
  } else {
    print("User denied notification permission.");
  }
}

Future<void> updateFCMToken() async {
  FirebaseMessaging.instance.getToken().then((token) {
    fcmToken = token;
    // Get.put(NotificationController()).updateFCM(fcmToken!);
    log("FCM Token: $token");
  });
}

String? fcmToken;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationBody? body;

  try {
    // Request notification permissions
    await requestNotificationPermission();

    // Fetch the initial notification if any
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      debugPrint("Initial notification received.");
      body = NotificationHelper.convertNotification(remoteMessage.data);
    }

    // Initialize local notifications
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    // Update FCM token
    await updateFCMToken();
  } catch (e) {
    debugPrint("Error during initialization: ${e.toString()}");
  }
  runApp(
    MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: AppColors.primarySwatch, fontFamily: 'Inter'),
    ),
  );
}
