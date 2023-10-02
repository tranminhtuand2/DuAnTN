import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class tabletScreen extends StatelessWidget {
  const tabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Lottie.asset(
            'images/cf1.json',
            fit: BoxFit.fill,
          ),
        ],
      ),
    ));
  }
}
