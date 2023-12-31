import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';

import '../firebase_helper/firebasestore_helper.dart';

class ProductController extends GetxController {
  var products = <SanPham>[].obs;
  var productsFilter = <SanPham>[].obs;
  var isLoading = false.obs;

  Future<void> fetchProduct(String categories) async {
    try {
      products.clear();
      isLoading.value = true;
      // Lắng nghe stream và cập nhật sản phẩm khi có dữ liệu mới
      FirestoreHelper.filletsp(categories).listen((List<SanPham> productList) {
        products.value = productList;
        //Tạo thời gian delay cho trải nghiệm đỡ giật cục
        Future.delayed(const Duration(milliseconds: 150), () {
          isLoading.value = false;
        });
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> fetchAllProduct() async {
    try {
      products.clear();
      isLoading.value = true;
      // Lắng nghe stream và cập nhật sản phẩm khi có dữ liệu mới
      FirestoreHelper.readsp().listen((List<SanPham> productList) {
        products.value = productList;
        //Tạo thời gian delay cho trải nghiệm đỡ giật cục
        Future.delayed(const Duration(milliseconds: 150), () {
          isLoading.value = false;
        });
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void filterData(String keyword) {
    try {
      if (products.isNotEmpty) {
        productsFilter.value = products
            .where((value) => removeDiacritics(value.tensp.toLowerCase())
                .contains(removeDiacritics(keyword.toLowerCase())))
            .toList();
        products.value = productsFilter;
      }
    } catch (e) {
      print('Error filter products: $e');
    }
  }
}
