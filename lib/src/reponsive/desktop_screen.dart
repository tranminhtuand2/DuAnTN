import 'package:flutter/material.dart';

import '../screen/desktop/loginpage_screen/pagelogin_screen.dart';

class desktopScreen extends StatelessWidget {
  const desktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 195, 153, 71),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                '/images/bgdesktop.jpg'), // Thay đổi hình ảnh nền ở đây
            fit: BoxFit.cover,
          ),
        ),
        child: admin_login(),
      ),
    );
  }
}
