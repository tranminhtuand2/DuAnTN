import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
    required this.inputType,
    this.height,
    this.validator,
    this.maxLength,
    this.enable = true,
    this.textInputFormatters,
  });
  final TextEditingController controller;
  final String labelText;
  final Icon prefixIcon;
  final bool isPassword, enable;
  final TextInputType inputType;
  final double? height;
  final int? maxLength;
  final List<FilteringTextInputFormatter>? textInputFormatters;

  final String? Function(String?)? validator; // Hàm validator
  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _isShowEye = true;

  @override
  Widget build(BuildContext context) {
    void clickShowPass() {
      setState(() {
        _isShowEye = !_isShowEye;
      });
    }

    return SizedBox(
      height: widget.height,
      child: TextFormField(
        enabled: widget.enable,
        cursorColor: colorScheme(context).onBackground,
        keyboardType: widget.inputType,
        validator: widget.validator,
        style: TextStyle(color: colorScheme(context).onBackground),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        obscureText: widget.isPassword && _isShowEye,
        maxLength: widget.maxLength,
        maxLines: null,
        inputFormatters: widget.textInputFormatters,
        decoration: InputDecoration(
          filled: true,

          fillColor: colorScheme(context).onPrimary,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    clickShowPass();
                  },
                  child: Icon(
                    !_isShowEye ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : const SizedBox(),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide.none),
          //  border: OutlineInputBorder(
          //   borderRadius: const BorderRadius.all(Radius.circular(6)),
          //   borderSide: BorderSide(
          //     width: 1,
          //     color: colorScheme(context).onBackground,
          //     style: BorderStyle.solid,
          //   ),
          // ),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: const BorderRadius.all(Radius.circular(6)),
          //   borderSide: BorderSide(
          //     width: 1,
          //     color: colorScheme(context).onBackground,
          //     style: BorderStyle.solid,
          //   ),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: const BorderRadius.all(Radius.circular(6)),
          //   borderSide: BorderSide(
          //     width: 1, color: colorScheme(context).onBackground,
          //     // style: BorderStyle.none,
          //   ),
          // ),
          labelText: widget.labelText,
          labelStyle:
              TextStyle(fontSize: 12, color: colorScheme(context).onBackground),
        ),
      ),
    );
  }
}
