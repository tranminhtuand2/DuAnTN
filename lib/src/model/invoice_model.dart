import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managerfoodandcoffee/src/model/card_model.dart';
import 'package:managerfoodandcoffee/src/model/giohanghd.dart';

class Invoice {
  String? id; // Mã hoá đơn (nếu cần)
  List<GioHang1> products; // Danh sách các sản phẩm trong hoá đơn
  // Email khách hàng
  String tableName;
  int? persentCoupons;
  String date; // Ngày tạo hoá đơn
  String nhanvien;
  double totalAmount; // Tổng tiền hoá đơn
  Invoice({
    this.id,
    required this.products,
    required this.tableName,
    this.persentCoupons,
    required this.date,
    required this.nhanvien,
    required this.totalAmount,
  });
  factory Invoice.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    var products = List<Map<String, dynamic>>.from(data['products']);
    var productList = products
        .map((productData) => GioHang1.fromSnapshot(productData))
        .toList();
    return Invoice(
      id: data["id"],
      products: productList,
      persentCoupons: data['persentCoupons'],
      tableName: data['tableName'],
      date: data['date'],
      nhanvien: data['nhanvien'],
      totalAmount: data['totalAmount'].toDouble(),
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'products': products.map((product) => product.toJson()).toList(),
        'date': date,
        'persentCoupons': persentCoupons,
        'tableName': tableName,
        'nhanvien': nhanvien,
        'totalAmount': totalAmount,
      };
}
