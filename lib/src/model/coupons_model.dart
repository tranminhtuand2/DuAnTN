// To parse this JSON data, do
//
//     final coupons = couponsFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Coupons couponsFromJson(String str) => Coupons.fromJson(json.decode(str));

String couponsToJson(Coupons data) => json.encode(data.toJson());

class Coupons {
  String id;
  String beginDay;
  String endDay;
  String data;
  int persent;
  bool isEnable;

  Coupons({
    required this.id,
    required this.beginDay,
    required this.endDay,
    required this.data,
    required this.persent,
    required this.isEnable,
  });

  factory Coupons.fromJson(Map<String, dynamic> json) => Coupons(
        id: json['id'],
        beginDay: json["begin_day"],
        endDay: json["end_day"],
        data: json["data"],
        persent: json["persent"],
        isEnable: json["isEnable"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "begin_day": beginDay,
        "end_day": endDay,
        "data": data,
        "persent": persent,
        "isEnable": isEnable,
      };
  factory Coupons.fromsnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Coupons(
      id: snapshot['id'],
      beginDay: snapshot['begin_day'],
      endDay: snapshot['end_day'],
      data: snapshot['data'],
      persent: snapshot['persent'],
      isEnable: snapshot['isEnable'],
    );
  }
}
