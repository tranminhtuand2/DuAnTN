import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class MyDialog extends StatelessWidget {
  const MyDialog(
      {Key? key,
      required this.title,
      required this.content,
      this.labelLeadingButton = "Xác nhận",
      this.labelTraillingButton = "Hủy",
      this.hasTrailling = true,
      required this.onTapLeading,
      required this.onTapTrailling})
      : super(key: key);

  final String title;
  final String content;
  final String labelLeadingButton;
  final String labelTraillingButton;
  final Function() onTapLeading;
  final Function() onTapTrailling;
  final bool hasTrailling;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: AlertDialog(
        backgroundColor: colorScheme(context).primary.withOpacity(0.8),
        contentPadding: const EdgeInsets.all(28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: text(context).titleLarge?.copyWith(
                  color: colorScheme(context).tertiary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: text(context)
                  .titleMedium
                  ?.copyWith(color: colorScheme(context).tertiary),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                hasTrailling
                    ? Expanded(
                        child: MyButton(
                          backgroundColor:
                              colorScheme(context).tertiary.withOpacity(0.7),
                          text: Text(
                            labelTraillingButton,
                            style: text(context).titleSmall?.copyWith(
                                color: colorScheme(context).onTertiary),
                          ),
                          onTap: onTapTrailling,
                          height: 48,
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: MyButton(
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
