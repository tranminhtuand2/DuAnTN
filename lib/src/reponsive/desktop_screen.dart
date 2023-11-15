import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/loading.dart';
import 'package:managerfoodandcoffee/src/controller_getx/auth_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebase_auth.dart';
import 'package:managerfoodandcoffee/src/model/user_model.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/admin_panel.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/login_screen/login_screen.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  final authController = Get.put(AuthController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.checkUserLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return const Scaffold(body: AdminPanelScreen());
    // return const Scaffold(body: LoginScreen());
    return Scaffold(body: Center(child: Loading()));
  }
}
