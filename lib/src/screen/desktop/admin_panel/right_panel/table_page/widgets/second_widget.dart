// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/bottom_sheet.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_dialog.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/controller_getx/auth_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/coupons_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/coupons_model.dart';
import 'package:managerfoodandcoffee/src/model/invoice_model.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/hoa_don/PDF/pdf_view.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/hoa_don/PDF/print_pdf.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/table_page/widgets/show_product.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/format_date.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../../model/card_model.dart';
import '../../../../../../model/giohanghd.dart';
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
  final authController = Get.put(AuthController());
  final couponsController = Get.put(CouponsController());
  final controllerData = TextEditingController();
  List<GioHang1> products = [];
  late final Uint8List filePDF;

  @override
  Widget build(BuildContext context) {
    ColorScheme color = colorScheme(context);
    var now = DateTime.now();
    String formattedDate =
        "${now.day}-${now.month}-${now.year} / ${now.hour}:${now.minute}:${now.second}";

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

                            products.add(
                              GioHang1(
                                  tensp: giohangindex.tensp,
                                  giasp: giohangindex.giasp,
                                  soluong: giohangindex.soluong,
                                  hinhanh: giohangindex.hinhanh),
                            );
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        "Ghi chú: ${giohangindex.ghichu}",
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InputField(
                          controller: controllerData,
                          inputType: TextInputType.text,
                          labelText: 'Mã giảm giá',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          prefixIcon: Icon(
                            Icons.code_rounded,
                            color: colorScheme(context).onBackground,
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Vui lòng nhập mã";
                          //   }
                          //   return null;
                          // },
                          textInputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp(r'[\[\]!@#\$%^&*(){}/:";|_=+]')),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'TỔNG: ${formatPrice(tableController.totalPrice.value)} VNĐ',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: text(context).titleMedium,
                        ),
                      ),
                    ],
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
                            'In hóa đơn',
                            style:
                                TextStyle(color: colorScheme(context).tertiary),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirestoreHelper.readgiohang(
                            tableController.tableName.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return StreamBuilder(
                                stream: FirestoreHelper.readtinhtrang(
                                    tableController.tableName.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    final tinhtrang = snapshot.data;
                                    for (var i = 0;
                                        i < tinhtrang!.length;
                                        i++) {
                                      if (tinhtrang[i].trangthai == "ordered" &&
                                          tinhtrang[i].idtinhtrang ==
                                              tableController.tableName
                                                  .toString()) {
                                        return MyButton(
                                          onTap: () async {
                                            submitPayment(context);
                                          },
                                          backgroundColor: Colors.blue,
                                          height: 46,
                                          text: Text(
                                            'Xác nhận đơn hàng',
                                            style: TextStyle(
                                                color: colorScheme(context)
                                                    .tertiary),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  return MyButton(
                                    onTap: () async {
                                      final persent =
                                          await applyCouponAndGetPercent();
                                      filePDF = await generateInvoicePDF(
                                          persent, formattedDate);
                                      showPaymentDialog(context);
                                    },
                                    backgroundColor: Colors.blue,
                                    height: 46,
                                    text: Text(
                                      'Thanh toán',
                                      style: TextStyle(
                                        color: colorScheme(context).tertiary,
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                          return const SizedBox();
                        },
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

  Future<int> applyCouponAndGetPercent() async {
    int percent = 0;
    if (controllerData.text.isNotEmpty) {
      await couponsController.filterCoupons(controllerData.text.toUpperCase());
      List<Coupons> list = couponsController.listCoupons;
      if (list.isNotEmpty) {
        if (!FormatDate().compareDate(list[0].endDay) &&
            list[0].soluotdung > 0) {
          percent = list[0].persent;
          showCustomSnackBar(
            title: "OK",
            message: 'Áp dụng mã giảm giá thành công',
            type: Type.success,
          );
        } else {
          percent = 0;
          showCustomSnackBar(
            title: "Thất bại",
            message: 'Mã đã hết hiệu lực hoặc số lượt sử dụng',
            type: Type.error,
          );
        }
      }
    }
    return percent;
  }

  Future<Uint8List> generateInvoicePDF(
      int persent, String formattedDate) async {
    return createPdf(Invoice(
      persentCoupons: persent,
      products: products,
      date: formattedDate,
      nhanvien: authController.userName.value,
      totalAmount: double.parse(tableController.totalPrice.value.toString()),
      tableName: tableController.tableName.value,
    ));
  }

  void showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          title: "Phương thức thanh toán",
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.3,
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: SfPdfViewer.memory(filePDF),
          ),
          labelLeadingButton: 'Tiền mặt',
          labelTraillingButton: 'Mã QR',
          onTapLeading: () {
            submitPayment(context);
          },
          onTapTrailling: () {
            showDialogQRcode(
              context: context,
              tableName: tableController.tableName.value,
              totalPrice: tableController.totalPrice.value,
            );
          },
        );
      },
    );
  }

  void showDialogQRcode(
      {required BuildContext context,
      required String tableName,
      required int totalPrice}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quét mã và thanh toán'),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cacheNetWorkImage(
                  'https://api.vietqr.io/image/970407-1969333333-QaEw1T2.jpg?amount=$totalPrice&addInfo=Thanh toán hóa đơn bàn số $tableName&accountName=HA%20THE%20CHI'),
            ),
          ),
          actions: [
            MyButton(
                width: MediaQuery.sizeOf(context).width * 0.1,
                onTap: () => Navigator.pop(context),
                backgroundColor: Colors.grey.withOpacity(0.4),
                height: 50,
                text: Text(
                  "Hủy".toUpperCase(),
                  style: text(context)
                      .titleSmall
                      ?.copyWith(color: colorScheme(context).tertiary),
                )),
            const SizedBox(width: 20),
            MyButton(
                width: MediaQuery.sizeOf(context).width * 0.1,
                onTap: () => submitPayment(context),
                backgroundColor: colorScheme(context).onSurfaceVariant,
                height: 50,
                text: Text(
                  "Hoàn thành".toUpperCase(),
                  style: text(context)
                      .titleSmall
                      ?.copyWith(color: colorScheme(context).tertiary),
                )),
          ],
        );
      },
    );
  }

  void submitPayment(BuildContext context) async {
    var now = DateTime.now();
    String formattedDate =
        "${now.day}-${now.month}-${now.year} / ${now.hour}:${now.minute}:${now.second}";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
            title: "Xác nhận",
            content: const Text(
                'Bạn có chắc chắn muốn hoàn thành đơn hàng?'),
            labelLeadingButton: 'Xác nhận',
            labelTraillingButton: 'Hủy',
            onTapLeading: () async {
              showCustomSnackBar(
                  title: "Thành công",
                  message: "Đã hoàn thành đơn hàng",
                  type: Type.success);
              // xử lý thanh toán hoá đơn
              // thêm hoá đơn
              await FirestoreHelper.createHoadon(
                  products,
                  formattedDate,
                  authController.userName.value,
                  double.parse(tableController.totalPrice.value.toString()),
                  tableController.tableName.value);
              // xoá giỏ hàng
              await FirestoreHelper.deleteAllgiohang(
                  tableController.tableName.value);
              //cập nhập lại trạng thái bàn
              await FirestoreHelper.updatetable(TableModel(
                  tenban: tableController.tableName.value,
                  isSelected: false,
                  maban: tableController.tableName.value));
              //xoá tình trạng thanhtoan
              await FirestoreHelper.deletetinhtrang(
                  tableController.tableName.value);
              //end
              Navigator.pop(context);
              Navigator.pop(context);
            },
            onTapTrailling: () => Navigator.pop(context));
      },
    );
  }
}
