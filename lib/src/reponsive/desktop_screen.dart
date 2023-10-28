import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/admin_panel.dart';

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AdminPanelScreen());
    // return const Scaffold(body: LoginScreen());
  }
}
