import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    required this.height,
    required this.text,
    this.isDisable = false,
  });

  final Function onTap;
  final bool? isDisable;
  final Color backgroundColor;
  final double height;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDisable! ? Colors.grey.withOpacity(0.3) : backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onPressed: isDisable!
            ? null
            : () {
                onTap();
              },
        child: text,
      ),
    );
  }
}
