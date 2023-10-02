import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/textform.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/danhmuc_model.dart';
import 'package:progress_dialog2/progress_dialog2.dart';

class addDanhmuc_dialog extends StatefulWidget {
  const addDanhmuc_dialog({super.key});

  @override
  State<addDanhmuc_dialog> createState() => _addDanhmuc_dialogState();
}

class _addDanhmuc_dialogState extends State<addDanhmuc_dialog> {
  TextEditingController textdanhmuc = TextEditingController();
  late ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context);
    pr.style(
      message: 'Đang tải lên...',
      progressWidget: CircularProgressIndicator(),
      maxProgress: 100.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      title: const Text("Thêm mới danh mục"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            textformfield(
                hintext: "danh mục",
                labeltext: "danh mục",
                icon: Icon(Icons.abc),
                regExp: "",
                isempty: "không được để danh mục rỗng",
                wrongtype: "có ký tự đặc biệt",
                textcontroller: textdanhmuc,
                hint: false),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  pr.show();
                  await FirestoreHelper.createdanhmuc(
                          danhmucModel(tendanhmuc: textdanhmuc.text))
                      .then((value) => Navigator.of(context).pop());
                } catch (e) {
                  print('Lỗi khi xóa hình ảnh: $e');
                } finally {
                  pr.hide();
                }
              },
              child: Text("tạo danh mục"),
            ),
          ],
        ),
      ),
    );
  }
}
