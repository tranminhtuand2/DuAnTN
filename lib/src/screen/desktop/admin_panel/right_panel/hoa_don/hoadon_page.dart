import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_dialog.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebasestore_helper.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/right_panel/hoa_don/PDF/print_pdf.dart';
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
  final isShowFirst = ValueNotifier(false);
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Invoice>>(
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
            hoadon!.sort(
              (a, b) => b.timeStamp.millisecondsSinceEpoch
                  .compareTo(a.timeStamp.millisecondsSinceEpoch),
            );
            double tongtien = 0;
            for (var i = 0; i < hoadon.length; i++) {
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
                        "TỔNG SỐ: ${hoadon.length} HÓA ĐƠN",
                        style: text(context)
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "TỔNG THU: ${formatPrice(int.parse(tongtien.toString()))} đ",
                        style: text(context)
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text('ID:'.toUpperCase(),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text('Bàn:'.toUpperCase(),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text('Ngày tạo:'.toUpperCase(),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text('Tên nhân viên:'.toUpperCase(),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text('Thành tiền:'.toUpperCase(),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: hoadon.length,
                    itemBuilder: (context, index) {
                      final hoaDonIndex = hoadon[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: colorScheme(context).primary,
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: isShowFirst,
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  isShowFirst.value = !isShowFirst.value;
                                  selectedIndex = index;
                                });
                              },
                              child: Builder(builder: (context) {
                                return Column(
                                  children: [
                                    rowTable(hoaDonIndex),
                                    value && selectedIndex == index
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                top: 20, bottom: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: colorScheme(context)
                                                  .onPrimary,
                                            ),
                                            child: Stack(
                                              children: [
                                                // Positioned(
                                                //     top: 6,
                                                //     right: 44,
                                                //     child: IconButton(
                                                //         onPressed: () {},
                                                //         icon: const Icon(
                                                //             Icons.print,
                                                //             size: 22))),
                                                Positioned(
                                                    top: 6,
                                                    right: 6,
                                                    child: IconButton(
                                                        onPressed: () async {
                                                          createPDFAndDownload(
                                                              hoaDonIndex);
                                                        },
                                                        icon: const Icon(
                                                            Icons.download,
                                                            size: 24))),
                                                Column(
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Chi Tiết Hoá Đơn:'
                                                          .toUpperCase(),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    SizedBox(
                                                      width: 700,
                                                      height: 200,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: DataTable(
                                                          columns: [
                                                            const DataColumn(
                                                                label: Text(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    'Tên sản phẩm:')),
                                                            const DataColumn(
                                                                label: Text(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    'Số lượng:')),
                                                            const DataColumn(
                                                                label: Text(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    'Đơn giá:')),
                                                            const DataColumn(
                                                                label: Text(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    'Tổng tiền:')),
                                                            DataColumn(
                                                              label: Text(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  hoaDonIndex.persentCoupons !=
                                                                          null
                                                                      ? '-${hoaDonIndex.persentCoupons ?? ''}%'
                                                                      : ""),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  hoaDonIndex.persentCoupons !=
                                                                          null
                                                                      ? "${formatPrice(int.parse(hoaDonIndex.totalAmountCoupons.toString()))} đ"
                                                                      : ""),
                                                            ),
                                                          ],
                                                          rows: hoaDonIndex
                                                              .products
                                                              .map(
                                                                  (chitiethdindex) {
                                                            return DataRow(
                                                                cells: [
                                                                  DataCell(Text(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      chitiethdindex
                                                                          .tensp)),
                                                                  DataCell(Text(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      chitiethdindex
                                                                          .soluong
                                                                          .toString())),
                                                                  DataCell(Text(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      "${formatPrice(int.parse(chitiethdindex.giasp.toString()))} đ")),
                                                                  DataCell(Text(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      "${formatPrice(chitiethdindex.soluong * chitiethdindex.giasp)} đ")),
                                                                  const DataCell(
                                                                      Text("")),
                                                                  const DataCell(
                                                                      Text("")),
                                                                ]);
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget rowTable(Invoice hoaDonIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Text(hoaDonIndex.id ?? '', overflow: TextOverflow.ellipsis),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text("Bàn ${hoaDonIndex.tableName}",
                overflow: TextOverflow.ellipsis),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(hoaDonIndex.timeStamp.toDate().toString(),
                overflow: TextOverflow.ellipsis),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(hoaDonIndex.nhanvien, overflow: TextOverflow.ellipsis),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              overflow: TextOverflow.ellipsis,
              "${formatPrice(int.parse(hoaDonIndex.totalAmountCoupons != null ? hoaDonIndex.totalAmountCoupons.toString() : hoaDonIndex.totalAmount.toString()))} đ",
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              _deleteInvoice(hoaDonIndex);
            },
            icon: const Icon(
              CupertinoIcons.trash_fill,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  void _deleteInvoice(Invoice invoice) {
    Get.dialog(MyDialog(
      title: "Xóa hóa đơn",
      content: const Text('Bạn có muốn xóa hóa đơn hay không?'),
      labelLeadingButton: 'Xác nhận',
      labelTraillingButton: 'Hủy',
      onTapLeading: () {
        FirestoreHelper.deletehoadon(invoice);
        Navigator.pop(context);
      },
      onTapTrailling: () {
        Navigator.pop(context);
      },
    ));
  }

  // void _showChiTietHoaDon(Invoice hoadon) {
  //   Get.dialog(chitiethoadon(hoadon: hoadon));
  // }
}

// class chitiethoadon extends StatefulWidget {
//   final Invoice hoadon;

//   const chitiethoadon({super.key, required this.hoadon});

//   @override
//   State<chitiethoadon> createState() => _chitiethoadonState();
// }

// class _chitiethoadonState extends State<chitiethoadon> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.hoadon.id.toString()),
//       content: Container(
//         height: SizeConfig.screenHeight,
//         width: SizeConfig.screenWidth / 2,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Text(
//                 'Tên Cửa Hàng: Coffee Wind',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'Nhân viên:${widget.hoadon.nhanvien} ',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Text('Địa chỉ cửa hàng: 54 Thủ Khoa Huân'),
//               const SizedBox(height: 10),
//               Text(widget.hoadon.date),
//               const SizedBox(height: 20),
//               const Text(
//                 'Chi Tiết Hoá Đơn:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: SizedBox(
//                   height: SizeConfig.screenHeight,
//                   width: SizeConfig.screenWidth,
//                   child: ListView(
//                     children: [
//                       DataTable(
//                         columns: const [
//                           DataColumn(label: Text('tên sản phẩm')),
//                           DataColumn(label: Text('số lượng')),
//                           DataColumn(label: Text('giá')),
//                           DataColumn(label: Text('tổng giá')),
//                         ],
//                         rows: widget.hoadon.products.map((chitiethdindex) {
//                           return DataRow(cells: [
//                             DataCell(Text(chitiethdindex.tensp.toString())),
//                             DataCell(Text(chitiethdindex.soluong.toString())),
//                             DataCell(Text(chitiethdindex.giasp.toString())),
//                             DataCell(Text(
//                                 (chitiethdindex.soluong * chitiethdindex.giasp)
//                                     .toString())),
//                           ]);
//                         }).toList(),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
