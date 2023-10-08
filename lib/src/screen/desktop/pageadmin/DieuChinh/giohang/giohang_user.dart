// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
// import 'package:managerfoodandcoffee/src/controller/alertthongbao.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/TTthanhtoan.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/home_page.dart';

class giohangUser extends StatefulWidget {
  final String tenban;
  const giohangUser({
    Key? key,
    required this.tenban,
  }) : super(key: key);

  @override
  State<giohangUser> createState() => _giohangUserState();
}

class _giohangUserState extends State<giohangUser> {
  TextEditingController makm = TextEditingController();
  int tongtienthanhtoan = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tongtienthanhtoan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ Hàng bàn ${widget.tenban}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(22)),
                height: SizeConfig.screenHeight * 0.8,
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
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          Image.network(giohangindex.hinhanh),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(20),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      giohangindex.tensp,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: " ${giohangindex.giasp}",
                                        children: [
                                          TextSpan(
                                              text: "x ${giohangindex.soluong}")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                    "  VND: ${giohangindex.soluong * giohangindex.giasp}"),
                                IconButton(
                                    onPressed: () {
                                      FirestoreHelper.deletegiohang(
                                          giohangindex, widget.tenban);
                                    },
                                    icon: const Icon(Icons.delete))
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
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 200,
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
                                        const Text("nhập mã"),
                                        SizedBox(
                                          width: SizeConfig.screenWidth * 0.6,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(22),
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
                                        const Text("số tiền cần thanh toán:"),
                                        Text("$tongtienthanhtoan VND"),
                                      ],
                                    ),
                                  ),
                                  // luu hoá đơn
                                  ElevatedButton(
                                      onPressed: () {
                                        FirestoreHelper.createtinhtrang(
                                            tinhtrangTT(trangthai: "success"),
                                            widget.tenban);

                                        Get.defaultDialog(
                                          title: "Thanh toán",
                                          content: Column(
                                            children: [
                                              const Text(
                                                "xác nhận đơn hàng thành công \n vui lòng chờ nhân viên xác nhận",
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
                                                          "đã xác nhận \n vui lòng chuẩn bị $tongtienthanhtoan",
                                                          textAlign:
                                                              TextAlign.center,
                                                        );
                                                      } else {
                                                        const Text(
                                                            "vui lòng chờ");
                                                      }
                                                    }
                                                  }
                                                  return const CircularProgressIndicator();
                                                },
                                              )
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                //quay lai trang san phẩm
                                                Get.to(
                                                  () => HomePage(
                                                      tenban: widget.tenban),
                                                );
                                              },
                                              child: const Text("thoát"),
                                            ),
                                          ],
                                        );
                                      },
                                      child: const Text("Xác nhận thanh toán"))
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
                child: const Text("xem hoá đơn"),
              ),
            )

            // Container(
            //   height: SizeConfig.screenHeight * 0.2,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(22),
            //     color: Theme.of(context).colorScheme.secondaryContainer,
            //   ),
            //   child: Row(
            //     children: [TextFormField()],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> showSnackbar(int totalAmount) async {
    await Future.delayed(Duration.zero); // This ensures the build has completed
    Get.snackbar(
      "Đã xác nhận",
      "Vui lòng chuẩn bị $totalAmount Vnd",
    );
  }
}
