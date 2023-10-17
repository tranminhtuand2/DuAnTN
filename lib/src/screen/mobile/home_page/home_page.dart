import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/categorry_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/drawer_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/product_controller.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/alert_screen/alert_screen.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/cart_user/giohang_user.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/home_page/widgets/body_product.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/constants.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';
import 'package:managerfoodandcoffee/src/utils/will_pop_scope.dart';

import '../../../firebase_helper/firebasestore_helper.dart';

class HomePage extends StatefulWidget {
  final TableModel table;
  const HomePage({super.key, required this.table});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> category = [];
  List<SanPham> sanpham = [];
  String categories = "";
  int selectedindex = 0;
  final controller = Get.put(ProductController());
  final controllerCategory = Get.put(CategoryController());
  final pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onBackPressed(context);
      },
      child: Scaffold(
        backgroundColor: colorScheme(context).primary,
        // drawer: const MyDrawer(),
        appBar: AppBar(
          backgroundColor: colorScheme(context).primary,
          elevation: 0,
          title: Text(
            "BÀN ${widget.table.tenban}",
            style: text(context).titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme(context).tertiary),
          ),
          leading: IconButton(
              onPressed: () {
                Get.put(MyDrawerController()).toggleDrawer();
              },
              icon: Icon(
                CupertinoIcons.bars,
                size: 32,
                color: colorScheme(context).tertiary,
              )),
          centerTitle: true,
          actions: [
            gioHang(),
            notifications(),
          ],
        ),
        body: Column(
          children: [
            Obx(
              () {
                return controllerCategory.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: const EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 10),
                        height: MediaQuery.sizeOf(context).height * 0.04,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controllerCategory.categories.length,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (context, index) => InkWell(
                            splashColor: Colors.transparent,
                            onTap: selectedindex == index
                                ? null
                                : () {
                                    pageViewController.jumpToPage(index);
                                    setState(() {
                                      selectedindex = index;
                                      // categories = controllerCategory
                                      //     .categories[index].tendanhmuc;
                                      // controller.fetchProduct(categories);
                                    });
                                  },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding, vertical: 6),
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    index == selectedindex ? 0.8 : 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                controllerCategory.categories[index].tendanhmuc
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: index == selectedindex
                                          ? colorScheme(context).onTertiary
                                          : colorScheme(context).tertiary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
            Obx(
              () {
                return Expanded(
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        selectedindex = value;
                      });
                      controller.fetchProduct(
                          controllerCategory.categories[value].tendanhmuc);
                      // log("message $value ${controllerCategory.categories[value].tendanhmuc}");
                      // log(controller.products[value].tensp.toString());
                    },
                    controller: pageViewController,
                    itemCount: controllerCategory.categories.length,
                    itemBuilder: (context, index) {
                      return MyBodyProduct(tenBan: widget.table.tenban);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<List<GioHang>> gioHang() {
    return StreamBuilder(
      stream: FirestoreHelper.readgiohang(widget.table.tenban),
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

          return giohangtb!.isNotEmpty
              ? badges.Badge(
                  position: badges.BadgePosition.custom(),
                  badgeAnimation: const badges.BadgeAnimation.fade(),
                  //lấy dự liệu order
                  badgeContent: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "${giohangtb.length}",
                      style: text(context)
                          .titleSmall
                          ?.copyWith(color: colorScheme(context).tertiary),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      onPressed: () {
                        Get.to(
                          () => CartProduct(table: widget.table),
                        );
                      },
                      icon: Icon(
                        CupertinoIcons.cart_fill,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget notifications() {
    return IconButton(
      onPressed: () {
        Get.to(
          () => const AlertScreen(),
        );
      },
      icon: Icon(
        CupertinoIcons.bell_fill,
        size: 30,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
