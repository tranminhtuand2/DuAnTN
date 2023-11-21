import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/controller_getx/auth_controller.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/login_screen/login_screen.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/login_screen/widget/forgot_password.dart';
import 'package:managerfoodandcoffee/src/shared_preferences/shared_preference.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class LoginPanel extends StatefulWidget {
  const LoginPanel({super.key, required this.onTapTitle});
  final Function(bool) onTapTitle;
  @override
  State<LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<LoginPanel> {
  // ignore: no_leading_underscores_for_local_identifiers
  final _controllerEmail = TextEditingController();
  // ignore: no_leading_underscores_for_local_identifiers
  final _controllerPassword = TextEditingController();

  final keyForm = GlobalKey<FormState>();

  final controllerAuth = Get.put(AuthController());

  void getEmail() async {
    String? email = await MySharedPreferences.getEmail();
    _controllerEmail.text = email;
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

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
              'Chào mừng quay lại \nHãy đăng nhập để bắt đầu ',
              style: text(context).titleLarge?.copyWith(
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            InputField(
                controller: _controllerEmail,
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
              controller: _controllerPassword,
              inputType: TextInputType.text,
              prefixIcon: const Icon(Icons.lock),
              labelText: 'Nhập mật khẩu',
              maxLines: 1,
              isPassword: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Vui lòng điền vào mật khẩu";
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
                  controllerAuth.login(
                    email: _controllerEmail.text,
                    password: _controllerPassword.text,
                  );
                }
              },
              backgroundColor: colorScheme(context).onSurfaceVariant,
              height: 54,
              text: Text(
                'Đăng nhập',
                style: text(context).titleSmall?.copyWith(
                    color: colorScheme(context).tertiary,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      widget.onTapTitle(false);
                    },
                    child: Text(
                      'Đăng ký ngay',
                      textAlign: TextAlign.left,
                      style: text(context)
                          .titleSmall
                          ?.copyWith(color: colorScheme(context).tertiary),
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.dialog(ForgotPassword()),
                    child: Text(
                      'Quên mật khẩu?',
                      textAlign: TextAlign.right,
                      style: text(context)
                          .titleSmall
                          ?.copyWith(color: colorScheme(context).tertiary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            BtnLogin(
              color: Colors.transparent,
              title: "Đăng nhập với Google",
              colorTitle: colorScheme(context).tertiary,
              urlImage: 'images/logo_g.png',
              onClick: () {
                Get.put(AuthController()).loginGoogleInWeb();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
