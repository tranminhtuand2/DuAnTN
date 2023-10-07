import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/loginpage_screen/widget/RegistrationDialog.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/dieuchinh_screen.dart';
import '../../../common_widget/textform.dart';
import '../../../constants/textstring.dart';
import '../../../controller/alertthongbao.dart';

class admin_login extends StatelessWidget {
  const admin_login({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const header(),
          formdangnhap(),
        ],
      ),
    );
  }
}

class formdangnhap extends StatelessWidget {
  final getAlert thongbao = Get.put(getAlert());
  formdangnhap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController tendangnhap = TextEditingController();
    TextEditingController matkhau = TextEditingController();

    return SingleChildScrollView(
        child: Container(
      height: 500,
      width: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                Slogans.slogan7,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 60,
              ),
              textformfield(
                  hintext: "Tên đăng nhập",
                  labeltext: "Tên đăng nhập",
                  icon: const Icon(Icons.person),
                  // Quy tắc cho tên người dùng: Bao gồm chữ thường, chữ hoa và số, ít nhất 6 ký tự.
                  regExp: r"^[a-zA-Z0-9]{6,}$",
                  isempty: "Vui lòng nhập tên tài khoản",
                  wrongtype: "Có ký tự đặc biệt hoặc chưa đủ độ dài",
                  textcontroller: tendangnhap,
                  hint: false),
              const SizedBox(
                height: 20,
              ),
              textformfield(
                  hintext: "mật khẩu",
                  labeltext: "mật khẩu",
                  icon: const Icon(Icons.key),
                  // Quy tắc cho mật khẩu: Bao gồm ít nhất 8 ký tự, bao gồm chữ thường, chữ hoa và số.
                  regExp: r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$",
                  isempty: "vui lòng nhập mật khẩu",
                  wrongtype:
                      "ít nhất 8 ký tự, bao gồm chữ thường, chữ hoa và số và không có ký tự đặc biệt",
                  textcontroller: matkhau,
                  hint: true),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Quên mật khẩu"),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const dieuchinhSceen());
                  // Xử lý sự kiện khi nút được nhấn
                  // Get.rawSnackbar(
                  //   message: "đăng nhập thành công.",
                  //   duration: Duration(seconds: 3), // Độ dài hiển thị
                  //   isDismissible:
                  //       true, // Cho phép đóng Snackbar bằng cách nhấn vào nó
                  //   margin: EdgeInsets.all(16.0), // Đặt khoảng cách bên trái
                  //   borderRadius: 12, // Bỏ viền bo tròn
                  //   animationDuration: Duration(milliseconds: 300),
                  //   backgroundGradient: LinearGradient(
                  //     colors: [Colors.blue, Colors.green], // Màu nền
                  //     stops: [0.1, 0.9],
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .secondaryContainer, // Màu chữ trên nút
                  textStyle: const TextStyle(fontSize: 12), // Kiểu chữ
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // Khoảng cách giữa chữ và viền của nút
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bo góc của nút
                  ),
                ),
                child: const Text('đăng nhập'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Get.dialog(RegistrationDialog());
                  },
                  child: const Text("Tôi muốn tạo tài khoãn!"))
            ],
          ),
        ),
      ),
    ));
  }
}

class header extends StatelessWidget {
  const header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Lottie.asset(
          "/images/logocf.json",
          animate: true,
          height: 200,
          width: 200,
        ),
        Text(
          "Coffee \nGIÓ",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Container(
          child: Text(
            "Hương thơm đắm say, cảm xúc đậm đà",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        )
      ],
    );
  }
}
