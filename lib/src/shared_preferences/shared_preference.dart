import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveBrightnessPreference(bool isDarkMode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDarkMode', isDarkMode);
}

class MySharedPreferences {
  static const _emailKey = 'email';
  static Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_emailKey, email);
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(_emailKey);

    return email ?? '';
  }
}
