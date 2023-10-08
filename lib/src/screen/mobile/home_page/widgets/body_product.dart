import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/controller_getx/product_controller.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/detail_product_screen.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/constants.dart';

final controller = Get.put(ProductController());
Widget bodyProduct(Size size, String tenban) {
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
        controller.products.isNotEmpty
            ? ListView.builder(
                itemCount: controller.products.length,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  final sanphamnew = controller.products[index];

                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => ProductDetailPage(
                          product: sanphamnew,
                          soBan: tenban,
                        ),
                      );
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
                                  color:
                                      Theme.of(context).colorScheme.background,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
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
                                          color:
                                              colorScheme(context).onTertiary),
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
              )
            : SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Lottie.asset("assets/images/ani_nothing.json"),
                ),
              ),
      ],
    ),
  );
}
