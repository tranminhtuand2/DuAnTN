import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/intro_page/check_location_page.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class TableSelectionDialog extends StatefulWidget {
  final double vido;
  final double kinhdo;

  const TableSelectionDialog(
      {super.key, required this.vido, required this.kinhdo});

  @override
  State<TableSelectionDialog> createState() => _TableSelectionDialogState();
}

class _TableSelectionDialogState extends State<TableSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0), // Set contentPadding to 0
      content: StreamBuilder(
        stream: FirestoreHelper.readtable(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final tableController = Get.put(TableController());

            tableController.addTable(snapshot.data!);
            //Sắp xếp tên bàn theo thứ tự nhỏ đén lớn theo tên bàn
            int compareByTenBan(TableModel a, TableModel b) {
              return int.parse(a.tenban).compareTo(int.parse(b.tenban));
            }

            snapshot.data!.sort(compareByTenBan);

            tableController.addTable(snapshot.data!);
            return Container(
              width: double.maxFinite, // Match parent width

              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Số cột trong GridView
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: snapshot.data![index].isSelected!
                        ? null
                        : () => Get.dialog(
                              LocationCheckPage(
                                vido: widget.vido,
                                kinhdo: widget.kinhdo,
                                table: snapshot.data![index],
                              ),
                            ),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: snapshot.data![index].isSelected!
                                ? colorScheme(context)
                                    .onBackground
                                    .withOpacity(0.2)
                                : colorScheme(context).primary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            snapshot.data![index].tenban,
                            style: text(context).titleLarge,
                          ),
                        ),
                        snapshot.data![index].isSelected!
                            ? Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                left: 0,
                                child: Opacity(
                                  opacity: 0.3,
                                  child: Icon(
                                    Icons.close,
                                    size: 60,
                                    color: colorScheme(context).onBackground,
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
