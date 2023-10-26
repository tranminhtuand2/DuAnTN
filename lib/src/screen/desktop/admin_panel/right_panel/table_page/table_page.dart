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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          StreamBuilder(
            stream: FirestoreHelper.readtinhtrangtt(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return SingleChildScrollView(
                  child: Text("Lỗi: ${snapshot.error.toString()}"),
                );
              }
              if (snapshot.hasData) {
                final tinhtrangtt = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: badges.Badge(
                    position: badges.BadgePosition.topStart(),
                    badgeAnimation: const badges.BadgeAnimation.fade(),
                    //lấy dự liệu order
                    badgeContent: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "${tinhtrangtt!.length}",
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications,
                        size: 32,
                        color: color.onBackground,
                      ),
                    ),
                  ),
                );
              }
              return const Icon(Icons.notifications);
            },
          )
        ],
      ),
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
