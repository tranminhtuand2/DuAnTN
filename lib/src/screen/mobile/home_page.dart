import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/controller_getx/categorry_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/product_controller.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';

import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/giohang/giohang_user.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/detail_page.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/constants.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

import '../../firebasehelper/firebasestore_helper.dart';

class HomePage extends StatefulWidget {
  final String tenban;
  const HomePage({super.key, required this.tenban});

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Bàn ${widget.tenban}",
          style:
              text(context).titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          gioHang(),
        ],
      ),
      body: Column(
        children: [
          // StreamBuilder(
          //   stream: FirestoreHelper.readdanhmuc(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //     if (snapshot.hasError) {
          //       return const Center(
          //         child: Text("đã có lỗi xảy ra"),
          //       );
          //     }
          //     if (snapshot.hasData) {
          //       category = [];
          //       for (var i = 0; i < snapshot.data!.length; i++) {
          //         category.add(snapshot.data![i].tendanhmuc);
          //       }
          //     }
          //     return const SizedBox();
          //   },
          // ),
          Obx(
            () {
              return controllerCategory.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      height: MediaQuery.sizeOf(context).height * 0.04,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controllerCategory.categories.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => InkWell(
                          splashColor: Colors.transparent,
                          onTap: selectedindex == index
                              ? null
                              : () {
                                  setState(() {
                                    selectedindex = index;
                                    categories = controllerCategory
                                        .categories[index].tendanhmuc;
                                    controller.fetchProduct(categories);
                                    // print(categories);
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                                controllerCategory.categories[index].tendanhmuc,
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                        ),
                      ),
                    );
            },
          ),
          Obx(
            () {
              return controller.isLoading.value
                  ? const Center(
                      child: LinearProgressIndicator(),
                    )
                  : bodyProduct(size);
            },
          ),
        ],
      ),
    );
  }

  Widget bodyProduct(Size size) {
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
            itemCount: controller.products.length,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              final sanphamnew = controller.products[index];

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
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              boxShadow: const [kDefaultShadow],
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(22)),
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
                          child: cacheNetWorkImage(
                            sanphamnew.hinhanh,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  sanphamnew.tensp,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding * 1.5,
                                  vertical: kDefaultPadding / 4,
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(22),
                                    topRight: Radius.circular(22),
                                  ),
                                ),
                                child: Text(
                                  "${sanphamnew.giasp} vnđ",
                                  style: TextStyle(
                                      color: colorScheme(context).onTertiary),
                                ),
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

  StreamBuilder<List<GioHang>> gioHang() {
    return StreamBuilder(
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
                },
                icon: Icon(
                  Icons.shopping_bag,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
