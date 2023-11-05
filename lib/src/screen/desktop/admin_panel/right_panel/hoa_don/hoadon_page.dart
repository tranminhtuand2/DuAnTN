import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_dialog.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:managerfoodandcoffee/src/utils/size.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

import '../../../../../model/invoice_model.dart';

class HoaDonPage extends StatefulWidget {
  const HoaDonPage({super.key});

  @override
  State<HoaDonPage> createState() => _HoaDonPageState();
}

class _HoaDonPageState extends State<HoaDonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colorScheme(context).primary,
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: colorScheme(context).onPrimary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8)),
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
                            "Tổng số: ${hoadon.length}",
                            style: text(context).titleMedium,
                          ),
                          Text(
                            "Tổng thu: ${formatPrice(int.parse(tongtien.toString()))} đ",
                            style: text(context).titleMedium,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: SizedBox(
                      height: SizeConfig.screenHeight,
                      child: ListView(
                        children: [
                          DataTable(
                            columns: const [
                              DataColumn(
                                  label: Text('Xem chi tiết',
                                      overflow: TextOverflow.ellipsis)),
                              DataColumn(
                                  label: Text('Ngày tạo',
                                      overflow: TextOverflow.ellipsis)),
                              DataColumn(
                                  label: Text('Tên nhân viên',
                                      overflow: TextOverflow.ellipsis)),
                              DataColumn(
                                  label: Text('Thành tiền',
                                      overflow: TextOverflow.ellipsis)),
                              DataColumn(
                                  label: Text('Xoá',
                                      overflow: TextOverflow.ellipsis)),
                            ],
                            rows: hoadon.map((chitiethdindex) {
                              return DataRow(cells: [
                                DataCell(
                                  IconButton(
                                    onPressed: () {
                                      _showChiTietHoaDon(chitiethdindex);
                                    },
                                    icon: const Icon(Icons.receipt_long),
                                  ),
                                ),
                                DataCell(Text(chitiethdindex.date)),
                                DataCell(Text(chitiethdindex.nhanvien)),
                                DataCell(
                                  Text(
                                      "${formatPrice(int.parse(chitiethdindex.totalAmount.toString()))} đ"),
                                ),
                                DataCell(
                                  IconButton(
                                    onPressed: () {
                                      Get.dialog(MyDialog(
                                        title: "Xóa hóa đơn",
                                        content: const Text(
                                            'Bạn có muốn xóa hóa đơn hay không?'),
                                        labelLeadingButton: 'Xác nhận',
                                        labelTraillingButton: 'Hủy',
                                        onTapLeading: () {
                                          FirestoreHelper.deletehoadon(
                                              chitiethdindex);
                                          Navigator.pop(context);
                                        },
                                        onTapTrailling: () {
                                          Navigator.pop(context);
                                        },
                                      ));
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
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
      ),
    );
  }

  void _showChiTietHoaDon(Invoice hoadon) {
    Get.dialog(chitiethoadon(hoadon: hoadon));
  }
}

class chitiethoadon extends StatefulWidget {
  final Invoice hoadon;

  const chitiethoadon({super.key, required this.hoadon});

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Tên Cửa Hàng: Coffee Wind',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Nhân viên:${widget.hoadon.nhanvien} ',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Địa chỉ cửa hàng: 54 Thủ Khoa Huân'),
              const SizedBox(height: 10),
              Text(widget.hoadon.date),
              const SizedBox(height: 20),
              const Text(
                'Chi Tiết Hoá Đơn:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
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
      ),
    );
  }
}
