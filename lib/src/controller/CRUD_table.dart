import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:progress_dialog2/progress_dialog2.dart';

class Crud_table extends StatefulWidget {
  const Crud_table({super.key});

  @override
  State<Crud_table> createState() => _Crud_tableState();
}

class _Crud_tableState extends State<Crud_table> {
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
    TextEditingController txtban = TextEditingController();
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      title: const Text("Thêm bàn"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                // for below version 2 use this
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: txtban,
              decoration: InputDecoration(
                labelText: "nhập số bàn",
                hintText: "nhập số bàn",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      pr.show();
                      try {
                        await FirestoreHelper.createdtable(
                            TableModel(tenban: txtban.text));
                        Navigator.of(context).pop();
                      } catch (e) {
                      } finally {
                        pr.hide();
                      }
                    },
                    child: Text("Tạo bàn")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
