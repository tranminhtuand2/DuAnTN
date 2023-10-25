import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/model/sanpham_model.dart';

class DataEditProductController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  var selectedValue = Rx<String?>(null);
  var urlImage = ''.obs;
  var isEdit = false.obs;
  var product =
      SanPham(tensp: '', giasp: 0, mieuta: '', danhmuc: '', hinhanh: '').obs;

  void setData({required SanPham sanPham}) {
    nameController.text = sanPham.tensp;
    descriptionController.text = sanPham.mieuta;
    priceController.text = sanPham.giasp.toString();
    selectedValue.value = sanPham.danhmuc;
    urlImage.value = sanPham.hinhanh;
    isEdit.value = true;
    product.value = sanPham;
  }

  void removeData() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    selectedValue.value = null;
    urlImage.value = '';
    isEdit.value = false;
  }
}
