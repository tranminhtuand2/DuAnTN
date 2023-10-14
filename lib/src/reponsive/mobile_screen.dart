import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/intropage.dart';

class mobileScreen extends StatefulWidget {
  const mobileScreen({super.key});

  @override
  State<mobileScreen> createState() => _mobileScreenState();
}

class _mobileScreenState extends State<mobileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagegioithieu(),
    );
  }
}
