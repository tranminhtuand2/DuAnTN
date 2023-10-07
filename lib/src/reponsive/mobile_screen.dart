import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/intro_page.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: IntroScreen(),
    );
  }
}
