import 'package:flutter/material.dart';

Future<bool> onBackPressed(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Đóng ứng dụng?'),
      content: const Text('Hãy chọn có để đóng ứng dụng?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Không'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Có'),
        ),
      ],
    ),
  );
}
