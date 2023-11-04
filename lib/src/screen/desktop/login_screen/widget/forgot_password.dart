import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/controller_getx/auth_controller.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final controllerAuth = Get.put(AuthController());
  final keyForm = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Quên mật khẩu'),
        content: Container(
          alignment: Alignment.center,
          width: 500,
          height: 250,
          child: Form(
            key: keyForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
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
                  MyButton(
                    onTap: () {
                      if (keyForm.currentState!.validate()) {
                        controllerAuth.forgotPassword(
                            email: _controllerEmail.text);

                        showCustomSnackBar(
                            title: "Đã gửi",
                            message:
                                'Vui lòng kiểm tra email và lấy lại mật khẩu!!',
                            type: Type.success);

                        Navigator.pop(context);
                      }
                    },
                    backgroundColor: colorScheme(context).onSurfaceVariant,
                    height: 54,
                    text: Text(
                      'Gửi email',
                      style: text(context).titleSmall?.copyWith(
                          color: colorScheme(context).tertiary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
