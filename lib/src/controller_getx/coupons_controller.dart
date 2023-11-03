import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/coupons_model.dart';
import 'package:managerfoodandcoffee/src/utils/format_date.dart';

class CouponsController extends GetxController {
  var listCoupons = <Coupons>[].obs;

  Future<void> filterCoupons(String data) async {
    try {
      // Lắng nghe stream và cập nhật sản phẩm khi có dữ liệu mới
      FirestoreHelper.filterCoupons(data)
          .listen((List<Coupons> listDataCoupons) {
        if (listDataCoupons.isNotEmpty) {
          listCoupons.value = listDataCoupons;
        }
      });
    } catch (e) {
      print('Error fetching coupons: $e');
    }
  }
}
