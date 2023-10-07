import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widget/text_form_field.dart';
import '../../../../controller/RegistrationController.dart';

class RegistrationDialog extends StatelessWidget {
  final RegistrationController _controller = Get.put(RegistrationController());

  RegistrationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      title: const Text("Đăng ký"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            MyTextFormField(
                hintext: "ten dang nhap",
                labeltext: "tên đăng nhập",
                icon: const Icon(Icons.person),
                // Quy tắc cho tên người dùng: Bao gồm chữ thường, chữ hoa và số, ít nhất 6 ký tự.
                regExp: r"^[a-zA-Z0-9]{6,}$",
                isempty: "vui lòng điền tên tài khoãn",
                wrongtype: "có ký tự đặc biệt hoặc chưa đủ độ dài",
                textcontroller: _controller.userIdController,
                hint: false),
            const SizedBox(
              height: 20,
            ),
            MyTextFormField(
                hintext: "Mật Khẩu",
                labeltext: "Mật Khẩu",
                icon: const Icon(Icons.key),
                // Quy tắc cho mật khẩu: Bao gồm ít nhất 8 ký tự, bao gồm chữ thường, chữ hoa và số.
                regExp: r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$",
                isempty: "vui lòng điền tên tài khoãn",
                wrongtype:
                    "Bao gồm ít nhất 8 ký tự, bao gồm chữ thường, chữ hoa và số",
                textcontroller: _controller.passwordController,
                hint: true),
            const SizedBox(
              height: 20,
            ),
            MyTextFormField(
                hintext: "Họ và Tên",
                labeltext: "Họ và Tên",
                icon: const Icon(Icons.person),
                // Quy tắc cho tên người dùng: Bao gồm chữ thường, chữ hoa và số, ít nhất 6 ký tự.
                regExp: r"^[^\d]+$",
                isempty: "vui lòng điền tên tài khoãn",
                wrongtype:
                    "Bắt đầu bằng chữ cái, sau đó có thể là chữ cái hoặc khoảng trắng",
                textcontroller: _controller.fullNameController,
                hint: false),
            const SizedBox(
              height: 20,
            ),
            MyTextFormField(
                hintext: "Số Điện Thoại",
                labeltext: "Số Điện Thoại",
                icon: const Icon(Icons.phone),
                // Quy tắc cho tên người dùng: Bao gồm chữ thường, chữ hoa và số, ít nhất 6 ký tự.
                regExp: r"^\d{10}$|^\d{3}-\d{3}-\d{4}$",
                isempty: "vui lòng điền tên tài khoãn",
                wrongtype: "Bao gồm 10 chữ số và có thể có dấu gạch ngang.",
                textcontroller: _controller.phoneNumberController,
                hint: false),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Xử lý đăng ký ở đây
            String userId = _controller.userIdController.text;
            String password = _controller.passwordController.text;
            String fullName = _controller.fullNameController.text;
            String phoneNumber = _controller.phoneNumberController.text;

            // In thông tin đã nhập (bạn có thể thay thế bằng xử lý đăng ký thực tế)
            print("User ID: $userId");
            print("Password: $password");
            print("Full Name: $fullName");
            print("Phone Number: $phoneNumber");

            // Đóng dialog
            Navigator.of(context).pop();
          },
          child: const Text("Đăng ký"),
        ),
        ElevatedButton(
          onPressed: () {
            // Đóng dialog nếu người dùng huỷ bỏ
            Navigator.of(context).pop();
          },
          child: const Text("Huỷ"),
        ),
      ],
    );
  }
}
