import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/check_location_page.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class TableSelectionDialog extends StatelessWidget {
  final List<int> tableNumbers;
  final double vido;
  final double kinhdo;

  const TableSelectionDialog(
      {super.key,
      required this.tableNumbers,
      required this.vido,
      required this.kinhdo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0), // Set contentPadding to 0
      content: Container(
        width: double.maxFinite, // Match parent width

        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: tableNumbers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Số cột trong GridView
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Get.dialog(
                LocationCheckPage(
                  vido: vido,
                  kinhdo: kinhdo,
                  tenban: tableNumbers[index].toString(),
                ),
              ),
              child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme(context).primary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tableNumbers[index].toString(),
                    style: text(context).titleLarge,
                  )),
            );
          },
        ),
      ),
    );
  }
}
