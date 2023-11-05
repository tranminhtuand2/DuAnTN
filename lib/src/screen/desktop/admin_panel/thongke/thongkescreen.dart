import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';

class thongkeScreen extends StatefulWidget {
  const thongkeScreen({super.key});

  @override
  State<thongkeScreen> createState() => _thongkeScreenState();
}

class _thongkeScreenState extends State<thongkeScreen> {
  DateTime datefirt = DateTime.now();
  DateTime dateEnd = DateTime.now();
  String nameEmployer = "All";
  void _showdatefirt() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2033),
    ).then(
      (value) {
        setState(() {
          datefirt = value!;
        });
      },
    );
  }

  void _showdateEnd() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2033),
    ).then(
      (value) {
        setState(() {
          dateEnd = value!;
        });
      },
    );
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thống Kê Dữ Liệu"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            // color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _showdatefirt,
                  icon: Icon(Icons.date_range),
                ),
                Text(
                  datefirt.toString(),
                ),
                SizedBox(
                  width: 50,
                ),
                IconButton(
                  onPressed: _showdateEnd,
                  icon: Icon(Icons.date_range),
                ),
                Text(
                  datefirt.toString(),
                ),
                SizedBox(width: 20),
                //dropdown ten nhan vien
                StreamBuilder(
                  stream: FirestoreHelper.readInvoices(),
                  builder: (context, snapshot) {
                    List<DropdownMenuItem> tennhanvien = [];
                    if (snapshot.hasError) {
                      return Text("error");
                    }
                    if (snapshot.hasData) {
                      final employer = snapshot.data;
                      if (employer != null) {
                        tennhanvien.add(DropdownMenuItem(
                          value: "ALL",
                          child: Text("ALL"),
                        ));
                        for (var i = 0; i < employer.length; i++) {
                          var nhanvien = employer[i].nhanvien;
                          if (!tennhanvien
                              .any((item) => item.value == nhanvien)) {
                            tennhanvien.add(
                              DropdownMenuItem(
                                value: nhanvien,
                                child: Text(nhanvien),
                              ),
                            );
                          }
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: 50,
                          width: 200,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: DropdownButton(
                            value: nameEmployer,
                            underline: const SizedBox(),
                            isExpanded: true,
                            hint: const Text("Chọn tên nhân viên"),
                            items: tennhanvien,
                            onChanged: (value) {
                              setState(() {
                                nameEmployer = value;
                              });
                            },
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                //end dropdown
                Text(nameEmployer),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Tính toán"),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Tất Cả "),
                ),

                //dropdown end ten nhan vien
              ],
            ),
          ),
        ],
      ),
    );
  }
}
