import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';

class TableController extends GetxController {
  var tables = <TableModel>[].obs;
  var tableName = '#'.obs; // Không được để trống

  var isExpanded = false.obs; //biến để đóng mở tab bên phải table page

  var totalPrice = 0.0.obs;

  var isAddCoupons = false.obs;

  void updateTotalPrice(double price) {
    totalPrice.value = price;
  }

  Future<void> addTable(List<TableModel> lists) async {
    if (lists.isNotEmpty) {
      //Sắp xếp tên bàn theo thứ tự nhỏ đén lớn theo tên bàn
      int compareByTenBan(TableModel a, TableModel b) {
        return int.parse(a.tenban).compareTo(int.parse(b.tenban));
      }

      lists.sort(compareByTenBan);

      tables.value = lists;
    }
  }

  Future<void> updateSelectedTable(TableModel table) async {
    table.isSelected = !table.isSelected!;

    print("bool check: ${table.isSelected}, tabel: ${table.tenban}");

    await FirestoreHelper.updatetable(table);
  }
}
