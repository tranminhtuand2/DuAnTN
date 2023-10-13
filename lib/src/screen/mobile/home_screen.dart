import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/brightness_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/drawer_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/home_page/home_page.dart';
import 'package:managerfoodandcoffee/src/shared_preferences/shared_preference.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class HomeScreen extends GetView<MyDrawerController> {
  const HomeScreen({super.key, required this.tenban});
  final String tenban;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const MenuScreen(),
        mainScreen: HomePage(tenban: tenban),
        borderRadius: 24.0,
        showShadow: true,
        angle: 0,
        drawerShadowsBackgroundColor: Colors.grey,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
      ),
    );
  }
}

class MenuScreen extends GetView<MyDrawerController> {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightnessController = Get.put(BrightnessController());
    final tableController = Get.put(TableController());
    return Scaffold(
      body: Container(
        color: colorScheme(context).background,
        child: Column(
          children: [
            buttonBack(context),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tableController.tables.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Số cột trong GridView
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.offAll(
                                () => HomeScreen(
                                  tenban:
                                      tableController.tables[index].toString(),
                                ),
                              );
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(6),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme(context)
                                      .primary
                                      .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tableController.tables[index].toString(),
                                  style: text(context).titleLarge,
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color:
                            colorScheme(context).onBackground.withOpacity(0.3)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "DARK MODE",
                              style: text(context).bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme(context).onTertiary),
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: !brightnessController.isDarkMode.value,
                              onChanged: (bool newValue) {
                                brightnessController.toggleDarkMode();
                                saveBrightnessPreference(!newValue);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell buttonBack(BuildContext context) {
    return InkWell(
      onTap: controller.closeDrawer,
      child: Container(
        margin: const EdgeInsets.only(top: 36, right: 20),
        alignment: Alignment.centerRight,
        child: CircleAvatar(
          backgroundColor: colorScheme(context).onBackground.withOpacity(0.4),
          radius: 26,
          child: const Icon(
            CupertinoIcons.back,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
