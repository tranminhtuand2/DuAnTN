import 'package:flutter/material.dart';

import '../screen/desktop/loginpage_screen/pagelogin_screen.dart';

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                '/images/bgdesktop.jpg'), // Thay đổi hình ảnh nền ở đây
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: const LoginScreen(),
      ),
    );
  }
}
