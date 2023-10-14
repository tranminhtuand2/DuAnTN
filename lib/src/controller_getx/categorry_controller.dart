import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/product_controller.dart';
import 'package:managerfoodandcoffee/src/model/danhmuc_model.dart';

import '../firebase_helper/firebasestore_helper.dart';

class CategoryController extends GetxController {
  var categories = <DanhMuc>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    try {
      isLoading.value = true;
      // Lắng nghe stream và cập nhật sản phẩm khi có dữ liệu mới
      FirestoreHelper.readdanhmuc().listen((List<DanhMuc> categoryList) {
        categories.value = categoryList;
        Get.put(ProductController()).fetchProduct(categories[0].tendanhmuc);
        isLoading.value = false;
      });
    } catch (e) {
      print('Error fetching category: $e');
    }
  }
}
