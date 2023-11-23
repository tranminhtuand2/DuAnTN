import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebase_auth.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/admin_panel.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/login_screen/login_screen.dart';
import 'package:managerfoodandcoffee/src/shared_preferences/shared_preference.dart';

class AuthController extends GetxController {
  var userName = "".obs;
  var emailUser = "".obs;
  var urlAvatar = "".obs;
  var role = "".obs;

  final auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Completer<void>? completer; // Declare a Completer as nullable

  Future loginGoogleInWeb() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      completer ??= Completer<void>();

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(authProvider);
        User? user = userCredential.user;
        if (user != null) {
          //Thêm quyền vào email và lưu trữ trên fire store
          await FireBaseAuth().createUserAndRole(email: user.email!);
          getRoleUser(email: user.email!, currentUser: user);
        }
      } on FirebaseAuthException catch (e) {
        showCustomSnackBar(
            title: "Lỗi", message: e.toString(), type: Type.error);
      } finally {
        completer!.complete(); // Complete the Future
      }
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    await GoogleSignIn().disconnect();
    await GoogleSignIn().isSignedIn();

    Get.offAll(() => const LoginScreen());
  }

  void register(
      {required String email,
      required String password,
      required String fullname}) async {
    final response = await FireBaseAuth().registerWithEmailAndPassword(
      email: email,
      password: password,
      fullname: fullname,
    );
    if (response != null) {
      // print(response);
      showCustomSnackBar(
          title: "Thành công",
          message:
              'Đăng ký thành công, hãy kiểm tra email và xác thực tài khoản',
          type: Type.success);
      MySharedPreferences.saveEmail(email);
      logout();
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await FireBaseAuth().loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response != null) {
        //Thêm quyền vào email và lưu trữ trên fire store
        await FireBaseAuth().createUserAndRole(email: email);
        //Lưu email vào MySharedPreferences
        MySharedPreferences.saveEmail(email);
        getRoleUser(
            email: response.user?.email ?? "", currentUser: response.user);
      }
    } on FirebaseAuthException {
      showCustomSnackBar(
          title: "Đăng nhập thất bại!",
          message: 'Tài khoản hoặc mật khẩu không đúng!!',
          type: Type.error);
    }
  }

  void forgotPassword({required String email}) async {
    try {
      await FireBaseAuth().forgotPassword(email: email);
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar(
          title: "Lỗi", message: e.toString(), type: Type.error);
    }
  }

  void checkUserLogin() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      getRoleUser(email: currentUser.email!, currentUser: currentUser);
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  void getRoleUser({required String email, User? currentUser}) async {
    try {
      FireBaseAuth.getRoleWithEmail(email: email).listen((user) {
        role.value = user.role;
        userName.value = currentUser?.displayName ?? "";
        urlAvatar.value = currentUser?.photoURL ?? "";
        emailUser.value = currentUser?.email ?? "";
        Get.offAll(() => const AdminPanelScreen());
      });
    } on FirebaseAuthException catch (e) {
      Get.offAll(() => const LoginScreen());
      showCustomSnackBar(
          title: "Lỗi", message: e.toString(), type: Type.error);
    }
  }

  void updateRole({required String email, required String role}) async {
    try {
      await FireBaseAuth().updateUserAndRole(email: email, role: role);
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar(
          title: "Lỗi khi thay đổi quyền của nhân viên",
          message: e.toString(),
          type: Type.error);
    }
  }
}
