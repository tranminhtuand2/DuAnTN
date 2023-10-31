// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/bottom_sheet.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/Invoice_model.dart';
import 'package:managerfoodandcoffee/src/model/TTthanhtoan.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/table_page/widgets/show_product.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

import '../../../../../../model/card_model.dart';
import '../../../../../../model/table_model.dart';

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
  List<GioHang> products = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = [];
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = colorScheme(context);
    var now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
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
                          products = [];
                          for (var giohangindex in giohang!) {
                            totalPrice +=
                                giohangindex.soluong * giohangindex.giasp;
                          }
                          for (var i = 0; i < giohang.length; i++) {
                            products.add(GioHang(
                                tensp: giohang[i].tensp,
                                giasp: giohang[i].giasp,
                                soluong: giohang[i].soluong,
                                hinhanh: giohang[i].hinhanh));
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
                                    Text(
                                      "Ghi chú: ${giohangindex.ghichu}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
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
                        onTap: () {
                          if (products.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('thông báo'),
                                  content: Text('bàn trống '),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // 2. Đóng hộp thoại khi nút được nhấn.
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('thông báo'),
                                  content:
                                      Text('thanh toán hoá đơn thành công '),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // 2. Đóng hộp thoại khi nút được nhấn.
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            print(
                                formatPrice(tableController.totalPrice.value));
                            print(formattedDate);
                            print(tableController.tableName.value);
                            // xử lý thanh toán hoá đơn
                            //thêm hoá đơn
                            FirestoreHelper.createhoadon1(
                              products,
                              formattedDate,
                              "minhtuan",
                              double.parse(
                                formatPrice(tableController.totalPrice.value),
                              ),
                            );
                            // xoá giỏ hàng
                            FirestoreHelper.deleteAllgiohang(
                                tableController.tableName.value);
                            //cập nhập lại trạng thái bàn
                            FirestoreHelper.updatetable(TableModel(
                                tenban: tableController.tableName.value,
                                isSelected: false,
                                maban: tableController.tableName.value));
                            //xoá tình trạng thanhtoan
                            FirestoreHelper.deletetinhtrang(
                                tableController.tableName.value);
                            //end
                          }
                        },
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
