import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerWidget extends StatelessWidget {
  final Uint8List pdfData;

  const PdfViewerWidget({super.key, required this.pdfData});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: Colors.amber,
        width: 500,
        child: Center(
          child: SfPdfViewer.memory(pdfData),
        ),
      ),
      actions: [
        MyButton(
            width: MediaQuery.sizeOf(context).width * 0.1,
            onTap: () => Navigator.pop(context),
            backgroundColor: Colors.grey.withOpacity(0.4),
            height: 50,
            text: Text(
              "Hủy".toUpperCase(),
              style: text(context)
                  .titleSmall
                  ?.copyWith(color: colorScheme(context).tertiary),
            )),
        const SizedBox(width: 20),
        MyButton(
            width: MediaQuery.sizeOf(context).width * 0.1,
            onTap: () {},
            backgroundColor: colorScheme(context).onSurfaceVariant,
            height: 50,
            text: Text(
              "Hoàn thành".toUpperCase(),
              style: text(context)
                  .titleSmall
                  ?.copyWith(color: colorScheme(context).tertiary),
            )),
      ],
    );
  }
}
