import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_dialog.dart';
import 'package:managerfoodandcoffee/src/controller_getx/categorry_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/danhmuc_model.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class CRUDCategoriesTab extends StatefulWidget {
  const CRUDCategoriesTab({super.key});

  @override
  State<CRUDCategoriesTab> createState() => _CRUDCategoriesTabState();
}

class _CRUDCategoriesTabState extends State<CRUDCategoriesTab> {
  final categoriesController = Get.put(CategoryController());
  final textEditControllerCategories = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late DanhMuc? danhMucEdit;
  bool isUpdateCatigories = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Form(
                key: formKey,
                child: InputField(
                  controller: textEditControllerCategories,
                  inputType: TextInputType.text,
                  labelText: 'Thêm danh mục',
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: colorScheme(context).onBackground,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng điền tên danh mục";
                    }
                    return null;
                  },
                  textInputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'[\[\]!@#\$%^&*(){}/:";|_=+]')),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MyButton(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    if (isUpdateCatigories &&
                        textEditControllerCategories.text.isNotEmpty &&
                        danhMucEdit != null) {
                      updateCategory(danhMucEdit!);
                      return;
                    }
                    createCategory();
                  }
                },
                backgroundColor: colorScheme(context).inversePrimary,
                height: 60,
                text: Text(
                  isUpdateCatigories &&
                          textEditControllerCategories.text.isNotEmpty
                      ? "SỬA"
                      : 'THÊM',
                  style: TextStyle(color: colorScheme(context).tertiary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: categoriesController.categories.isNotEmpty
              ? Obx(
                  () => ListView.builder(
                    itemCount: categoriesController.categories.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Bỏ qua index thứ 0
                        return Container(); // Hoặc widget trống không hiển thị gì
                      } else {
                        // Hiển thị giá trị từ index 1 trở đi

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 20),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme(context).onPrimary),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                categoriesController
                                    .categories[index].tendanhmuc
                                    .toUpperCase(),
                                style: text(context).titleSmall,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: colorScheme(context)
                                            .onBackground
                                            .withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isUpdateCatigories = true;
                                            danhMucEdit = categoriesController
                                                .categories[index];
                                            textEditControllerCategories.text =
                                                categoriesController
                                                    .categories[index]
                                                    .tendanhmuc
                                                    .toLowerCase();
                                          });
                                        },
                                        icon: Icon(
                                          Icons.mode_edit_outline_rounded,
                                          color:
                                              colorScheme(context).background,
                                        )),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: colorScheme(context)
                                            .onBackground
                                            .withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: IconButton(
                                        onPressed: () {
                                          deleteCategory(
                                            context: context,
                                            idDanhmuc: categoriesController
                                                .categories[index].iddanhmuc!,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete_outline_outlined,
                                          color:
                                              colorScheme(context).background,
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  void createCategory() async {
    await FirestoreHelper.createdanhmuc(
        DanhMuc(tendanhmuc: textEditControllerCategories.text));
    textEditControllerCategories.text = "";
  }

  void updateCategory(DanhMuc danhMuc) async {
    await FirestoreHelper.updatedanhmuc(DanhMuc(
        tendanhmuc: textEditControllerCategories.text,
        iddanhmuc: danhMuc.iddanhmuc));
    setState(() {
      isUpdateCatigories = false;
      danhMucEdit = null;
    });
    textEditControllerCategories.text = "";
  }

  void deleteCategory(
      {required BuildContext context, required String idDanhmuc}) async {
    showDialog(
      context: context,
      builder: (context) => MyDialog(
        onTapLeading: () async {
          await FirestoreHelper.deletedanhmuc(idDanhmuc);
          textEditControllerCategories.text = "";
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        onTapTrailling: () {
          Navigator.of(context).pop();
        },
        title: 'Xóa?',
        content: 'Bạn chắc chắn muốn xóa?',
      ),
    );
  }
}
