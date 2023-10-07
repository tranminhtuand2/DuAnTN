import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/textform.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/danhmuc_model.dart';
import 'package:progress_dialog2/progress_dialog2.dart';

class Editdanhmuc_dialog extends StatefulWidget {
  final danhmucModel danhmuc;
  const Editdanhmuc_dialog({
    super.key,
    required this.danhmuc,
  });

  @override
  State<Editdanhmuc_dialog> createState() => _Editdanhmuc_dialogState();
}

class _Editdanhmuc_dialogState extends State<Editdanhmuc_dialog> {
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
                  await FirestoreHelper.updatedanhmuc(danhmucModel(
                          tendanhmuc: textdanhmuc.text,
                          iddanhmuc: widget.danhmuc.iddanhmuc))
                      .then((value) => navigator!.pop(context));
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
