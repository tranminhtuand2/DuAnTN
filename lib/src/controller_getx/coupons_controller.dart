import 'dart:async';

import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/coupons_model.dart';

class CouponsController extends GetxController {
  var isLoading = false.obs;
  var coupons = Coupons(
          id: '',
          beginDay: '',
          endDay: '',
          data: '',
          persent: 0,
          isEnable: true,
          soluotdung: 0)
      .obs;

  Future<void> filterCoupons(String data) async {
    try {
      final completer = Completer<Coupons>();
      isLoading.value = true;

      // Lắng nghe stream và cập nhật sản phẩm khi có dữ liệu mới
      FirestoreHelper.filterCoupons(data).listen((Coupons dataCoupons) {
        coupons.value = dataCoupons;
        isLoading.value = false;
        completer.complete(dataCoupons); // Đánh dấu hoàn thành khi có dữ liệu
      });

      await completer.future; // Chờ cho hoàn thành của dữ liệu từ Firestore
    } catch (e) {
      isLoading.value = false;
      print('Error fetching coupons: $e');
    }
  }
}
