// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class GioHang {
  String? idsp;
  String tensp;
  int giasp;
  int soluong;
  String? ghichu;
  String hinhanh;
  GioHang({
    this.idsp,
    required this.tensp,
    required this.giasp,
    required this.soluong,
    this.ghichu = "",
    required this.hinhanh,
  });
  factory GioHang.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return GioHang(
        idsp: snapshot['idsp'],
        tensp: snapshot['tensp'],
        giasp: snapshot['giasp'],
        soluong: snapshot['soluong'],
        ghichu: snapshot['ghichu'],
        hinhanh: snapshot['hinhanh']);
  }
  Map<String, dynamic> toJson() => {
        'idsp': idsp,
        'tensp': tensp,
        'giasp': giasp,
        'soluong': soluong,
        'ghichu': ghichu,
        'hinhanh': hinhanh,
      };
}
