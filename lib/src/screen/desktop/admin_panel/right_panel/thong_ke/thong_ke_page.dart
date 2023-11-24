import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/chart_Model.dart';
import 'package:managerfoodandcoffee/src/model/thongke_model.dart';

import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/thong_ke/widget/barcharonday.dart';

import '../../../../../model/giohanghd.dart';

class ThongKePage extends StatefulWidget {
  const ThongKePage({super.key});

  @override
  State<ThongKePage> createState() => _ThongKePageState();
}

class _ThongKePageState extends State<ThongKePage> {
  var datefirt = DateTime.now();
  var dateEnd = DateTime.now();
  String nameEmployer = "ALL";

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thống Kê Dữ Liệu"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              // color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _showdatefirt,
                    icon: const Icon(Icons.date_range),
                  ),
                  Text(datefirt.toString()),
                  const SizedBox(
                    width: 50,
                  ),
                  IconButton(
                    onPressed: _showdateEnd,
                    icon: const Icon(Icons.date_range),
                  ),
                  Text(dateEnd.toString()),
                  const SizedBox(width: 20),
                  //dropdown ten nhan vien
                  StreamBuilder(
                    stream: FirestoreHelper.readInvoices(),
                    builder: (context, snapshot) {
                      List<DropdownMenuItem> tennhanvien = [];
                      if (snapshot.hasError) {
                        return const Text("error");
                      }
                      if (snapshot.hasData) {
                        final employer = snapshot.data;
                        if (employer != null) {
                          tennhanvien.add(const DropdownMenuItem(
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
                            height: 60,
                            width: 200,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                border:
                                    Border.all(color: Colors.black, width: 1),
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  //end dropdown
                  Text(nameEmployer),
                  const SizedBox(
                    width: 10,
                  ),

                  //dropdown end ten nhan vien
                ],
              ),
            ),
          ),
          //TỔNG DỮ LIỆU all VÀ nhân viên
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 100,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue,
                  ),
                  child: StreamBuilder(
                    stream: nameEmployer == "ALL"
                        ? FirestoreHelper.readThongke()
                        : FirestoreHelper.readThongkenhanvien(
                            nameEmployer.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('Không dữ liệu : "$nameEmployer"'));
                      }
                      if (snapshot.hasError) {
                        print("Error: " + snapshot.error.toString());
                        return Center(child: const Text("lỗi kết nối dữ liệu"));
                      }
                      if (snapshot.hasData) {
                        final thongkenhanvien = snapshot.data;
                        double tongtien = 0;
                        for (var i = 0; i < thongkenhanvien!.length; i++) {
                          tongtien += thongkenhanvien[i].total!;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Tổng tiền đã bán được"),
                              Text("$nameEmployer:$tongtien VNĐ"),
                            ],
                          )),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                Container(
                  height: 100,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green),
                  child: StreamBuilder(
                    stream:
                        FirestoreHelper.readThongkeByDate(datefirt, dateEnd),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                              'Không có dữ liệu : "${datefirt.day}/${datefirt.month} - ${dateEnd.day}/${dateEnd.month}'),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text("lỗi kết nối dữ liệu");
                      }
                      if (snapshot.hasData) {
                        final thongkeBydate = snapshot.data;
                        double tongtien = 0;
                        for (var i = 0; i < thongkeBydate!.length; i++) {
                          tongtien += thongkeBydate[i].total!;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("thống kê ALL"),
                                Text(
                                    " ${datefirt.day}/${datefirt.month} đến ngày ${dateEnd.day}/${dateEnd.month} : $tongtien VNĐ"),
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
                ),
                Container(
                  height: 100,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.purple),
                  child: StreamBuilder(
                    stream:
                        FirestoreHelper.readThongkeByDate(datefirt, dateEnd),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Thống kê theo tên"),
                              Text(
                                '$nameEmployer: "${datefirt.day}/${datefirt.month} - ${dateEnd.day}/${dateEnd.month} 0 VNĐ',
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text("lỗi kết nối dữ liệu");
                      }
                      if (snapshot.hasData) {
                        final thongkeBydate = snapshot.data;
                        double tongtien = 0;
                        for (var i = 0; i < thongkeBydate!.length; i++) {
                          if (thongkeBydate[i].nhanvien == nameEmployer) {
                            tongtien += thongkeBydate[i].total!;
                          }
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("thống kê theo tên"),
                              Text(
                                  "$nameEmployer: từ ngày  ${datefirt.day}/${datefirt.month} đến ngày ${dateEnd.day}/${dateEnd.month} : $tongtien VND"),
                            ],
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueGrey,
                        ),
                        height: 400,
                        width: double.infinity,
                        child: StreamBuilder(
                          stream: FirestoreHelper.readThongkeByDate(
                              datefirt, dateEnd),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child: const Text(
                                      'vui lòng chọn ngày muốn xem'));
                            }
                            if (snapshot.hasError) {
                              return const Text("lỗi kết nối dữ liệu");
                            }
                            if (snapshot.hasData) {
                              List<ProductSalesData> productSalesDataList = [];
                              List<ThongKe>? thongKeData = snapshot.data;
                              for (ThongKe thongKe in thongKeData!) {
                                for (GioHang1 product in thongKe.products) {
                                  int existingProductIndex =
                                      productSalesDataList.indexWhere((data) =>
                                          data.productName == product.tensp);

                                  if (existingProductIndex != -1) {
                                    productSalesDataList[existingProductIndex]
                                        .totalSales += product.soluong;
                                  } else {
                                    productSalesDataList.add(ProductSalesData(
                                      productName: product.tensp,
                                      totalSales: product.soluong,
                                    ));
                                  }
                                }
                              }
                              return SalesChart(
                                  productSalesDataList: productSalesDataList);
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
          // END TỔNG DỮ LIỆU all VÀ nhân viên
        ],
      ),
    );
  }
}
