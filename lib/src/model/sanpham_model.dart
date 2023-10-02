// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class SanPham {
  final String? idsp;
  final String tensp;
  final int giasp;
  final String mieuta;
  final String danhmuc;
  final String hinhanh;
  SanPham({
    this.idsp,
    required this.tensp,
    required this.giasp,
    required this.mieuta,
    required this.danhmuc,
    required this.hinhanh,
  });
  factory SanPham.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SanPham(
      idsp: snapshot['idsp'],
      tensp: snapshot['tensp'],
      giasp: snapshot['giasp'],
      mieuta: snapshot['mieuta'],
      danhmuc: snapshot['danhmuc'],
      hinhanh: snapshot['hinhanh'],
    );
  }
  Map<String, dynamic> toJson() => {
        "idsp": idsp,
        "tensp": tensp,
        "giasp": giasp,
        "mieuta": mieuta,
        "danhmuc": danhmuc,
        "hinhanh": hinhanh,
      };
}
