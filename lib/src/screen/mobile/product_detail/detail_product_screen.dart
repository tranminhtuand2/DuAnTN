import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/widget/image.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/widget/info.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/widget/input_note.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/widget/quantity_button.dart';

import '../../../firebasehelper/firebasestore_helper.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage(
      {super.key, required this.product, required this.soBan});
  final SanPham product;
  final String soBan;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final TextEditingController controllerNode = TextEditingController();
  bool disableButton = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      imageProduct(widget.product.hinhanh, context),
                      infoProduct(widget.product, context),
                      inputNoteProduct(controllerNode),
                    ],
                  ),
                ),
              ),
              QuanityButtonProduct(
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
                            widget.soBan,
                          );
                        } finally {
                          showCustomSnackBar(
                              title: 'Thành công',
                              message: "Thêm món thành công",
                              type: Type.success);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        }
                      },
              ),
            ],
          ),
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_circle_left_rounded,
                size: 50.0,
              ),
              color: Colors.black.withOpacity(0.6),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }
}
