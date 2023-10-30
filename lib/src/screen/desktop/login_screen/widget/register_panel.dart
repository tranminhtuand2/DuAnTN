import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/controller_getx/auth_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebase_auth.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class RegisterPanel extends StatefulWidget {
  const RegisterPanel({super.key, required this.onTapTitle});
  final Function(bool) onTapTitle;

  @override
  State<RegisterPanel> createState() => _RegisterPanelState();
}

class _RegisterPanelState extends State<RegisterPanel> {
  final TextEditingController controllerFullName = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerRePassword = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  final controllerAuth = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: keyForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đăng ký để sử dụng dịch vụ ',
              style: text(context).titleLarge?.copyWith(
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            InputField(
                controller: controllerEmail,
                inputType: TextInputType.emailAddress,
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng điền vào địa chỉ email";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return "Địa chỉ email không hợp lệ";
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            InputField(
                controller: controllerFullName,
                inputType: TextInputType.text,
                labelText: 'Họ và tên',
                prefixIcon: const Icon(Icons.email),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập tên";
                  }

                  return null;
                }),
            const SizedBox(height: 20),
            InputField(
              controller: controllerPassword,
              inputType: TextInputType.text,
              prefixIcon: const Icon(Icons.lock),
              labelText: 'Nhập mật khẩu',
              maxLines: 1,
              maxLength: 10,
              isPassword: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Vui lòng điền vào mật khẩu";
                }
                if (value.length < 6) {
                  return "Mật khẩu phải từ 6 ký tự";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            InputField(
              controller: controllerRePassword,
              inputType: TextInputType.text,
              maxLength: 10,
              prefixIcon: const Icon(Icons.lock),
              labelText: 'Nhập lại mật khẩu',
              maxLines: 1,
              isPassword: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Vui lòng điền vào mật khẩu";
                }
                if (value != controllerPassword.text) {
                  return "Hai mật khẩu phải trùng nhau";
                }
                if (value.length < 6) {
                  return "Mật khẩu phải từ 6 ký tự";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              onTap: () {
                if (keyForm.currentState!.validate()) {
                  controllerAuth.register(
                    email: controllerEmail.text,
                    password: controllerPassword.text,
                    fullname: controllerFullName.text,
                  );
                }
              },
              backgroundColor: colorScheme(context).onSurfaceVariant,
              height: 54,
              text: Text(
                'Đăng ký',
                style: text(context)
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {
                  widget.onTapTitle(true);
                },
                child: Text(
                  'Đăng nhập ngay',
                  textAlign: TextAlign.right,
                  style: text(context)
                      .titleSmall
                      ?.copyWith(color: colorScheme(context).tertiary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
