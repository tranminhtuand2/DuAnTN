import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/alert_screen.dart';

class FirebaseMessagingApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // NotificationSettings settings = await _firebaseMessaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    // print('User granted permission: ${settings.authorizationStatus}');

    //Hỏi quyền
    await _firebaseMessaging.requestPermission();

    // final token = await _firebaseMessaging.getToken();

    // log(token!);

    initPushNotifications();
  }

  void handlerMessage(RemoteMessage? message) {
    if (message == null) return;
    // log(message.notification!.title!);
    // log(message.notification!.body!);
    // log(message.data.toString());
    Get.to(() => const AlertScreen());
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handlerMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlerMessage);
  }
}
