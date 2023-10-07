import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/screen/mobile/checklocation/pagechecklocation.dart';

class pagegioithieu extends StatefulWidget {
  const pagegioithieu({super.key});

  @override
  State<pagegioithieu> createState() => _pagegioithieuState();
}

class _pagegioithieuState extends State<pagegioithieu> {
  double? vido;
  double? kinhdo;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: Center(
          child: Column(
            children: [
              Lottie.asset(
                "assets/images/location.json",
                animate: true,
                height: 200,
                width: 200,
              ),
              const Text("Vui lòng nhấn vào nút kiểm tra"),
              StreamBuilder(
                stream: FirestoreHelper.readmap(),
                builder: (context, snapshot) {
                  final maplocation = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("đã có lỗi xảy ra"),
                    );
                  }
                  if (snapshot.hasData) {
                    if (maplocation != null) {
                      vido = maplocation[0].vido;
                      kinhdo = maplocation[0].kinhdo;
                    }
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text("lấy địa chỉ thành công "),
                            const SizedBox(
                              height: 20,
                            ),
                            StreamBuilder(
                              stream: FirestoreHelper.readtable(),
                              builder: (context, snapshot) {
                                final listtenban = snapshot.data;
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text("lỗi"),
                                  );
                                }
                                List<DropdownMenuItem> tenbanItem = [];
                                if (snapshot.hasData) {
                                  if (listtenban != null) {
                                    for (var i = 0;
                                        i < listtenban.length;
                                        i++) {
                                      tenbanItem.add(
                                        DropdownMenuItem(
                                          value: listtenban[i].tenban,
                                          child: Text(listtenban[i].tenban),
                                        ),
                                      );
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: DropdownButton(
                                        value: selectedValue,
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        hint: const Text("vui lòng chọn bàn"),
                                        items: tenbanItem,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValue = value;
                                            print(selectedValue);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }

                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedValue != null) {
                    print("kinh do+$kinhdo");
                    print("vido do+$vido");
                    Get.dialog(
                      LocationCheckPage(
                        vido: vido!,
                        kinhdo: kinhdo!,
                        tenban: selectedValue.toString(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('vui long nhap ten ban'),
                      ),
                    );
                  }
                },
                child: const Text("kiểm tra"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
