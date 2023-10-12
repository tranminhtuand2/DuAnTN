import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/controller_getx/product_controller.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/home_page/widgets/shimmer_loading.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/product_detail/detail_product_screen.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/constants.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';
import 'package:shimmer/shimmer.dart';

class MyBodyProduct extends StatefulWidget {
  const MyBodyProduct({
    super.key,
    required this.tenBan,
  });
  final String tenBan;

  @override
  State<MyBodyProduct> createState() => _MyBodyProductState();
}

class _MyBodyProductState extends State<MyBodyProduct> {
  final controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 70),
            decoration: BoxDecoration(
              color: colorScheme(context).background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
          ),
          controller.isLoading.value
              ? shimmerLoading()
              : controller.products.isNotEmpty
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
                                soBan: widget.tenBan,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding,
                                vertical: kDefaultPadding / 2),
                            // color: Theme.of(context).colorScheme.secondary,
                            height: MediaQuery.sizeOf(context).height * 0.16,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.14,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: colorScheme(context)
                                        .primary
                                        .withOpacity(0.6),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        boxShadow: const [kDefaultShadow],
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius:
                                            BorderRadius.circular(20)),
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
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 30),
                                    height: 136,
                                    width: size.width - 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          sanphamnew.tensp.toUpperCase(),
                                          style: text(context)
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${formatPrice(sanphamnew.giasp)} vnđ",
                                          style: TextStyle(
                                              color: colorScheme(context)
                                                  .onTertiary),
                                        ),
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
}
