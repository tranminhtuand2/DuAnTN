import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managerfoodandcoffee/src/controller_getx/auth_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/navigate_panel_controller.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/left_panel/widgets/bottom_panel_left.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key});

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  int _isSelectedIndex = 0;
  final navigateController = Get.put(NavigatePanelController());
  final authController = Get.put(AuthController());
  List<MainListTile> listMainListTite = [];

  Future<void> checkRoleAndSetPermissions() async {
    final role = authController.role.value;

    switch (role) {
      case 'admin':
        listMainListTite = [
          MainListTile(
            icon: CupertinoIcons.table,
            title: 'Bàn',
            index: 0,
          ),
          MainListTile(
            icon: CupertinoIcons.flame,
            title: 'Quản lý món',
            index: 1,
          ),
          MainListTile(
            icon: CupertinoIcons.doc_chart,
            title: 'Hóa đơn',
            index: 3,
          ),
          MainListTile(
            icon: CupertinoIcons.creditcard,
            title: 'Quản lý khuyến mãi',
            index: 2,
          ),
          MainListTile(
            icon: CupertinoIcons.chart_bar,
            title: 'Thống kê',
            index: 4,
          ),
          MainListTile(
            icon: CupertinoIcons.placemark,
            title: 'Chọn vị trí',
            index: 5,
          ),
          MainListTile(
            icon: CupertinoIcons.person_2_fill,
            title: 'Quyền truy cập',
            index: 6,
          ),
        ];
        break;
      case 'user':
        listMainListTite = [
          MainListTile(
            icon: CupertinoIcons.table,
            title: 'Bàn',
            index: 0,
          ),
          MainListTile(
            icon: CupertinoIcons.flame,
            title: 'Quản lý món',
            index: 1,
          ),
          MainListTile(
            icon: CupertinoIcons.doc_chart,
            title: 'Hóa đơn',
            index: 3,
          ),
        ];
        break;
      default:
        listMainListTite = [
          MainListTile(
            icon: CupertinoIcons.table,
            title: 'Bàn',
            index: 0,
          ),
        ];
        break;
    }
  }

  @override
  void initState() {
    checkRoleAndSetPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = colorScheme(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.sizeOf(context).height * 0.1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "COFFEE WIND",
                      style: text(context).titleLarge?.copyWith(
                          fontFamily: GoogleFonts.merienda().fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Divider()
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listMainListTite.length,
            itemBuilder: (context, index) {
              return Builder(builder: (context) {
                return itemListtile(
                    index: index,
                    mainListTite: listMainListTite[index],
                    color: color);
              });
            },
          ),
        ),
        bottomPanelLeft(context)
      ],
    );
  }

  Widget itemListtile({
    required MainListTile mainListTite,
    required int index,
    required ColorScheme color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _isSelectedIndex == index ? color.primary : Colors.transparent,
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF58D9D9), Color(0xFF5747EF)],
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          hoverColor: color.primary.withOpacity(0.4),
          onTap: () {
            setState(() {
              _isSelectedIndex = index;
            });
            navigateController.navigatePage(index);
          },
          titleAlignment: ListTileTitleAlignment.center,
          contentPadding: const EdgeInsets.symmetric(vertical: 6),
          leading: Container(
            margin: const EdgeInsets.only(left: 20),
            width: 30,
            height: 30,
            child: Icon(
              mainListTite.icon,
              color: color.onBackground,
            ),
          ),
          mouseCursor: SystemMouseCursors.click,
          title: Text(
            mainListTite.title,
            style: text(context).titleSmall?.copyWith(),
          ),
        ),
      ),
    );
  }
}

class MainListTile {
  final String title;
  final IconData icon;
  final int index;
  MainListTile({
    required this.title,
    required this.icon,
    required this.index,
  });
}
