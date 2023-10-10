import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:managerfoodandcoffee/src/constants/size.dart';

import 'package:managerfoodandcoffee/src/controller/CRUD_table.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
// import 'package:managerfoodandcoffee/src/controller/CRUD_controller_header.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/page_crud/headercrud_screen.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/page_crud/sanphamcrud_screen.dart';

class dieuchinhSceen extends StatefulWidget {
  const dieuchinhSceen({super.key});

  @override
  State<dieuchinhSceen> createState() => _dieuchinhSceenState();
}

class _dieuchinhSceenState extends State<dieuchinhSceen>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("bán hàng"),
      // ),
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Thêm sản phẩm",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.settings,
            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
            onPress: () {
              _animationController!.reverse();
              Get.to(() => const SanphamCrudScreen());
            },
          ),
          Bubble(
            title: "Tài khoản",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.people,
            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
            onPress: () {
              _animationController!.reverse();
              Get.dialog(const Crud_table());
            },
          ),
          Bubble(
            title: "quản lý slider",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.home,
            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
            onPress: () {
              _animationController!.reverse();
              Get.to(() => const headerCrudScreen());
            },
          ),
        ],
        animation: _animation!,
        onPress: () => _animationController!.isCompleted
            ? _animationController!.reverse()
            : _animationController!.forward(),
        backGroundColor: Colors.blue,
        iconColor: Colors.white,
        iconData: Icons.settings,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //header
              StreamBuilder(
                stream: FirestoreHelper.readtable(),
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
                    final table = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          height: SizeConfig.screenHeight,
                          width: double.infinity,
                          child: GridView.builder(
                            itemCount: table!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  6, // Bạn có thể thay đổi số cột ở đây
                              mainAxisSpacing:
                                  10.0, // Điều chỉnh khoảng cách giữa các mục theo chiều dọc
                              crossAxisSpacing:
                                  10.0, // Điều chỉnh khoảng cách giữa các mục theo chiều ngang
                            ),
                            itemBuilder: (context, index) {
                              final tableindex = table[index];
                              return StreamBuilder(
                                stream: FirestoreHelper.readgiohang(
                                    tableindex.tenban),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return SingleChildScrollView(
                                      child: Text(
                                          "Lỗi: ${snapshot.error.toString()}"),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    final giohangtb = snapshot.data;
                                    return badges.Badge(
                                      position: badges.BadgePosition.topStart(),
                                      badgeAnimation:
                                          const badges.BadgeAnimation.fade(),
                                      //lấy dự liệu order
                                      badgeContent: Text(
                                        "${giohangtb!.length}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      child: giohangtb.isNotEmpty
                                          ? InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green[300],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                margin:
                                                    const EdgeInsets.all(20),
                                                height: 300,
                                                width: 150,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        "/images/bill1.png",
                                                        height: 150,
                                                        width: 100,
                                                      ),
                                                      Text(
                                                          "bàn số  ${tableindex.tenban}"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              margin: const EdgeInsets.all(20),
                                              height: 300,
                                              width: 150,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      "/images/bill1.png",
                                                      height: 150,
                                                      width: 100,
                                                    ),
                                                    Text(
                                                        "bàn số  ${tableindex.tenban}"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    );
                                  }
                                  return SingleChildScrollView(
                                    child: Text(
                                        "Lỗi: ${snapshot.error.toString()}"),
                                  );
                                },
                              );
                              //  badges.Badge(
                              //   position: badges.BadgePosition.center(),
                              //   badgeAnimation: badges.BadgeAnimation.fade(),
                              //   //lấy dự liệu order
                              //   badgeContent: Text("0"),
                              //   child: Container(
                              //     margin: EdgeInsets.all(20),
                              //     height: 300,
                              //     width: 150,
                              //     child: SingleChildScrollView(
                              //       child: Column(
                              //         children: [
                              //           Image.asset(
                              //             "/images/bill1.png",
                              //             height: 150,
                              //             width: 100,
                              //           ),
                              //           Text("bàn số  ${tableindex.tenban}"),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text("đang tải dữ liệu")
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
