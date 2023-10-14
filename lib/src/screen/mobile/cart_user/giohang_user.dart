// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/bottom_sheet.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/TTthanhtoan.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/cart_user/widgets/show_discount.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/cart_user/widgets/show_payment.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/home_page/home_page.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/notifications/notification.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/payment_wallet/momo_wallet.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';
import 'package:momo_vn/momo_vn.dart';

class CartProduct extends StatefulWidget {
  final String tenban;
  const CartProduct({
    Key? key,
    required this.tenban,
  }) : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  int tongtienthanhtoan = 0;
  final discountController = TextEditingController();
  int isSelectedPayment = 0;

  late MomoVn _momoPay;
  // ignore: unused_field
  late PaymentResponse _momoPaymentResult;
  // late String _payment_status = '';

  @override
  void initState() {
    super.initState();
    //Khởi tạo notification
    PushNotification.intialize();

    _momoPay = MomoVn();
    _momoPay.on(MomoVn.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _momoPay.on(MomoVn.EVENT_PAYMENT_ERROR, _handlePaymentError);
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BÀN ${widget.tenban}",
          style:
              text(context).titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
            child: StreamBuilder(
              stream: FirestoreHelper.readgiohang(widget.tenban),
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
                    itemBuilder: (context, index) {
                      final giohangindex = giohang[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        decoration: BoxDecoration(
                            color:
                                colorScheme(context).primary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: getProportionateScreenWidth(88),
                              child: AspectRatio(
                                aspectRatio: 0.88,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F6F9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child:
                                      cacheNetWorkImage(giohangindex.hinhanh),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          giohangindex.tensp.toUpperCase(),
                                          style: text(context).titleLarge,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          dialogModalBottomsheet(
                                              context, 'xóa', () async {
                                            await FirestoreHelper.deletegiohang(
                                                giohangindex, widget.tenban);
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.trash_circle,
                                          color: Colors.red,
                                          size: 36,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: formatPrice(giohangindex.giasp),
                                          children: [
                                            TextSpan(
                                                text:
                                                    " x ${giohangindex.soluong}")
                                          ],
                                        ),
                                      ),
                                      Text(
                                          "TỔNG: ${formatPrice(giohangindex.soluong * giohangindex.giasp)} VNĐ"),
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
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: MyButton(
              onTap: () {
                bottomSheetPayment(context);
              },
              backgroundColor: colorScheme(context).primary,
              height: 60,
              text: Text(
                'Thanh toán',
                style: text(context)
                    .titleMedium
                    ?.copyWith(color: colorScheme(context).tertiary),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> bottomSheetPayment(BuildContext context) {
    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: colorScheme(context).onPrimary,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: StreamBuilder(
            stream: FirestoreHelper.readgiohang(widget.tenban),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                tongtienthanhtoan = 0;
                final tongtiengh = snapshot.data;
                for (var i = 0; i < tongtiengh!.length; i++) {
                  tongtienthanhtoan +=
                      tongtiengh[i].giasp * tongtiengh[i].soluong;
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      totalPrice(context),
                      ShowDiscount(discountController: discountController),
                      ShowPayment(
                        onTap: (int isSelected) {
                          setState(() {
                            isSelectedPayment = isSelected;
                          });
                        },
                      ),
                      // luu hoá đơn
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: MyButton(
                          onTap: () {
                            log(isSelectedPayment.toString());
                            switch (isSelectedPayment) {
                              case 0:
                                log('Cash');
                                createPaymentStatus();
                                break;
                              case 1:
                                log('MoMo');
                                Get.back();
                                openMoMoApp(
                                    amount: tongtienthanhtoan,
                                    orderId: widget.tenban +
                                        tongtienthanhtoan.toString(),
                                    description: 'Thanh toán hóa đơn',
                                    username:
                                        'Khách bàn số ${widget.tenban}');
                                break;
                              case 2:
                                log('VnPay');
                                //
                                break;
                            }
                          },
                          backgroundColor: colorScheme(context).primary,
                          height: 60,
                          text: Text(
                            'Xác nhận ',
                            style: text(context).titleMedium?.copyWith(
                                color: colorScheme(context).tertiary),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }

  Container totalPrice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(width: 0.7, color: colorScheme(context).onBackground)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Tổng tiền:",
            style: text(context).titleMedium,
          ),
          Text("${formatPrice(tongtienthanhtoan)} VNĐ",
              style: text(context).titleMedium),
        ],
      ),
    );
  }

  Future<void> showSnackbar(int totalAmount) async {
    await Future.delayed(Duration.zero); // This ensures the build has completed
    Get.snackbar(
      "Đã xác nhận",
      "Vui lòng chuẩn bị $totalAmount VNĐ",
    );
  }

  void _handlePaymentSuccess(PaymentResponse response) async {
    setState(() {
      _momoPaymentResult = response;
      // _setState();
    });
    log('THANH TOÁN THÀNH CÔNG');
    await PushNotification.showNotification(
        id: 1,
        title: 'Thanh toán ${formatPrice(tongtienthanhtoan)} thành công',
        body: 'Vui lòng chờ đồ uống trong vài phút <3');
    //gọi hàm xác nhận thanh toán lên firebase
    createPaymentStatus();
  }

  void _handlePaymentError(PaymentResponse response) async {
    setState(() {
      _momoPaymentResult = response;
      // _setState();
    });
    log('THANH TOÁN THẤT BẠI');
    await PushNotification.showNotification(
        id: int.parse(widget.tenban),
        title: 'Thanh toán lỗi',
        body: 'Có lỗi trong quá trình thanh toán rồi :(');
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {});
  }

  void openMoMoApp({
    required int amount,
    required String orderId,
    required String description,
    required String username,
  }) {
    try {
      _momoPay.open(setOptionsPayment(
        amount: amount,
        orderId: orderId,
        description: description,
        username: username,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void createPaymentStatus() {
    FirestoreHelper.createtinhtrang(
        tinhtrangTT(trangthai: "success"), widget.tenban);
    Get.defaultDialog(
      title: "Thanh toán",
      content: Column(
        children: [
          const Text(
            "Xác nhận đơn hàng thành công \n vui lòng chờ nhân viên xác nhận",
            textAlign: TextAlign.center,
          ),
          StreamBuilder(
            stream: FirestoreHelper.readtinhtrang(widget.tenban),
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
                final tinhtrang = snapshot.data;
                for (var i = 0; i < tinhtrang!.length; i++) {
                  if (tinhtrang[i].trangthai == "xacnhan" &&
                      tinhtrang[i].idtinhtrang == widget.tenban) {
                    showSnackbar(tongtienthanhtoan);
                    return Text(
                      "Đã xác nhận \n vui lòng chuẩn bị $tongtienthanhtoan vnđ",
                      textAlign: TextAlign.center,
                    );
                  } else {
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text("Vui lòng chờ"),
                    );
                  }
                }
              }
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
      actions: [
        MyButton(
            onTap: () {
              //quay lai trang san phẩm
              Get.offAll(
                () => HomePage(tenban: widget.tenban),
              );
            },
            backgroundColor: colorScheme(context).primary,
            height: 60,
            text: Text(
              'Thoát',
              style: text(context)
                  .titleMedium
                  ?.copyWith(color: colorScheme(context).tertiary),
            ))
      ],
    );
  }
}
