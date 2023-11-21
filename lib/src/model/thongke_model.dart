// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managerfoodandcoffee/src/model/giohanghd.dart';

class ThongKe {
  String? idtk;
  String? nhanvien;
  Timestamp date; // Sử dụng kiểu dữ liệu FieldValue cho trường date
  List<GioHang1> products;
  double? total;
  ThongKe({
    this.idtk,
    required this.nhanvien,
    required this.date,
    required this.products,
    required this.total,
  });
  factory ThongKe.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    var products = List<Map<String, dynamic>>.from(snapshot['products']);
    var productList = products
        .map((productData) => GioHang1.fromSnapshot(productData))
        .toList();
    return ThongKe(
        idtk: snapshot['idtk'],
        nhanvien: snapshot['nhanvien'],
        date: snapshot['date'],
        products: productList,
        total: snapshot['total']);
  }

  Map<String, dynamic> toJson() => {
        "idtk": idtk,
        "nhanvien": nhanvien,
        "date": date,
        "products": products.map((product) => product.toJson()).toList(),
        "total": total,
      };
}
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:managerfoodandcoffee/src/model/giohanghd.dart';

// class Invoice {
//   String? id; // Mã hoá đơn (nếu cần)
//   List<GioHang1> products; // Danh sách các sản phẩm trong hoá đơn
//   String tableName;
//   int? persentCoupons; // Phần trăm giảm giá khi áp khuyến mãi;
//   Timestamp timeStamp;
//   String nhanvien;
//   double totalAmount; // Tổng tiền hoá đơn
//   double? totalAmountCoupons; // Tổng tiền hoá đơn đã giảm giá
//   Invoice({
//     this.id,
//     required this.products,
//     required this.tableName,
//     this.persentCoupons,
//     required this.timeStamp,
//     required this.nhanvien,
//     required this.totalAmount,
//     this.totalAmountCoupons,
//   });
//   factory Invoice.fromSnapshot(DocumentSnapshot snapshot) {
//     var data = snapshot.data() as Map<String, dynamic>;
//     var products = List<Map<String, dynamic>>.from(data['products']);
//     var productList = products
//         .map((productData) => GioHang1.fromSnapshot(productData))
//         .toList();
//     return Invoice(
//       id: data["id"],
//       products: productList,
//       persentCoupons: data['persentCoupons'],
//       tableName: data['tableName'],
//       timeStamp: data['timeStamp'],
//       nhanvien: data['nhanvien'],
//       totalAmount: data['totalAmount'],
//       totalAmountCoupons: data['totalAmountCoupons'],
//     );
//   }
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'products': products.map((product) => product.toJson()).toList(),
//         "timeStamp": timeStamp,
//         'persentCoupons': persentCoupons,
//         'tableName': tableName,
//         'nhanvien': nhanvien,
//         'totalAmount': totalAmount,
//         "totalAmountCoupons": totalAmountCoupons
//       };
// }

