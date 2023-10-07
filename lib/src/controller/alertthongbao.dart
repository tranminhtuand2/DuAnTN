import 'package:flutter/material.dart';
import 'package:get/get.dart';

class getAlert extends GetxController {
  void showAlertDialog(String message, String noidung) {
    Get.defaultDialog(
      title: message,
      content: Text(noidung),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Đóng"),
        ),
      ],
    );
  }
}
