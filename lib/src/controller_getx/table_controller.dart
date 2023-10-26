import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';

class TableController extends GetxController {
  var tables = <TableModel>[].obs;
  var tableName = '#'.obs; // Không được để trống

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

    print("bool check: ${table.isSelected}");
    await FirestoreHelper.updatetable(table);
  }
}
