import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

import '../../../../../controller_getx/brightness_controller.dart';
import '../../../../../model/table_model.dart';
import '../../../../../utils/texttheme.dart';
import '../../../pageadmin/DieuChinh/giohang/giohang_admin.dart';

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
      body: StreamBuilder(
        stream: FirestoreHelper.readtable(),
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
            final table = snapshot.data;
            //Sắp xếp tên bàn theo thứ tự nhỏ đén lớn theo tên bàn
            int compareByTenBan(TableModel a, TableModel b) {
              return int.parse(a.tenban).compareTo(int.parse(b.tenban));
            }

            table?.sort(compareByTenBan);

            return GridView.builder(
              itemCount: table!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // Bạn có thể thay đổi số cột ở đây
                // mainAxisExtent: MediaQuery.sizeOf(context).height * 0.25
                mainAxisSpacing:
                    30.0, // Điều chỉnh khoảng cách giữa các mục theo chiều dọc
                crossAxisSpacing:
                    20.0, // Điều chỉnh khoảng cách giữa các mục theo chiều ngang
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              itemBuilder: (context, index) {
                final tableindex = table[index];
                return FittedBox(
                  child: StreamBuilder(
                    stream: FirestoreHelper.readgiohang(tableindex.tenban),
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
                        final giohangtb = snapshot.data;
                        return Center(
                          child: badges.Badge(
                              position: badges.BadgePosition.topStart(),
                              badgeAnimation:
                                  const badges.BadgeAnimation.fade(),
                              showBadge: giohangtb!.isNotEmpty,
                              badgeContent: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "${giohangtb.length}",
                                  style: text(context)
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() =>
                                      giohang_admin(tenban: tableindex.tenban));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 40),
                                  decoration: BoxDecoration(
                                    gradient: !Get.put(BrightnessController())
                                            .isDarkMode
                                            .value
                                        ? giohangtb.isNotEmpty
                                            ? LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  color.surfaceVariant
                                                      .withOpacity(0.3),
                                                  color.onSurfaceVariant
                                                      .withOpacity(0.3),
                                                ],
                                              )
                                            : null
                                        : giohangtb.isEmpty
                                            ? LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  color.surfaceVariant
                                                      .withOpacity(0.3),
                                                  color.onSurfaceVariant
                                                      .withOpacity(0.3),
                                                ],
                                              )
                                            : null,
                                    color: color.onPrimary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        giohangtb.isEmpty
                                            ? "assets/images/table1.png"
                                            : 'assets/images/order.png',
                                        height: 80,
                                        width: 80,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Bàn ${tableindex.tenban}",
                                        style: text(context).titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }
                      return SingleChildScrollView(
                        child: Text("Lỗi: ${snapshot.error.toString()}"),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
