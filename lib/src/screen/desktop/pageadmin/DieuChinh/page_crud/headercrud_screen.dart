import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/controller/CRUD_controller_header.dart';

class headerCrudScreen extends StatefulWidget {
  const headerCrudScreen({super.key});

  @override
  State<headerCrudScreen> createState() => _headerCrudScreenState();
}

class _headerCrudScreenState extends State<headerCrudScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crud_header(),
    );
  }
}
