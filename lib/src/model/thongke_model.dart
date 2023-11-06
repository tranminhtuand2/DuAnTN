// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ThongKe {
  String? nhanvien;
  FieldValue? date; // Sử dụng kiểu dữ liệu FieldValue cho trường date
  double? total;
  ThongKe({
    required this.nhanvien,
    required this.date,
    required this.total,
  });
  factory ThongKe.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ThongKe(
        nhanvien: snapshot['nhanvien'],
        date: snapshot['date'],
        total: snapshot['total']);
  }

  Map<String, dynamic> toJson() => {
        "nhanvien": nhanvien,
        "date": date,
        "total": total,
      };
}
