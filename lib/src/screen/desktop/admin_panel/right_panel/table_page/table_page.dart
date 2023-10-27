import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/table_page/widgets/first_widget.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/table_page/widgets/second_widget.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  bool isExpanded = false;
  bool thanhtoan = false;
  final tableController = Get.put(TableController());

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    ColorScheme color = colorScheme(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          return Obx(
            () => Row(
              children: [
                AnimatedContainer(
                  width: !tableController.isExpanded.value
                      ? constraints.maxWidth
                      : constraints.maxWidth / 1.5,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.fastOutSlowIn,

                  child: WillPopScope(
                      onWillPop: () async => true,
                      child: const FirstWidget()), //,
                ),
                AnimatedContainer(
                  width: !tableController.isExpanded.value
                      ? 0
                      : constraints.maxWidth - constraints.maxWidth / 1.5,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.fastOutSlowIn,
                  child: const SecondWidget(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
