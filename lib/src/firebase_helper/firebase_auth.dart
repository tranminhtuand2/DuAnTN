import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/model/user_model.dart';

class FireBaseAuth {
  static final auth = FirebaseAuth.instance;

  Future<UserCredential?> registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String fullname}) async {
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await auth.currentUser?.sendEmailVerification();
      await auth.currentUser?.updateDisplayName(fullname);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          showCustomSnackBar(
              title: 'Lỗi',
              message: 'Mật khẩu yếu, vui lòng chọn mật khẩu khác.',
              type: Type.error);
          break;
        case 'email-already-in-use':
          showCustomSnackBar(
              title: 'Lỗi',
              message: 'Email đã được sử dụng. Vui lòng sử dụng email khác.',
              type: Type.error);
          break;
        // Các trường hợp lỗi khác có thể xử lý tương tự
        default:
          showCustomSnackBar(
              title: 'Lỗi',
              message: 'Đăng ký không thành công: ${e.message}',
              type: Type.error);
      }
    }
    return null;
  }

  Future<UserCredential?> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      if (!userCredential.user!.emailVerified) {
        showCustomSnackBar(
            title: "Lỗi",
            message:
                "Kiểm tra email và xác thực lại tài khoản đã đăng ký!!",
            type: Type.error);
      } else {
        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          // Xử lý khi mật khẩu không đúng
          showCustomSnackBar(
              title: 'Lỗi', message: 'Mật khẩu không đúng', type: Type.error);
          break;
        case "user-not-found":
          // Xử lý khi người dùng không tồn tại
          showCustomSnackBar(
              title: 'Lỗi',
              message: 'Người dùng không tồn tại',
              type: Type.error);
          break;
        // Các trường hợp lỗi khác có thể xử lý tương tự
        default:
          showCustomSnackBar(
              title: 'Lỗi',
              message: 'Đăng nhập thất bại: ${e.message}',
              type: Type.error);
      }
    }
    return null;
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar(
          title: 'Lỗi', message: e.toString(), type: Type.error);
    }
  }

  Future<void> createUserAndRole(
      {required String email, String role = 'guest'}) async {
    final roleUser = FirebaseFirestore.instance.collection("roleUser");

    final docref = roleUser.doc(email);

    // Kiểm tra xem người dùng đã tồn tại trong Firestore hay không
    final docSnapshot = await docref.get();
    if (docSnapshot.exists) return;

    final userModel = UserModel(email: email, role: role).toJson();
    try {
      await docref.set(userModel);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  Future<void> updateUserAndRole(
      {required String email, required String role}) async {
    final roleUser = FirebaseFirestore.instance.collection("roleUser");

    final docref = roleUser.doc(email);
    final userModel = UserModel(email: email, role: role).toJson();
    try {
      await docref.update(userModel);
    } catch (e) {
      Get.snackbar("lỗi", e.toString());
    }
  }

  Future<void> deleteUserAndRole({required String email}) async {
    final roleUser = FirebaseFirestore.instance.collection("roleUser");

    await roleUser.doc(email).delete();
  }

  static Stream<List<UserModel>> readUser() {
    final user = FirebaseFirestore.instance.collection("roleUser");

    return user.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  static Stream<UserModel> getRoleWithEmail({required String email}) {
    final roleUser = FirebaseFirestore.instance.collection("roleUser");
    Query query = roleUser
        .where('email', isEqualTo: email)
        .limit(1); // Giới hạn kết quả trả về chỉ một bản ghi
    return query.snapshots().map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromSnapshot(
            querySnapshot.docs[0]); // Trả về dữ liệu của sản phẩm duy nhất
      } else {
        // Trả về một UserModel rỗng nếu không tìm thấy
        return UserModel(email: '', role: '');
      }
    });
  }
}
