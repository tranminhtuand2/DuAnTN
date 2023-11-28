import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/text_form_field.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/chart_Model.dart';
import 'package:managerfoodandcoffee/src/model/thongke_model.dart';

import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/thong_ke/widget/barcharonday.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';

import '../../../../../model/giohanghd.dart';

class ThongKePage extends StatefulWidget {
  const ThongKePage({super.key});

  @override
  State<ThongKePage> createState() => _ThongKePageState();
}

class _ThongKePageState extends State<ThongKePage> {
  var datefirt = DateTime.now();
  var dateEnd = DateTime.now();
  String nameEmployer = "Tất cả";

  final controllerDateFirt = TextEditingController();
  final controllerDateEnd = TextEditingController();

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
          controllerDateFirt.text = value.toString();
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
          controllerDateEnd.text = value.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: colorScheme(context).onPrimary,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: InputField(
                          backgroundColor: colorScheme(context).primary,
                          readOnly: true,
                          onTap: () {
                            _showdatefirt();
                          },
                          controller: controllerDateFirt,
                          inputType: TextInputType.number,
                          labelText: 'Ngày bắt đầu',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Không để trống";
                            }
                            return null;
                          },
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: colorScheme(context).onBackground,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: InputField(
                          backgroundColor: colorScheme(context).primary,
                          readOnly: true,
                          onTap: controllerDateFirt.text.isNotEmpty
                              ? () {
                                  _showdateEnd();
                                }
                              : null,
                          controller: controllerDateEnd,
                          inputType: TextInputType.number,
                          labelText: 'Ngày kết thúc',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Không để trống";
                            }
                            return null;
                          },
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: colorScheme(context).onBackground,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: StreamBuilder(
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
                                  alignment: Alignment.center,
                                  value: "Tất cả",
                                  child: Text("Tất cả"),
                                ));
                                for (var i = 0; i < employer.length; i++) {
                                  var nhanvien = employer[i].nhanvien;
                                  if (!tennhanvien
                                      .any((item) => item.value == nhanvien)) {
                                    tennhanvien.add(
                                      DropdownMenuItem(
                                        alignment: Alignment.center,
                                        value: nhanvien,
                                        child: Text(nhanvien),
                                      ),
                                    );
                                  }
                                }
                              }
                              return Container(
                                height: 56,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                    color: colorScheme(context).primary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: DropdownButton(
                                  value: nameEmployer,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  hint: const Text("Chọn tên nhân viên"),
                                  items: tennhanvien,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        nameEmployer = value;
                                      },
                                    );
                                  },
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                //TỔNG DỮ LIỆU all VÀ nhân viên
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        height: MediaQuery.sizeOf(context).height * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.withOpacity(0.3),
                        ),
                        child: StreamBuilder(
                          stream: nameEmployer == "Tất cả"
                              ? FirestoreHelper.readThongke()
                              : FirestoreHelper.readThongkenhanvien(
                                  nameEmployer.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child:
                                      Text('Không dữ liệu : "$nameEmployer"'));
                            }
                            if (snapshot.hasError) {
                              print("Error: ${snapshot.error}");
                              return const Center(
                                  child: Text("Lỗi kết nối dữ liệu"));
                            }
                            if (snapshot.hasData) {
                              final thongkenhanvien = snapshot.data;
                              double tongtien = 0;
                              for (var i = 0;
                                  i < thongkenhanvien!.length;
                                  i++) {
                                tongtien += thongkenhanvien[i].total!;
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Tổng tiền đã bán được:"),
                                    const SizedBox(height: 6),
                                    Text(
                                        "$nameEmployer: ${formatPrice(int.parse(tongtien.toString()))} VNĐ"),
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
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        height: MediaQuery.sizeOf(context).height * 0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green.withOpacity(0.3)),
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
                                child: Text(
                                    'Không có dữ liệu: Từ ngày ${datefirt.day}/${datefirt.month} - đến ngày ${dateEnd.day}/${dateEnd.month}'),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text("Lỗi kết nối dữ liệu");
                            }
                            if (snapshot.hasData) {
                              final thongkeBydate = snapshot.data;
                              double tongtien = 0;
                              for (var i = 0; i < thongkeBydate!.length; i++) {
                                tongtien += thongkeBydate[i].total!;
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Thống kê tất cả:"),
                                    Text(
                                        "Từ ngày ${datefirt.day}/${datefirt.month} đến ngày ${dateEnd.day}/${dateEnd.month}:"),
                                    Text(
                                        "${formatPrice(int.parse(tongtien.toString()))} VNĐ"),
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
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        height: MediaQuery.sizeOf(context).height * 0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.purple.withOpacity(0.3)),
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
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Thống kê theo tên:"),
                                    Text(
                                      '$nameEmployer: Từ ngày "${datefirt.day}/${datefirt.month} - đến ngày ${dateEnd.day}/${dateEnd.month} 0 VNĐ',
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text("Lỗi kết nối dữ liệu");
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
                                    const Text("Thống kê theo tên:"),
                                    Text(
                                        "$nameEmployer: Từ ngày  ${datefirt.day}/${datefirt.month} đến ngày ${dateEnd.day}/${dateEnd.month}:"),
                                    Text(
                                        '${formatPrice(int.parse(tongtien.toString()))} VNĐ')
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
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                  color: colorScheme(context).onPrimary,
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blueGrey.withOpacity(0.5),
                ),
                // height: 400,
                // width: double.infinity,
                child: StreamBuilder(
                  stream: FirestoreHelper.readThongkeByDate(datefirt, dateEnd),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Vui lòng chọn ngày bắt đầu.'));
                    }
                    if (snapshot.hasError) {
                      return const Text("Lỗi kết nối dữ liệu");
                    }
                    if (snapshot.hasData) {
                      List<ProductSalesData> productSalesDataList = [];
                      List<ThongKe>? thongKeData = snapshot.data;
                      for (ThongKe thongKe in thongKeData!) {
                        for (GioHang1 product in thongKe.products) {
                          int existingProductIndex =
                              productSalesDataList.indexWhere(
                                  (data) => data.productName == product.tensp);

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
            ),
          )
          // END TỔNG DỮ LIỆU all VÀ nhân viên
        ],
      ),
    );
  }
}
