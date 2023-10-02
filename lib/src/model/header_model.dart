// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class HeaderModel {
  String content;
  String headerImage;
  String? id;
  HeaderModel({
    required this.content,
    required this.headerImage,
    this.id,
  });
  factory HeaderModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return HeaderModel(
        content: snapshot['content'],
        headerImage: snapshot['headerImage'],
        id: snapshot['id']);
  }
  Map<String, dynamic> toJson() => {
        "content": content,
        "headerImage": headerImage,
        "id": id,
      };
}
