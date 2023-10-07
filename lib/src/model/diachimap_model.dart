import 'package:cloud_firestore/cloud_firestore.dart';

class diachimap {
  double vido;
  double kinhdo;
  String? id;
  diachimap({
    required this.vido,
    required this.kinhdo,
    this.id,
  });
  factory diachimap.fromsnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return diachimap(
      vido: snapshot['vido'],
      kinhdo: snapshot['kinhdo'],
      id: snapshot['id'],
    );
  }
  Map<String, dynamic> toJson() => {
        "vido": vido,
        "kinhdo": kinhdo,
        "id": id,
      };
}
