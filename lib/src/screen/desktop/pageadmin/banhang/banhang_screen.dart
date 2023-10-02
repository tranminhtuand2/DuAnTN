import 'package:flutter/material.dart';

class banhangscreen extends StatelessWidget {
  const banhangscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(child: Text("Danh sách sản phẩm")),
            ],
          ),
        ],
      ),
    );
  }
}
