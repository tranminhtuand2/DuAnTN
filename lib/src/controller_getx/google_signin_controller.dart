import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '204912491565-dffn6tg7eslkeogdhrhocv8sf7fsumbm.apps.googleusercontent.com',
  );

  User? user;
  bool isLogged = false;
  bool isLoading = false;

  Future loginGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = kIsWeb
          ? await (googleSignIn.signInSilently())
          : await (googleSignIn.signIn());

      if (kIsWeb && googleSignInAccount == null) {
        googleSignInAccount = await (googleSignIn.signIn());
      }

      if (googleSignInAccount == null) {
        // isLogged = false;
        return;
      }

      // final googleAuth = await googleSignInAccount.authentication;

      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
        user = account as User?;
        print(user?.displayName);
        print(user?.email);
      });
    } catch (e) {
      print(e);
    }

    Future logoutGoogle() async {
      await FirebaseAuth.instance.signOut();

      await googleSignIn.disconnect();
    }
  }
}
