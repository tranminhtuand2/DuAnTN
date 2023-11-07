import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_search.dart';
import 'package:managerfoodandcoffee/src/controller_getx/categorry_controller.dart';
import 'package:managerfoodandcoffee/src/controller_getx/product_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';
import 'package:managerfoodandcoffee/src/model/danhmuc_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/home_page/widgets/shimmer_loading.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class ShowProduct extends StatefulWidget {
  const ShowProduct({super.key, required this.tableName});
  final String tableName;
  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  final controller = Get.put(ProductController());
  final controllerCategory = Get.put(CategoryController());
  int selectedindex = 0;
  final _controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerSearch.addListener(() {
      if (_controllerSearch.text.isNotEmpty) {
        controller.filterData(_controllerSearch.text);
      } else {
        controller.fetchAllProduct();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    ColorScheme color = colorScheme(context);
    return Dialog(
      backgroundColor: color.primary,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.5,
        height: MediaQuery.sizeOf(context).height * 0.9,
        decoration: BoxDecoration(
            color: color.onPrimary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Obx(
                      () {
                        return controllerCategory.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Wrap(
                                children: controllerCategory.categories
                                    .asMap()
                                    .entries
                                    .map(
                                  (entry) {
                                    int index = entry.key;
                                    DanhMuc element = entry.value;

                                    return InkWell(
                                      onTap: selectedindex == index
                                          ? null
                                          : () {
                                              setState(() {
                                                selectedindex = index;
                                                if (kIsWeb &&
                                                    selectedindex == 0) {
                                                  controller.fetchAllProduct();
                                                } else {
                                                  controller.fetchProduct(
                                                      element.tendanhmuc);
                                                }
                                              });
                                            },
                                      child: Container(
                                        // alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 30),
                                        margin: const EdgeInsets.only(
                                            bottom: 12, right: 12),
                                        decoration: BoxDecoration(
                                          color: color.background.withOpacity(
                                              index == selectedindex ? 1 : 0.3),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                            element.tendanhmuc.toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                      ),
                                    );
                                  },
                                ).toList(),
                              );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputSearch(
                      onTap: () {},
                      controllerSend: _controllerSearch,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? shimmerLoading()
                    : controller.products.isNotEmpty
                        ? GridView.builder(
                            itemCount: controller.products.length,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  5, // Bạn có thể thay đổi số cột ở đây
                              mainAxisSpacing:
                                  30, // Điều chỉnh khoảng cách giữa các mục theo chiều dọc
                              crossAxisSpacing:
                                  16.0, // Điều chỉnh khoảng cách giữa các mục theo chiều ngang
                              // mainAxisExtent: 500,
                            ),
                            itemBuilder: (context, index) {
                              final sanphamindex = controller.products[index];
                              return InkWell(
                                onTap: () async {
                                  await FirestoreHelper.createdgiohang(
                                    GioHang(
                                        tensp: sanphamindex.tensp,
                                        giasp: sanphamindex.giasp,
                                        soluong: 1,
                                        ghichu: "",
                                        hinhanh: sanphamindex.hinhanh),
                                    widget.tableName,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color.onPrimary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: cacheNetWorkImage(
                                          sanphamindex.hinhanh,
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              colorScheme(context)
                                                  .background
                                                  .withOpacity(0),
                                              colorScheme(context)
                                                  .background
                                                  .withOpacity(0.2),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: Text(
                                          sanphamindex.tensp.toUpperCase(),
                                          style: text(context)
                                              .titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Text(
                                          "${formatPrice(sanphamindex.giasp)} VNĐ",
                                          style: text(context).titleMedium,
                                        ),
                                      ),
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
                              child: Lottie.asset(
                                  "assets/images/ani_nothing.json"),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
