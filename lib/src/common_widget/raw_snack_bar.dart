import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showRawSnackBar(String title) {
  Get.rawSnackbar(
    message: title,
    duration: const Duration(seconds: 3), // Độ dài hiển thị
    isDismissible: true, // Cho phép đóng Snackbar bằng cách nhấn vào nó
    margin: const EdgeInsets.all(16.0), // Đặt khoảng cách bên trái
    borderRadius: 12, // Bỏ viền bo tròn
    animationDuration: const Duration(milliseconds: 300),
    backgroundGradient: const LinearGradient(
      colors: [Colors.blue, Colors.green], // Màu nền
      stops: [0.1, 0.9],
    ),
  );
}
