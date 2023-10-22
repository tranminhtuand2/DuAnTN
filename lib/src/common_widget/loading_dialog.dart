import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    Key? key,
    required this.title,
    this.labelLeadingButton = "Hủy",
    required this.onTapLeading,
  }) : super(key: key);

  final String title;

  final String labelLeadingButton;

  final Function() onTapLeading;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: AlertDialog(
        backgroundColor: colorScheme(context).onPrimary,
        contentPadding: const EdgeInsets.all(28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorScheme(context).onBackground,
            ),
            const SizedBox(height: 20),
            Text(title,
                style: text(context)
                    .titleMedium
                    ?.copyWith(color: colorScheme(context).onBackground))
          ],
        ),
        actions: [
          MyButton(
            backgroundColor: Colors.red.withOpacity(0.8),
            text: Text(
              labelLeadingButton,
              style: text(context)
                  .titleSmall
                  ?.copyWith(color: colorScheme(context).tertiary),
            ),
            onTap: onTapLeading,
            height: 48,
          ),
        ],
      ),
    );
  }
}
