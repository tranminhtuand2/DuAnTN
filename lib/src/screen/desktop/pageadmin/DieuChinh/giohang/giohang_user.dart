// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
// import 'package:managerfoodandcoffee/src/controller/alertthongbao.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/TTthanhtoan.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/home_page/home_page.dart';
import 'package:managerfoodandcoffee/src/common_widget/bottom_sheet.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

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
  final makm = TextEditingController();
  int tongtienthanhtoan = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bàn ${widget.tenban}"),
        centerTitle: true,
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
                            color: const Color.fromARGB(255, 229, 229, 229),
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
                                          style: text(context)
                                              .titleLarge
                                              ?.copyWith(
                                                  color: colorScheme(context)
                                                      .onTertiary),
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
                                          text: "${giohangindex.giasp}",
                                          children: [
                                            TextSpan(
                                                text:
                                                    " x ${giohangindex.soluong}")
                                          ],
                                        ),
                                      ),
                                      Text(
                                          "Tổng: ${giohangindex.soluong * giohangindex.giasp} vnđ"),
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
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      // height: 200,
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
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Mã giảm giá: ",
                                          style: text(context)
                                              .titleMedium
                                              ?.copyWith(
                                                  color: colorScheme(context)
                                                      .onTertiary)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          height: 54,
                                          child: TextFormField(
                                            controller: makm,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 20),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.confirmation_num))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Tổng tiền:",
                                        style: text(context)
                                            .titleMedium
                                            ?.copyWith(
                                                color: colorScheme(context)
                                                    .onTertiary),
                                      ),
                                      Text("$tongtienthanhtoan VNĐ",
                                          style: text(context)
                                              .titleMedium
                                              ?.copyWith(
                                                  color: colorScheme(context)
                                                      .onTertiary)),
                                    ],
                                  ),
                                ),
                                // luu hoá đơn
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: MyButton(
                                      onTap: () {
                                        FirestoreHelper.createtinhtrang(
                                            tinhtrangTT(trangthai: "success"),
                                            widget.tenban);

                                        Get.defaultDialog(
                                          title: "Thanh toán",
                                          content: Column(
                                            children: [
                                              const Text(
                                                "Xác nhận đơn hàng thành công \n vui lòng chờ nhân viên xác nhận",
                                                textAlign: TextAlign.center,
                                              ),
                                              StreamBuilder(
                                                stream: FirestoreHelper
                                                    .readtinhtrang(
                                                        widget.tenban),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (snapshot.hasError) {
                                                    return const Center(
                                                      child: Text("lỗi"),
                                                    );
                                                  }
                                                  if (snapshot.hasData) {
                                                    final tinhtrang =
                                                        snapshot.data;
                                                    for (var i = 0;
                                                        i < tinhtrang!.length;
                                                        i++) {
                                                      if (tinhtrang[i]
                                                                  .trangthai ==
                                                              "xacnhan" &&
                                                          tinhtrang[i]
                                                                  .idtinhtrang ==
                                                              widget.tenban) {
                                                        showSnackbar(
                                                            tongtienthanhtoan);
                                                        return Text(
                                                          "Đã xác nhận \n vui lòng chuẩn bị $tongtienthanhtoan vnđ",
                                                          textAlign:
                                                              TextAlign.center,
                                                        );
                                                      } else {
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10),
                                                          child: const Text(
                                                              "Vui lòng chờ"),
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
                                                    () => HomePage(
                                                        tenban: widget.tenban),
                                                  );
                                                },
                                                backgroundColor:
                                                    colorScheme(context)
                                                        .primary,
                                                height: 60,
                                                text: Text(
                                                  'Thoát',
                                                  style: text(context)
                                                      .titleMedium
                                                      ?.copyWith(
                                                          color: colorScheme(
                                                                  context)
                                                              .tertiary),
                                                ))
                                          ],
                                        );
                                      },
                                      backgroundColor:
                                          colorScheme(context).primary,
                                      height: 60,
                                      text: Text(
                                        'Xác nhận thanh toán',
                                        style: text(context)
                                            .titleMedium
                                            ?.copyWith(
                                                color: colorScheme(context)
                                                    .tertiary),
                                      )),
                                )
                              ],
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

  Future<void> showSnackbar(int totalAmount) async {
    await Future.delayed(Duration.zero); // This ensures the build has completed
    Get.snackbar(
      "Đã xác nhận",
      "Vui lòng chuẩn bị $totalAmount VNĐ",
    );
  }
}
