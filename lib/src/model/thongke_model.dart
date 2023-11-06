// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managerfoodandcoffee/src/model/giohanghd.dart';

class ThongKe {
  String? idtk;
  String? nhanvien;
  FieldValue? date; // Sử dụng kiểu dữ liệu FieldValue cho trường date
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
        'products': products.map((product) => product.toJson()).toList(),
        "total": total,
      };
}
