import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';
import 'package:managerfoodandcoffee/src/utils/size.dart';

import '../../../../../model/Invoice_model.dart';

class hoaDonScreen extends StatefulWidget {
  const hoaDonScreen({super.key});

  @override
  State<hoaDonScreen> createState() => _hoaDonScreenState();
}

class _hoaDonScreenState extends State<hoaDonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOÁ ĐƠN CHECK"),
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        color: Colors.amber,
        child: StreamBuilder<List<Invoice>>(
          stream: FirestoreHelper.readInvoices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("lỗi:$snapshot.error"),
              );
            }
            if (snapshot.hasData) {
              List<Invoice>? hoadon = snapshot.data;
              double tongtien = 0;
              for (var i = 0; i < hoadon!.length; i++) {
                tongtien += hoadon[i].totalAmount;
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "tổng hoá đơn:${hoadon.length}",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text("tổng tiền: ${tongtien}")
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: SizeConfig.screenHeight,
                    child: ListView(
                      children: [
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Xoá')),
                            DataColumn(label: Text('Chi tiêt')),
                            DataColumn(label: Text('Ngày/Tháng/Năm')),
                            DataColumn(label: Text('Tên Nhân Viên')),
                            DataColumn(label: Text('Tiền Hoá đơn')),
                          ],
                          rows: hoadon.map((chitiethdindex) {
                            return DataRow(cells: [
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    FirestoreHelper.deletehoadon(
                                        chitiethdindex);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    _showChiTietHoaDon(chitiethdindex);
                                    // Get.dialog(chitiethoadon(
                                    //   hoadon: chitiethdindex,
                                    // ));
                                  },
                                  icon: Icon(Icons.receipt_long),
                                ),
                              ),
                              DataCell(Text(chitiethdindex.date)),
                              DataCell(Text(chitiethdindex.nhanvien)),
                              DataCell(
                                  Text(chitiethdindex.totalAmount.toString())),
                            ]);
                          }).toList(),
                        )
                      ],
                    ),
                  ))
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _showChiTietHoaDon(Invoice hoadon) {
    Get.dialog(chitiethoadon(hoadon: hoadon));
  }
}

class chitiethoadon extends StatefulWidget {
  final Invoice hoadon;

  chitiethoadon({super.key, required this.hoadon});

  @override
  State<chitiethoadon> createState() => _chitiethoadonState();
}

class _chitiethoadonState extends State<chitiethoadon> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.hoadon.id.toString()),
      content: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth / 2,
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
              'Nhân viên:${widget.hoadon.nhanvien} ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Địa chỉ cửa hàng: 54 Thủ Khoa Huân'),
            SizedBox(height: 10),
            Text(widget.hoadon.date),
            SizedBox(height: 20),
            Text(
              'Chi Tiết Hoá Đơn:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: ListView(
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('tên sản phẩm')),
                        DataColumn(label: Text('số lượng')),
                        DataColumn(label: Text('giá')),
                        DataColumn(label: Text('tổng giá')),
                      ],
                      rows: widget.hoadon.products.map((chitiethdindex) {
                        return DataRow(cells: [
                          DataCell(Text(chitiethdindex.tensp.toString())),
                          DataCell(Text(chitiethdindex.soluong.toString())),
                          DataCell(Text(chitiethdindex.giasp.toString())),
                          DataCell(Text(
                              (chitiethdindex.soluong * chitiethdindex.giasp)
                                  .toString())),
                        ]);
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
