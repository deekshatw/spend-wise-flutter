import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:spend_wise/core/utils/utils.dart';
import 'package:spend_wise/features/notification/notification_body.dart';

class NotificationHelper {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('ic_notification');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    var initializationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      String? payload = notificationResponse.payload;
      print("Payload: $payload");

      try {
        if (payload != null && payload.isNotEmpty) {
          NotificationBody notificationBody =
              NotificationBody.fromJson(jsonDecode(payload));
          print("Type: ${notificationBody.type}");

          // Uncomment and update navigation logic as needed
          // switch (notificationBody.type) {
          //   case 'general':
          //     Get.toNamed(RouteHelper.getNotificationRoute());
          //     break;
          //   case 'booking':
          //     if (notificationBody.bookingId != null && notificationBody.bookingId!.isNotEmpty) {
          //       Get.toNamed(RouteHelper.getBookingDetailsScreen(
          //         notificationBody.bookingId.toString(),
          //         'fromNotification'
          //       ));
          //     }
          //     break;
          //   case 'privacy_policy':
          //     Get.toNamed(RouteHelper.getHtmlRoute("privacy-policy"));
          //     break;
          //   case 'terms_and_conditions':
          //     Get.toNamed(RouteHelper.getHtmlRoute("terms-and-condition"));
          //     break;
          //   default:
          //     Get.toNamed(RouteHelper.getNotificationRoute());
          // }
        }
      } catch (e) {
        print("Error processing notification payload: $e");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          "onMessage: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin, false);

      // if (await Get.find<AuthController>().isLoggedIn()) {
      //   NotificationHelper.showNotification(
      //       message, flutterLocalNotificationsPlugin, false);
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      print("callOnMessageOpenApp");

      try {
        if (message != null && message.data.isNotEmpty) {
          NotificationBody _notificationBody =
              convertNotification(message.data);

          // if (_notificationBody.type == 'general') {
          //   Get.toNamed(RouteHelper.getNotificationRoute());
          // } else if (_notificationBody.type == 'booking' &&
          //     message.data['booking_id'] != null &&
          //     message.data['booking_id'] != "") {
          //   Get.toNamed(RouteHelper.getBookingDetailsRoute(
          //       message.data['booking_id'], '', 'fromNotification'));
          // } else if (_notificationBody.type == 'privacy_policy') {
          //   Get.toNamed(RouteHelper.getHtmlRoute(page: "privacy-policy"));
          // } else if (_notificationBody.type == 'terms_and_conditions') {
          //   Get.toNamed(RouteHelper.getHtmlRoute(page: "terms-and-condition"));
          // } else {
          //   Get.toNamed(RouteHelper.getNotificationRoute());
          // }

          // if(_notificationBody.type=='general'){
          //   Get.toNamed(RouteHelper.getNotificationRoute());
          // }else if(_notificationBody.type=='booking'
          //     && message.data['booking_id']!=null&& message.data['booking_id']!=""){
          //   Get.toNamed(RouteHelper.getBookingDetailsScreen(message.data['booking_id'],'fromNotification'));
          // } else if(_notificationBody.type=='privacy_policy'){
          //   Get.toNamed(RouteHelper.getHtmlRoute("privacy-policy"));
          // }else if(_notificationBody.type=='terms_and_conditions'){
          //   Get.toNamed(RouteHelper.getHtmlRoute("terms-and-condition"));
          // }else{
          //   Get.toNamed(RouteHelper.getNotificationRoute());
          // }
        }
      } catch (e) {}
    });
  }

  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool data) async {
    if (!Platform.isIOS) {
      String? _title;
      String? _body;
      // String? _orderID;
      String? _image;
      String playLoad = jsonEncode(message.data);

      if (data) {
        _title = message.data['title']?.replaceAll('_', ' ').toString();
        _body = message.data['body'].replaceAll('_', ' ').toString();
        // _orderID = message.data['booking_id'].toString();
        _image = (message.data['image'] != null &&
                message.data['image'].isNotEmpty)
            ? message.data['image'].startsWith('http')
                ? message.data['image']
                : '${Utils.BASE_URL}/storage/app/public/notification/${message.data['image']}'
            : null;
      } else {
        _title = message.notification!.title?.replaceAll('_', ' ').toString();
        _body = message.notification!.body;
        // _orderID = message.notification!.titleLocKey;
        if (Platform.isAndroid) {
          _image = (message.notification!.android!.imageUrl != null &&
                  message.notification!.android!.imageUrl!.isNotEmpty)
              ? message.notification!.android!.imageUrl!.startsWith('http')
                  ? message.notification!.android!.imageUrl
                  : '${Utils.BASE_URL}/storage/app/public/notification/${message.notification!.android!.imageUrl}'
              : null;
        } else if (Platform.isIOS) {
          _image = (message.notification!.apple!.imageUrl != null &&
                  message.notification!.apple!.imageUrl!.isNotEmpty)
              ? message.notification!.apple!.imageUrl!.startsWith('http')
                  ? message.notification!.apple!.imageUrl
                  : '${Utils.BASE_URL}/storage/app/public/notification/${message.notification!.apple!.imageUrl}'
              : null;
        }
      }

      if (_image != null && _image.isNotEmpty) {
        try {
          await showBigPictureNotificationHiddenLargeIcon(
              _title!, _body!, playLoad, _image, fln);
        } catch (e) {
          await showBigTextNotification(_title!, '', playLoad, fln);
        }
      } else {
        await showBigTextNotification(_title!, '', playLoad, fln);
      }
    }
  }

  static Future<void> showTextNotification(String title, String body,
      String orderID, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'demandium',
      'demandium',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigTextNotification(String title, String body,
      String payload, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );
    bool isNotificationActive = true;
    if (!isNotificationActive) {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "demandiumWithoutsound",
        "demandium without sound",
        channelDescription: "description",
        playSound: false,
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.max,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(0, title, body, platformChannelSpecifics,
          payload: payload);
    } else {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "demandiumWithsound",
        'demandium with sound',
        channelDescription: "description",
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.max,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(1, title, body, platformChannelSpecifics,
          payload: payload);
    }
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      String title,
      String body,
      String payload,
      String image,
      FlutterLocalNotificationsPlugin fln) async {
    bool isNotificationActive = true;

    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath =
        await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true,
    );
    if (!isNotificationActive) {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "demandiumWithoutsound",
        "demandium without sound",
        channelDescription: "description",
        playSound: false,
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        priority: Priority.max,
        styleInformation: bigPictureStyleInformation,
        importance: Importance.max,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(0, title, body, platformChannelSpecifics,
          payload: payload);
    } else {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "demandiumWithsound",
        'demandium with sound',
        channelDescription: "description",
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        priority: Priority.max,
        styleInformation: bigPictureStyleInformation,
        importance: Importance.max,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(1, title, body, platformChannelSpecifics,
          payload: payload);
    }
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBody convertNotification(Map<String, dynamic> data) {
    return NotificationBody.fromJson(data);
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(
        "onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
  }
}
