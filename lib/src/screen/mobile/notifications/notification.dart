import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/alert_screen.dart';

class PushNotification {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel_id', 'channel_name',
          channelDescription: 'description',
          priority: Priority.max,
          playSound: true,
          importance: Importance.max),
    );
  }

  static Future<void> intialize() async {
    //Hỏi quyền thông báo của ngươi dùng
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidInitializationSettings);
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: onSelectNotification,
      onDidReceiveBackgroundNotificationResponse: onSelectNotification,
    );
  }

//Xử lý khi ấn vào thông báo
  static onSelectNotification(NotificationResponse notificationResponse) async {
    var payloadData = jsonDecode(notificationResponse.payload!);
    print("payload $payloadData");
    print(notificationResponse.input);
    Get.to(() => const AlertScreen(isPushNotificationPage: true));
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    // String? payload,
  }) async {
    try {
      final notificationDetails = await _notificationDetails();
      _notifications.show(
        id,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      print('Error when showing notification: $e');
    }
  }
}
