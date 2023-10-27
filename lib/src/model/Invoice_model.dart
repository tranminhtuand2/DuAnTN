import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';

class Invoice {
  String? id; // Mã hoá đơn (nếu cần)
  List<GioHang> products; // Danh sách các sản phẩm trong hoá đơn
  // Email khách hàng
  String date; // Ngày tạo hoá đơn
  int totalAmount; // Tổng tiền hoá đơn
  Invoice({
    this.id,
    required this.products,
    required this.date,
    required this.totalAmount,
  });
  factory Invoice.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Invoice(
      id: snapshot.id,
      products: (data['products'] as List<dynamic>)
          .map((product) => GioHang.fromSnapshot(product))
          .toList(),
      date: data['date'],
      totalAmount: data['totalAmount'].toDouble(),
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'products': products.map((product) => product.toJson()).toList(),
        'date': date,
        'totalAmount': totalAmount,
      };
}
