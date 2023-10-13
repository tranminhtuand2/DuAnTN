import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';

import '../firebasehelper/firebasestore_helper.dart';

class TableController extends GetxController {
  var tables = <int>[].obs;

  Future<void> addTable(List<int> lists) async {
    if (lists.isNotEmpty) {
      tables.value = lists;
    }
  }
}
