import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:managerfoodandcoffee/src/reponsive/desktop_screen.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/dieuchinh_screen.dart';

class GoogleSignInController extends GetxController {
  var userName = "".obs;
  var email = "".obs;
  var urlAvatar = "".obs;

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future loginGoogleInWeb() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(authProvider);
        User? user = userCredential.user;
        if (user != null) {
          log(user.displayName!);
          log(user.email!);
          userName.value = user.displayName!;
          email.value = user.email!;
          urlAvatar.value = user.photoURL!;

          Get.to(() => dieuchinhSceen());
        }

        // GoogleSignInAccount? googleSignInAccount = kIsWeb
        //     ? await (googleSignIn.signIn())
        //     : await (googleSignIn.signIn());

        // if (kIsWeb && googleSignInAccount == null) {
        //   googleSignInAccount = await (googleSignIn.signIn());
        // }

        // final googleAuth = await googleSignInAccount!.authentication;

        // final credential = GoogleAuthProvider.credential(
        //   accessToken: googleAuth.accessToken,
        //   idToken: googleAuth.idToken,
        // );
        // final authResult =
        //     await FirebaseAuth.instance.signInWithCredential(credential);
        // User user = authResult.user!;
        // log(user.displayName!.toString());
        // log(user.email!);
      } catch (e) {
        print("ERROR: $e");
      }
    }
  }

  Future logoutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    await GoogleSignIn().disconnect();
    await GoogleSignIn().isSignedIn();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      log(user.email!);
    }
    log("logout");

    Get.offAll(() => const DesktopScreen());
  }
}
