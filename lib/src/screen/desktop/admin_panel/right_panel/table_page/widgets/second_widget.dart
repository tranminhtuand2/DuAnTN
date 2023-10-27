// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/bottom_sheet.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/table_page/widgets/show_product.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class SecondWidget extends StatefulWidget {
  const SecondWidget({
    Key? key,
  }) : super(key: key);

  // final Function(bool) isExpanded;
  // bool isExpandedValue;
  @override
  State<SecondWidget> createState() => _SecondWidgetState();
}

class _SecondWidgetState extends State<SecondWidget> {
  bool thanhtoan = false;
  final tableController = Get.put(TableController());

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    ColorScheme color = colorScheme(context);
    return Obx(
      () => Scaffold(
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
                tableController.isExpanded.value = false;
              },
              icon: Icon(
                Icons.arrow_right,
                color: colorScheme(context).onBackground,
                size: 44,
              )),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FirestoreHelper.readgiohang(
                          tableController.tableName.value),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          //Tính tổng số tiền sử dụng getX
                          int totalPrice = 0;
                          for (var giohangindex in giohang!) {
                            totalPrice +=
                                giohangindex.soluong * giohangindex.giasp;
                          }
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            tableController.updateTotalPrice(totalPrice);
                          });
                          return ListView.builder(
                            itemCount: giohang.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final giohangindex = giohang[index];

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: colorScheme(context)
                                        .primary
                                        .withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    // Expanded(
                                    //                 child: cacheNetWorkImage(
                                    //                   giohangindex.hinhanh,
                                    //                   width: 60,
                                    //                   height: 60,
                                    //                 ),
                                    //               ),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  decoration: BoxDecoration(
                      color:
                          colorScheme(context).onBackground.withOpacity(0.1)),
                  child: Obx(
                    () => Text(
                      'TỔNG: ${formatPrice(tableController.totalPrice.value)} VNĐ',
                      overflow: TextOverflow.ellipsis,
                      style: text(context).titleMedium,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        onTap: () {
                          Get.dialog(
                            ShowProduct(
                              tableName: tableController.tableName.value,
                            ),
                          );
                        },
                        backgroundColor: Colors.green,
                        height: 46,
                        text: Text(
                          'Thêm món',
                          style:
                              TextStyle(color: colorScheme(context).tertiary),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: MyButton(
                          onTap: () {},
                          backgroundColor: colorScheme(context).inversePrimary,
                          height: 46,
                          text: Text(
                            'Tùy chọn',
                            style:
                                TextStyle(color: colorScheme(context).tertiary),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MyButton(
                        onTap: () {},
                        backgroundColor: Colors.blue,
                        height: 46,
                        text: Text(
                          'Thanh toán',
                          style:
                              TextStyle(color: colorScheme(context).tertiary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
