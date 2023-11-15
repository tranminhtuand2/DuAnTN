import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String role;
  UserModel({
    required this.email,
    required this.role,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      email: snapshot['email'],
      role: snapshot['role'],
    );
  }
  Map<String, dynamic> toJson() => {
        "email": email,
        "role": role,
      };
}
