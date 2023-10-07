import 'dart:developer';

import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';

import '../firebasehelper/firebasestore_helper.dart';

class ProductController extends GetxController {
  var products = <SanPham>[].obs;
  var isLoading = false.obs;

  Future<void> fetchProduct(String categories) async {
    try {
      isLoading.value = true;
      // Lắng nghe stream và cập nhật sản phẩm khi có dữ liệu mới
      FirestoreHelper.filletsp(categories).listen((List<SanPham> productList) {
        products.value = productList;
        isLoading.value = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }
}
