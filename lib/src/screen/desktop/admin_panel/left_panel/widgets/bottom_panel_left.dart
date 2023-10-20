import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/brightness_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/google_signin_controller.dart';

import 'package:managerfoodandcoffee/src/shared_preferences/shared_preference.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

Widget bottomPanelLeft(BuildContext context) {
  final brightnessController = Get.put(BrightnessController());

  return Container(
    padding: const EdgeInsets.only(bottom: 8),
    decoration:
        BoxDecoration(color: colorScheme(context).primary.withOpacity(0.2)),
    child: Column(
      children: [
        Material(
          type: MaterialType.transparency,
          child: ListTile(
            hoverColor: colorScheme(context).primary.withOpacity(0.4),
            onTap: () => Get.put(GoogleSignInController()).logoutGoogle(),
            titleAlignment: ListTileTitleAlignment.center,
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            leading: Container(
              margin: const EdgeInsets.only(left: 20),
              width: 30,
              height: 30,
              child: Icon(
                Icons.logout,
                color: colorScheme(context).onBackground,
              ),
            ),
            mouseCursor: SystemMouseCursors.click,
            title: Text(
              'Đăng xuất',
              style: text(context).titleSmall?.copyWith(),
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Nền tối",
                  style: text(context).titleSmall,
                ),
              ),
              Expanded(
                child: Switch(
                  value: !brightnessController.isDarkMode.value,
                  onChanged: (bool newValue) {
                    brightnessController.toggleDarkMode();
                    saveBrightnessPreference(!newValue);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
