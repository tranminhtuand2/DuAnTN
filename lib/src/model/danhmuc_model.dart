// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class DanhMuc {
  String tendanhmuc;
  String? iddanhmuc;
  DanhMuc({
    required this.tendanhmuc,
    this.iddanhmuc,
  });
  factory DanhMuc.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return DanhMuc(
        tendanhmuc: snapshot['tendanhmuc'], iddanhmuc: snapshot['iddanhmuc']);
  }
  Map<String, dynamic> toJson() => {
        "tendanhmuc": tendanhmuc,
        "iddanhmuc": iddanhmuc,
      };
}
