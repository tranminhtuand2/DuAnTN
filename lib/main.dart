import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managerfoodandcoffee/firebase_options.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
import 'package:managerfoodandcoffee/src/reponsive/desktop_screen.dart';
import 'package:managerfoodandcoffee/src/reponsive/mobile_screen.dart';
import 'package:managerfoodandcoffee/src/reponsive/reponsive_layout.dart';
import 'package:managerfoodandcoffee/src/reponsive/tablet_screen.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Firebase.initializeApp(
  //     options: FirebaseOptions(
  //         apiKey: "AIzaSyBM8woCtycdBxjLsha6sDdtyh03bigJzMs",
  //         authDomain: "managercoffeeandfood.firebaseapp.com",
  //         projectId: "managercoffeeandfood",
  //         storageBucket: "managercoffeeandfood.appspot.com",
  //         messagingSenderId: "204912491565",
  //         appId: "1:204912491565:web:43f0347c5bc699e331cca4"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GetMaterialApp(
      title: 'Coffee Wind',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
      theme: ThemeData(
          fontFamily: GoogleFonts.manrope().fontFamily,
          useMaterial3: true,
          colorScheme: TAppTheme.lightColorScheme,
          textTheme: TAppTextTheme.lightTextTheme),
      darkTheme: ThemeData(
          fontFamily: GoogleFonts.manrope().fontFamily,
          useMaterial3: true,
          colorScheme: TAppTheme.darkColorScheme,
          textTheme: TAppTextTheme.darkTextTheme),
      home: const ReponsiveLayout(
        moblie: MobileScreen(),
        tablet: TabletScreen(),
        desktop: DesktopScreen(),
      ),
    );
  }
}
