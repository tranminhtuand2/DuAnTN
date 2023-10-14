import 'package:flutter/material.dart';

class BottomSheetItem extends StatelessWidget {
  final Icon icon;
  final String title;
  Function? function;
  BottomSheetItem({
    Key? key,
    required this.icon,
    required this.title,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function!();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 20,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
