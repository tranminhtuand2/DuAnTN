import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/alert_screen.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/cart_user/giohang_user.dart';

class FirebaseMessagingApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    //Hỏi quyền
    await _firebaseMessaging.requestPermission();

    final token = await _firebaseMessaging.getToken();

    log(token!);

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
