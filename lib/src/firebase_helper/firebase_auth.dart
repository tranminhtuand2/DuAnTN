import 'package:firebase_auth/firebase_auth.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';

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
      showCustomSnackBar(
          title: 'Lỗi', message: e.toString(), type: Type.error);
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
      showCustomSnackBar(
          title: 'Lỗi', message: e.toString(), type: Type.error);
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
}
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';

// class FireBaseAuth {
//   static final auth = FirebaseAuth.instance;

//   Future<UserCredential?> registerWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String fullname,
//   }) async {
//     try {
//       final UserCredential userCredential =
//           await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       await auth.currentUser?.sendEmailVerification();
//       await auth.currentUser?.updateDisplayName(fullname);
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       showCustomSnackBar(
//           title: 'Lỗi', message: e.toString(), type: Type.error);
//       throw e; // Ném ra ngoại lệ để chỉ ra lỗi
//     }
//   }

//   Future<UserCredential?> loginWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final UserCredential userCredential =
//           await auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       if (!userCredential.user!.emailVerified) {
//         showCustomSnackBar(
//           title: "Lỗi",
//           message:
//               "Kiểm tra email và xác thực lại tài khoản đã đăng ký!!",
//           type: Type.error,
//         );
//         throw FirebaseAuthException(
//             code: 'email-not-verified', message: 'Email not verified');
//       } else {
//         return userCredential;
//       }
//     } on FirebaseAuthException catch (e) {
//       showCustomSnackBar(
//           title: 'Lỗi', message: e.toString(), type: Type.error);
//       throw e; // Ném ra ngoại lệ để chỉ ra lỗi
//     }
//   }

//   Future<void> forgotPassword({required String email}) async {
//     try {
//       await auth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       showCustomSnackBar(
//           title: 'Lỗi', message: e.toString(), type: Type.error);
//       throw e; // Ném ra ngoại lệ để chỉ ra lỗi
//     }
//   }
// }
