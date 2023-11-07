// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class TinhTrangThanhToan {
  String trangthai;
  String? idtinhtrang;
  String? couponsCode;
  TinhTrangThanhToan({
    required this.trangthai,
    this.idtinhtrang,
    this.couponsCode,
  });
  factory TinhTrangThanhToan.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return TinhTrangThanhToan(
      trangthai: snapshot['trangthai'],
      idtinhtrang: snapshot['idtinhtrang'],
      couponsCode: snapshot['couponsCode'],
    );
  }
  Map<String, dynamic> toJson() => {
        "trangthai": trangthai,
        "idtinhtrang": idtinhtrang,
        "couponsCode": couponsCode
      };
}
