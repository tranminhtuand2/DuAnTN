import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/navigate_panel_controller.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/left_panel/left_panel.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/table_page/table_page.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final navigateController = Get.put(NavigatePanelController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme(context).onPrimary,
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        offset: Offset(0, 5),
                        spreadRadius: 1,
                        blurRadius: 5),
                  ],
                ),
                child: const LeftPanel()),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: colorScheme(context).primary),
              child: Builder(builder: (context) {
                return Obx(() => listPage[navigateController.indexPage.value]);
              }),
            ),
          ),
        ],
      ),
    );
  }

  List listPage = [
    const TablePage(),
    const TablePage(),
    const TablePage(),
    const TablePage(),
    const TablePage(),
  ];
}
