import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/loginpage_screen/widget/RegistrationDialog.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/pageadmin/DieuChinh/dieuchinh_screen.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';
import '../../../common_widget/text_form_field.dart';
import '../../../constants/textstring.dart';
import '../../../controller/alertthongbao.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Header(),
          FormLogin(),
        ],
      ),
    );
  }
}

class FormLogin extends StatelessWidget {
  final getAlert thongbao = Get.put(getAlert());
  FormLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController tendangnhap = TextEditingController();
    TextEditingController matkhau = TextEditingController();

    return SingleChildScrollView(
        child: Container(
      height: MediaQuery.sizeOf(context).height,
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
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontFamily: GoogleFonts.aldrich().fontFamily),
              ),
              const SizedBox(
                height: 60,
              ),
              MyTextFormField(
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
              MyTextFormField(
                  hintext: "Mật khẩu",
                  labeltext: "Mật khẩu",
                  icon: const Icon(Icons.key),
                  // Quy tắc cho mật khẩu: Bao gồm ít nhất 8 ký tự, bao gồm chữ thường, chữ hoa và số.
                  regExp: r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$",
                  isempty: "Vui lòng nhập mật khẩu",
                  wrongtype:
                      "Ít nhất 8 ký tự, bao gồm chữ thường, chữ hoa và số và không có ký tự đặc biệt",
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
              MyButton(
                  onTap: () {
                    Get.to(() => dieuchinhSceen());
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
                  backgroundColor: colorScheme(context).primary,
                  height: 60,
                  text: Text(
                    'Đăng nhập',
                    style: text(context)
                        .titleMedium
                        ?.copyWith(color: colorScheme(context).tertiary),
                  )),
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

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Lottie.asset(
          "/images/logocf.json",
          animate: true,
          height: 200,
          width: 200,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Wind Coffee",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.aboreto().fontFamily),
            ),
            Text(
              "Hương thơm đắm say, cảm xúc đậm đà",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
