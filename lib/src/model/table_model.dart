// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class TableModel {
  String tenban;
  String? maban;
  bool? isSelected;
  TableModel({required this.tenban, this.maban, this.isSelected});

  factory TableModel.fromsnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return TableModel(
      tenban: snapshot['tenban'],
      maban: snapshot['maban'],
      isSelected: snapshot['isSelected'],
    );
  }
  Map<String, dynamic> toJson() => {
        "tenban": tenban,
        "maban": maban,
        "isSelected": isSelected,
      };
}
