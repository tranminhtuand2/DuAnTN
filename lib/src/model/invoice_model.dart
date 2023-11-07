import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managerfoodandcoffee/src/model/giohanghd.dart';

class Invoice {
  String? id; // Mã hoá đơn (nếu cần)
  List<GioHang1> products; // Danh sách các sản phẩm trong hoá đơn
  String tableName;
  int? persentCoupons; // Phần trăm giảm giá khi áp khuyến mãi;
  Timestamp timeStamp;
  String nhanvien;
  double totalAmount; // Tổng tiền hoá đơn
  double? totalAmountCoupons; // Tổng tiền hoá đơn đã giảm giá
  Invoice({
    this.id,
    required this.products,
    required this.tableName,
    this.persentCoupons,
    required this.timeStamp,
    required this.nhanvien,
    required this.totalAmount,
    this.totalAmountCoupons,
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
      timeStamp: data['timeStamp'],
      nhanvien: data['nhanvien'],
      totalAmount: data['totalAmount'],
      totalAmountCoupons: data['totalAmountCoupons'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'products': products.map((product) => product.toJson()).toList(),
        "timeStamp": timeStamp,
        'persentCoupons': persentCoupons,
        'tableName': tableName,
        'nhanvien': nhanvien,
        'totalAmount': totalAmount,
        "totalAmountCoupons": totalAmountCoupons
      };
}
