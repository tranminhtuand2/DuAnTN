import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_dialog.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/controller_getx/table_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';
import 'package:progress_dialog2/progress_dialog2.dart';

class CreateTable extends StatefulWidget {
  const CreateTable({super.key});

  @override
  State<CreateTable> createState() => _CreateTableState();
}

class _CreateTableState extends State<CreateTable> {
  @override
  Widget build(BuildContext context) {
    final controllerTableName = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: colorScheme(context).onPrimary,
      title: const Text("Thêm bàn"),
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
            return Container(
              width: 500, // Match parent width

              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Form(
                              key: formKey,
                              child: InputField(
                                controller: controllerTableName,
                                inputType: TextInputType.number,
                                labelText: 'Tên bàn',
                                // maxLength: 3,
                                prefixIcon: Icon(
                                  Icons.table_bar,
                                  color: colorScheme(context).onBackground,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Không để trống";
                                  }
                                  if (int.parse(value) > 100 ||
                                      int.parse(value) == 0) {
                                    return "Số bàn dưới 100";
                                  }
                                  return null;
                                },
                                textInputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]+')),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: MyButton(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  for (var element in tableController.tables) {
                                    if (int.parse(element.tenban) ==
                                        int.parse(controllerTableName.text)) {
                                      showCustomSnackBar(
                                          title: "Lỗi",
                                          message: "Tên bàn đã tồn tại!!",
                                          type: Type.error);
                                      return;
                                    }
                                  }
                                  try {
                                    await FirestoreHelper.createdtable(
                                        TableModel(
                                            tenban: controllerTableName.text));
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              backgroundColor:
                                  colorScheme(context).inversePrimary,
                              height: 54,
                              text: Text(
                                'THÊM BÀN',
                                style: TextStyle(
                                    color: colorScheme(context).tertiary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Số cột trong GridView
                      ),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(12),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme(context)
                                    .onBackground
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                snapshot.data![index].tenban,
                                style: text(context).titleLarge,
                              ),
                            ),
                            Visibility(
                              visible: !snapshot.data![index].isSelected!,
                              child: Positioned(
                                right: 2,
                                top: 2,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => MyDialog(
                                        onTapLeading: () async {
                                          await FirestoreHelper.deletetable(
                                              snapshot.data![index]);
                                          Navigator.pop(context);
                                        },
                                        onTapTrailling: () {
                                          Navigator.of(context).pop();
                                        },
                                        title: 'Xóa?',
                                        content: 'Bạn chắc chắn muốn xóa?',
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        colorScheme(context).primary,
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
