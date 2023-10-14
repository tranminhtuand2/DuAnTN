import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';

import '../firebase_helper/firebasestore_helper.dart';

class ProductController extends GetxController {
  var products = <SanPham>[].obs;
  var isLoading = false.obs;

  Future<void> fetchProduct(String categories) async {
    try {
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
}
