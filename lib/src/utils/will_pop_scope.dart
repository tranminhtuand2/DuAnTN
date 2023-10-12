import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_dialog.dart';

Future<bool> onBackPressed(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (context) => MyDialog(
            onTapLeading: () {
              Navigator.of(context).pop(true);
            },
            onTapTrailling: () {
              Navigator.of(context).pop(false);
            },
            title: 'Thoát?',
            content: 'Ấn xác nhận để đóng ứng dụng!',
          ));
}
