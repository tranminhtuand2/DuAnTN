import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/banhang/banhang_screen.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/dieuchinh_screen.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/thongke/thongke_screen.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/thungan/thungan_screen.dart';

class pageScreen extends StatefulWidget {
  const pageScreen({super.key});

  @override
  State<pageScreen> createState() => _pageScreenState();
}

class _pageScreenState extends State<pageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: danhmucadmin(),
    );
  }
}

class danhmucadmin extends StatefulWidget {
  danhmucadmin({super.key});

  @override
  State<danhmucadmin> createState() => _danhmucadminState();
}

class _danhmucadminState extends State<danhmucadmin> {
  int _currentPageIndex = 2;
  final List<String> danhMuc = [
    "Bán Hàng",
    "Lịch Sử",
    "Điều Chỉnh",
    "Thống Kế",
  ];

  final List<String> hinhAnhDanhMuc = [
    "assets/images/cashier.json",
    "assets/images/order.json",
    "assets/images/thongke.json",
    "assets/images/thongke2.json",
  ];

  final List<Widget> page = [
    banhangscreen(),
    thunganscreen(),
    dieuchinhSceen(),
    thongkescreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('username'),
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: danhMuc.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(danhMuc[index]),
              leading: Lottie.asset(
                hinhAnhDanhMuc[index],
                height: 50, // Thiết lập kích thước hình ảnh theo ý muốn.
                width: 50,
              ),
              onTap: () {
                setState(() {
                  _currentPageIndex = index;
                });

                // Xử lý khi người dùng nhấn vào một danh mục cụ thể trong Drawer.
                print("Bạn đã nhấn vào danh mục: ${danhMuc[index]}");
                Navigator.pop(context); // Đóng Drawer sau khi chọn.
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: page[_currentPageIndex]),
      ),
    );
  }
}
