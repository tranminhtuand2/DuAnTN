import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/alert_screen.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/notifications/notification.dart';

class FirebaseMessagingApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    //Hỏi quyền
    if (!kIsWeb) {
      await _firebaseMessaging.requestPermission();
    }
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    // final token = await _firebaseMessaging.getToken();

    // log(token!);

    initPushNotifications();
  }

  void handlerMessage(RemoteMessage? message) {
    if (message != null) {
      // log(message.notification!.title!);
      // log(message.notification!.body!);
      // log(message.data.toString());
      Get.to(() => const AlertScreen(isPushNotificationPage: true));
    }
  }

  void handlerMessageBackround(RemoteMessage? message) {
    if (message != null) {
      //Nhận các thông báo dưới nền ở đây, khi app đang mở

      PushNotification.showNotification(
          id: 1,
          title: message.notification!.title!,
          body: message.notification!.body!);
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handlerMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlerMessage);
    FirebaseMessaging.onMessage.listen(handlerMessageBackround);
  }
}
