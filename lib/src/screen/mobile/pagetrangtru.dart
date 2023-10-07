import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';

import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/giohang/giohang_user.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/detailpage.dart';
import 'package:managerfoodandcoffee/src/utils/constants.dart';

import '../../firebasehelper/firebasestore_helper.dart';

class LoginPage extends StatefulWidget {
  final String tenban;
  const LoginPage({super.key, required this.tenban});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<String>? category;
  List<SanPham> sanpham = [];
  String categories = "";
  int selectedindex = 0;
  void filterfromfirebase(String query) async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = [];
    sanpham = [];
    // categories = category![0];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: Text("Bàn ${widget.tenban}"),
          centerTitle: false,
          actions: [
            StreamBuilder(
              stream: FirestoreHelper.readgiohang(widget.tenban),
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
                  return badges.Badge(
                    position: badges.BadgePosition.custom(),
                    badgeAnimation: const badges.BadgeAnimation.fade(),
                    //lấy dự liệu order
                    badgeContent: Text(
                      "${giohangtb!.length}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    child: IconButton(
                        onPressed: () {
                          Get.to(
                            () => giohangUser(tenban: widget.tenban),
                          );
                          // giohangUser(tenban: widget.tenban);
                        },
                        icon: Icon(
                          Icons.shopping_bag,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        )),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
        body: Column(
          children: [
            StreamBuilder(
              stream: FirestoreHelper.readdanhmuc(),
              builder: (context, snapshot) {
                final danhmuc = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("đã có lỗi xảy ra"),
                  );
                }
                if (snapshot.hasData) {
                  if (danhmuc != null) {
                    for (var i = 0; i < danhmuc.length; i++) {
                      if (category!.length < danhmuc.length) {
                        category!.add(danhmuc[i].tendanhmuc);
                      }
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: category!.length,
                        itemBuilder: (context, index) => Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            left: kDefaultPadding,
                            right: index == category!.length - 1
                                ? kDefaultPadding
                                : 0,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          decoration: BoxDecoration(
                            color: index == selectedindex
                                ? Colors.white.withOpacity(0.4)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedindex = index;
                                categories = category![index];
                                print(categories);
                              });
                            },
                            child: Text(
                              category![index],
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: categories != ""
                  ? FirestoreHelper.filletsp(categories)
                  : FirestoreHelper.readsp(),
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
                  final sanpham = snapshot.data;
                  //giao dien
                  return Expanded(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 70),
                          decoration: const BoxDecoration(
                            color: kBackgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: sanpham!.length,
                          itemBuilder: (context, index) {
                            final sanphamnew = sanpham[index];
                            return InkWell(
                              onTap: () {
                                Get.to(() => detaiPagescreen(
                                      sanpham: sanphamnew,
                                      tenban: widget.tenban,
                                    ));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding,
                                    vertical: kDefaultPadding / 2),
                                // color: Theme.of(context).colorScheme.secondary,
                                height: 160,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      height: 136,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: kBlueColor,
                                      ),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            boxShadow: const [kDefaultShadow],
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                BorderRadius.circular(22)),
                                      ),
                                    ),
                                    //hien thi ảnh sản phẩm
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPadding),
                                        height: 160,
                                        width: 200,
                                        child: Image.network(
                                          sanpham[index].hinhanh,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    //hiện thị thông tin sản phẩm
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      child: SizedBox(
                                        height: 136,
                                        width: size.width - 200,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Text(
                                                sanpham[index].tensp,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal:
                                                    kDefaultPadding * 1.5,
                                                vertical: kDefaultPadding / 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiary,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(22),
                                                  topRight: Radius.circular(22),
                                                ),
                                              ),
                                              child: Text(sanpham[index]
                                                  .giasp
                                                  .toString()),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
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
          ],
        ),
      ),
    );
  }
}
