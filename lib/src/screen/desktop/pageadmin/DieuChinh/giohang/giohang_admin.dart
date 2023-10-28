import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/model/Invoice_model.dart';
import 'package:managerfoodandcoffee/src/model/table_model.dart';
import 'package:managerfoodandcoffee/src/utils/size.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';

import '../../../../../model/card_model.dart';

class giohang_admin extends StatefulWidget {
  final String tenban;
  const giohang_admin({
    super.key,
    required this.tenban,
  });

  @override
  State<giohang_admin> createState() => _giohang_adminState();
}

class _giohang_adminState extends State<giohang_admin> {
  bool thanhtoan = false;
  int soluongmon = 0;
  int tongtien = 0;

  List<GioHang> products = [];
  @override
  void initState() {
    super.initState();
    thanhtoan = false;
    products = [];
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    return Scaffold(
        appBar: AppBar(
          title: Text("BÀN SÔ ${widget.tenban}"),
        ),
        body: Row(
          children: [
            Container(
              width: SizeConfig.screenWidth / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 2,
                  )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text("Thông tin Bàn số ${widget.tenban}"),
                    ),
                    StreamBuilder(
                      stream: FirestoreHelper.readgiohang(widget.tenban),
                      builder: (context, snapshot) {
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
                        if (snapshot.hasData) {
                          final giohang = snapshot.data;

                          return SizedBox(
                            width: double.infinity,
                            height: SizeConfig.screenHeight / 1.2,
                            child: ListView.builder(
                              itemCount: giohang!.length,
                              itemBuilder: (context, index) {
                                final giohangindex = giohang[index];
                                return Container(
                                  margin: EdgeInsets.all(10),
                                  width: SizeConfig.screenWidth / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green[200],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width:
                                                getProportionateScreenWidth(50),
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF5F6F9),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: cacheNetWorkImage(
                                                giohangindex.hinhanh,
                                                width: 100,
                                                height: 100,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                getProportionateScreenWidth(5),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                giohangindex.tensp,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text:
                                                      " ${giohangindex.giasp}",
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            "x ${giohangindex.soluong}")
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "  VND: ${giohangindex.soluong * giohangindex.giasp}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                FirestoreHelper.deletegiohang(
                                                    giohangindex,
                                                    widget.tenban);
                                              },
                                              icon: Icon(Icons.delete))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: FirestoreHelper.readgiohang(widget.tenban),
                      builder: (context, snapshot) {
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
                        if (snapshot.hasData) {
                          final giohang = snapshot.data;
                          soluongmon = 0;
                          for (var i = 0; i < giohang!.length; i++) {
                            soluongmon += giohang[i].soluong;
                          }
                          return Text("số lượng : $soluongmon");
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: FirestoreHelper.readtinhtrang(widget.tenban),
                      builder: (context, snapshot) {
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
                        if (snapshot.hasData) {
                          final tinhtrangthanhtoan = snapshot.data;
                          for (var i = 0; i < tinhtrangthanhtoan!.length; i++) {
                            if (tinhtrangthanhtoan[i].idtinhtrang ==
                                widget.tenban) {
                              thanhtoan = true;

                              break;
                            }
                          }
                          return Center(
                            child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 50,
                                child: thanhtoan == false
                                    ? const Text(
                                        "vui lòng chờ khách hàng chọn món hoàn tất")
                                    :
                                    // InkWell(
                                    //     onTap: () {
                                    //       FirestoreHelper.updatetinhtrang(
                                    //           tinhtrangTT(
                                    //               trangthai: "xacnhan",
                                    //               idtinhtrang: widget.tenban),
                                    //           widget.tenban);

                                    //       print(widget.tenban);
                                    //     },
                                    //     child: const Text("xác nhận đợn hàng"),
                                    //   ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            child: Text(
                                                "Xác Nhận Đơn hàng & Tạm Tính"),
                                          ),
                                        ],
                                      )),
                          );
                        }
                        return const SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: Center(
                            child: Row(
                              children: [
                                Text("vui long chờ khách hàng order xong  "),
                                CircularProgressIndicator()
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                  width: SizeConfig.screenWidth / 2,
                  height: SizeConfig.screenHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Tên Cửa Hàng: Coffee Wind',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'số bàn: ${widget.tenban}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Địa chỉ cửa hàng: 54 Thủ Khoa Huân'),
                      SizedBox(height: 10),
                      Text(DateTime.now().toString()),
                      SizedBox(height: 20),
                      Text(
                        'Chi Tiết Hoá Đơn:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 400,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.amber,
                            ),
                            child: StreamBuilder(
                              stream:
                                  FirestoreHelper.readgiohang(widget.tenban),
                              builder: (context, snapshot) {
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
                                if (snapshot.hasData) {
                                  final giohanghd = snapshot.data;
                                  tongtien = 0;
                                  products = [];
                                  for (var i = 0; i < giohanghd!.length; i++) {
                                    tongtien += giohanghd[i].soluong *
                                        giohanghd[i].giasp;
                                  }
                                  for (var i = 0; i < giohanghd.length; i++) {
                                    products.add(GioHang(
                                        tensp: giohanghd[i].tensp,
                                        giasp: giohanghd[i].giasp,
                                        soluong: giohanghd[i].soluong,
                                        hinhanh: giohanghd[i].hinhanh));
                                  }
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey,
                                          ),
                                          child: ListView(
                                            children: [
                                              DataTable(
                                                columns: const [
                                                  DataColumn(
                                                      label:
                                                          Text('tên sản phẩm')),
                                                  DataColumn(
                                                      label: Text('số lượng')),
                                                  DataColumn(
                                                      label: Text('giá')),
                                                  DataColumn(
                                                      label: Text('tổng giá')),
                                                ],
                                                rows: giohanghd
                                                    .map((chitiethdindex) {
                                                  return DataRow(cells: [
                                                    DataCell(Text(
                                                        chitiethdindex.tensp)),
                                                    DataCell(Text(chitiethdindex
                                                        .soluong
                                                        .toString())),
                                                    DataCell(Text(chitiethdindex
                                                        .giasp
                                                        .toString())),
                                                    DataCell(Text(
                                                        (chitiethdindex
                                                                    .soluong *
                                                                chitiethdindex
                                                                    .giasp)
                                                            .toString())),
                                                  ]);
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Tổng tiền: $tongtien",
                                      ),
                                    ],
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      // Container(
                      //   height: 150,
                      //   color: Colors.blue,
                      //   child: Column(
                      //     children: [
                      //       Row(),
                      //     ],
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          Invoice newhoadon = Invoice(
                              products: products,
                              date: formattedDate,
                              totalAmount: tongtien);
                          print(tongtien);
                          print(formattedDate);
                          // print(TimeOfDay.fromDateTime(DateTime.now()));
                          FirestoreHelper.createhoadon(newhoadon);
                          FirestoreHelper.deleteAllgiohang(widget.tenban);
                          FirestoreHelper.updatetable(TableModel(
                              tenban: widget.tenban,
                              isSelected: false,
                              maban: widget.tenban));
                        },
                        child: SizedBox(
                          height: 50,
                          child: Text("thanh toán"),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ));
  }
}
