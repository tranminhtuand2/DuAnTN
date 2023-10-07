import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Type { error, warning, success }

void showCustomSnackBar(
    {required String title, required String message, required Type type}) {
  Get.showSnackbar(
    GetSnackBar(
      title: title,
      titleText: Text(
        title,
        style: TextStyle(
            color: type == Type.error
                ? Colors.white
                : type == Type.warning
                    ? Colors.black
                    : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      messageText: Text(
        message,
        style: TextStyle(
            color: type == Type.error
                ? Colors.white
                : type == Type.warning
                    ? Colors.black
                    : Colors.black,
            fontSize: 20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      // showProgressIndicator: true,
      borderRadius: 8,
      duration: const Duration(milliseconds: 1500),
      snackPosition: SnackPosition.TOP,
      backgroundColor: type == Type.error
          ? Colors.redAccent
          : type == Type.warning
              ? Colors.orange
              : Colors.green,
    ),
  );
}
