import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: non_constant_identifier_names
Widget Loading() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.black.withOpacity(0.3),
    // color: Colors.transparent,
    child: Center(
        child: Lottie.asset('assets/images/ani_loading.json',
            width: 150, height: 150)),
  );
}
