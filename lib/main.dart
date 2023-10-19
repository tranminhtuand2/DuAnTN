import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/firebase_options.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
import 'package:managerfoodandcoffee/src/controller_getx/brightness_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/drawer_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebase_messaging.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/reponsive/desktop_screen.dart';
import 'package:managerfoodandcoffee/src/reponsive/mobile_screen.dart';
import 'package:managerfoodandcoffee/src/reponsive/reponsive_layout.dart';
import 'package:managerfoodandcoffee/src/reponsive/tablet_screen.dart';
import 'package:managerfoodandcoffee/src/utils/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessagingApi().initNotifications();
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyBM8woCtycdBxjLsha6sDdtyh03bigJzMs",
  //         authDomain: "managercoffeeandfood.firebaseapp.com",
  //         projectId: "managercoffeeandfood",
  //         storageBucket: "managercoffeeandfood.appspot.com",
  //         messagingSenderId: "204912491565",
  //         appId: "1:204912491565:web:43f0347c5bc699e331cca4",
  //         measurementId: "G-718BNZ61C3"));

  Get.put(BrightnessController());
  Get.put(MyDrawerController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final brightnessController = Get.put(BrightnessController());

    return Obx(
      () => GetMaterialApp(
        title: 'Coffee Wind',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 400),
        theme: brightnessController.isDarkMode.value ? lightTheme : darkTheme,
        home: const ReponsiveLayout(
          moblie: MobileScreen(),
          tablet: MobileScreen(),
          desktop: DesktopScreen(),
        ),
      ),
    );
  }
}
