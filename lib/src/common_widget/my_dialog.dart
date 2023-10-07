import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';

class MyDialog extends StatelessWidget {
  const MyDialog(
      {super.key,
      this.title = "Xóa?",
      this.content = "Thao tác này sẽ xóa",
      this.labelLeadingButton = "Xác nhận",
      this.labelTraillingButton = "Hủy",
      this.hasTrailling = true,
      required this.onTapLeading,
      required this.onTapTrailling});
  final String title;
  final String content;
  final String labelLeadingButton;
  final String labelTraillingButton;
  final Function() onTapLeading;
  final Function() onTapTrailling;
  final bool hasTrailling;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(width: 1, color: colorScheme(context).tertiary)),
      contentPadding: const EdgeInsets.all(0),
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme(context).onPrimary.withOpacity(0.6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      hasTrailling
                          ? OutlinedButton(
                              style: const ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  padding: MaterialStatePropertyAll(
                                    EdgeInsets.all(18),
                                  ),
                                  side: MaterialStatePropertyAll(
                                      BorderSide.none)),
                              onPressed: onTapTrailling,
                              child: Text(
                                labelTraillingButton,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme(context)
                                        .scrim
                                        .withOpacity(0.8)),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        width: 12,
                      ),
                      MyButton(
                        backgroundColor: Colors.red,
                        text: Text(labelLeadingButton),
                        onTap: onTapLeading,
                        height: 60,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
