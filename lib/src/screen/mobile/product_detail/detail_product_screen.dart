import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/widget/image.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/widget/info.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/widget/input_note.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/widget/quantity_button.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

import '../../../firebase_helper/firebasestore_helper.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage(
      {super.key, required this.product, required this.tableModel});
  final SanPham product;
  final TableModel tableModel;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final TextEditingController controllerNode = TextEditingController();
  bool disableButton = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            CupertinoIcons.back,
            size: 32,
            color: colorScheme(context).onBackground,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  imageProduct(widget.product.hinhanh, context),
                  infoProduct(widget.product, context),
                  inputNoteProduct(controllerNode, context),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: FirestoreHelper.readtinhtrang(widget.tableModel.tenban),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return MyButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: colorScheme(context).onSurfaceVariant,
                    height: 60,
                    text: Text(
                      'Vui lòng chờ nhân viên hoàn thành đơn hàng trước đó  ^^',
                      overflow: TextOverflow.fade,
                      style: text(context)
                          .titleSmall
                          ?.copyWith(color: colorScheme(context).tertiary),
                    ),
                  );
                }
              }
              return QuanityButtonProduct(
                price: widget.product.giasp,
                onClick: disableButton
                    ? null
                    : (int soLuong) async {
                        setState(() {
                          disableButton = true;
                        });
                        try {
                          log("Số lượng: $soLuong");

                          await FirestoreHelper.createdgiohang(
                            GioHang(
                                tensp: widget.product.tensp,
                                giasp: widget.product.giasp,
                                soluong: soLuong,
                                ghichu: controllerNode.text,
                                hinhanh: widget.product.hinhanh),
                            widget.tableModel.tenban,
                          );

                          //Thay đổi trạng thái đã chọn bàn
                          final controllerTable = Get.put(TableController());
                          controllerTable
                              .updateSelectedTable(widget.tableModel);
                        } finally {
                          // showCustomSnackBar(
                          //     title: 'Thành công',
                          //     message: "Thêm món thành công",
                          //     type: Type.success);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        }
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
