// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/bottom_sheet.dart';

import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:managerfoodandcoffee/src/utils/size.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class SecondWidget extends StatefulWidget {
  SecondWidget(
      {Key? key, required this.isExpanded, required this.isExpandedValue})
      : super(key: key);

  final Function(bool) isExpanded;
  bool isExpandedValue;
  @override
  State<SecondWidget> createState() => _SecondWidgetState();
}

class _SecondWidgetState extends State<SecondWidget> {
  bool thanhtoan = false;
  final tableController = Get.put(TableController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme(context).onPrimary,
      appBar: AppBar(
        backgroundColor: colorScheme(context).onPrimary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "BÀN ${tableController.tableName}",
          style: text(context).titleSmall,
        ),
        leading: IconButton(
            onPressed: () {
              widget.isExpanded(!widget.isExpandedValue);
            },
            icon: Icon(
              Icons.arrow_right,
              color: colorScheme(context).onBackground,
              size: 44,
            )),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirestoreHelper.readgiohang(
                    tableController.tableName.value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("lỗi"),
                    );
                  }
                  if (snapshot.hasData) {
                    final giohang = snapshot.data;
                    return ListView.builder(
                      itemCount: giohang!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final giohangindex = giohang[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                              color:
                                  colorScheme(context).primary.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F6F9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: cacheNetWorkImage(
                                    giohangindex.hinhanh,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            giohangindex.tensp.toUpperCase(),
                                            style: text(context)
                                                .titleSmall
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              onPressed: () {
                                                dialogModalBottomsheet(
                                                    context, 'xóa', () async {
                                                  await FirestoreHelper
                                                      .deletegiohang(
                                                          giohangindex,
                                                          tableController
                                                              .tableName.value);
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              icon: const Icon(
                                                CupertinoIcons.trash_circle,
                                                color: Colors.red,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              text: formatPrice(
                                                  giohangindex.giasp),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        " x ${giohangindex.soluong}")
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "TỔNG: ${formatPrice(giohangindex.soluong * giohangindex.giasp)} VNĐ"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
              StreamBuilder(
                stream: FirestoreHelper.readtinhtrang(
                    tableController.tableName.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("lỗi"),
                    );
                  }
                  if (snapshot.hasData) {
                    final tinhtrangthanhtoan = snapshot.data;
                    for (var i = 0; i < tinhtrangthanhtoan!.length; i++) {
                      if (tinhtrangthanhtoan[i].idtinhtrang ==
                          tableController.tableName.toString()) {
                        thanhtoan = true;
                        break;
                      }
                    }
                    return Center(
                      child: thanhtoan == false
                          ? const Text(
                              "vui lòng chờ khách hàng chọn món hoàn tất")
                          : const Text("xác nhận đợn hàng"),
                    );
                  }
                  return const Center(
                    child: Row(
                      children: [
                        Text("vui long chờ khách hàng order xong  "),
                        CircularProgressIndicator()
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
