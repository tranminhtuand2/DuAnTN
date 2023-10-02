// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class danhmucModel {
  String tendanhmuc;
  String? iddanhmuc;
  danhmucModel({
    required this.tendanhmuc,
    this.iddanhmuc,
  });
  factory danhmucModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return danhmucModel(
        tendanhmuc: snapshot['tendanhmuc'], iddanhmuc: snapshot['iddanhmuc']);
  }
  Map<String, dynamic> toJson() => {
        "tendanhmuc": tendanhmuc,
        "iddanhmuc": iddanhmuc,
      };
}
