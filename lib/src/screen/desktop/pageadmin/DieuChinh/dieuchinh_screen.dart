import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:managerfoodandcoffee/src/utils/size.dart';

import 'package:managerfoodandcoffee/src/controller/CRUD_table.dart';
import 'package:managerfoodandcoffee/src/controller_getx/google_signin_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/giohang/giohang_admin.dart';

// import 'package:managerfoodandcoffee/src/controller/CRUD_controller_header.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/page_crud/headercrud_screen.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/page_crud/sanphamcrud_screen.dart';

import '../../../../controller_getx/brightness_controller.dart';
import '../../../../firebase_helper/firebasestore_helper.dart';

class dieuchinhSceen extends StatefulWidget {
  const dieuchinhSceen({super.key});

  @override
  State<dieuchinhSceen> createState() => _dieuchinhSceenState();
}

class _dieuchinhSceenState extends State<dieuchinhSceen>
    with SingleTickerProviderStateMixin {
  final BrightnessController brightnessController =
      Get.put(BrightnessController());
  Animation<double>? _animation;
  AnimationController? _animationController;
  // String tttenban = "";
  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   final myalert = Get.put(getAlert());
  //   if (tttenban != "") {
  //     myalert.showAlertDialog("THÔNG BÁO", "$tttenban ĐÃ ORDER");
  //   }
  // }

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

  final googleSignInController = Get.put(GoogleSignInController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(googleSignInController.email.value),
        ),
        actions: [
          IconButton(
            onPressed: () {
              googleSignInController.logoutGoogle();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
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
            title: "Thêm bàn",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.table_view,
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
          //chế độ sáng tối
          Bubble(
            title: brightnessController.isDarkMode == true
                ? " Dart Mode"
                : "Light Mode",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: brightnessController.isDarkMode == true
                ? Icons.dark_mode
                : Icons.light_mode,
            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
            onPress: () {
              setState(() {
                brightnessController.isDarkMode;
              });
              brightnessController.toggleDarkMode();
              _animationController!.reverse();
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
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Danh Sách Bàn",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      //thong bao
                      StreamBuilder(
                        stream: FirestoreHelper.readtinhtrangtt(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                            final tinhtrangtt = snapshot.data;

                            return badges.Badge(
                              position: badges.BadgePosition.topStart(),
                              badgeAnimation:
                                  const badges.BadgeAnimation.fade(),
                              //lấy dự liệu order
                              badgeContent: Text(
                                "${tinhtrangtt!.length}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.notifications),
                              ),
                            );
                          }
                          return const Icon(Icons.notifications);
                        },
                      )
                      //end thong bao
                    ],
                  ),
                ),
              ),
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
                      padding: const EdgeInsets.all(10),
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
                                  20.0, // Điều chỉnh khoảng cách giữa các mục theo chiều ngang
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
                                              onTap: () {
                                                Get.to(() => giohang_admin(
                                                    tenban: tableindex.tenban));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green[300],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                margin:
                                                    const EdgeInsets.all(10),
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
                                              margin: const EdgeInsets.all(10),
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
