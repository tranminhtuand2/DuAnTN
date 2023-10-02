import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/controller/CRUD_Controller_product.dart';

class SanphamCrudScreen extends StatefulWidget {
  const SanphamCrudScreen({super.key});

  @override
  State<SanphamCrudScreen> createState() => _SanphamCrudScreenState();
}

class _SanphamCrudScreenState extends State<SanphamCrudScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("quản lý sản phẩm"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [UploadAndViewImage()],
          ),
        ));
  }
}
