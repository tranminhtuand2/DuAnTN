import 'dart:typed_data';

import 'package:managerfoodandcoffee/src/model/Invoice_model.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List> createPdf(Invoice invoice) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.nunitoExtraLight();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      build: (pw.Context context) {
        final tableHeaders = ['Tên món', 'Giá'];
        final tableData = invoice.products
            .map((product) =>
                [product.tensp, "${formatPrice(product.giasp)} VNĐ"])
            .toList();

        // Create a table
        final table = pw.Table.fromTextArray(
          headers: tableHeaders,
          data: tableData,
          border: pw.TableBorder.all(),
          headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
          cellAlignment: pw.Alignment.center,
          cellStyle: pw.TextStyle(font: font),
        );

        // Calculate the total price
        final totalPrice = invoice.products.fold(
            0, (total, product) => total + (product.giasp * product.soluong));

        // Create a text widget for the total price
        final totalText = pw.Text(
          'Tổng: ${formatPrice(totalPrice)} VNĐ',
          style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
        );

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('COFFEE WIND',
                style: pw.TextStyle(
                    font: font, fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Text(
              'Hóa đơn mua hàng: (${invoice.date})',
              style: pw.TextStyle(font: font, fontSize: 16),
            ),
            pw.Text(
              'Người mua: Ban 20',
              style: pw.TextStyle(font: font, fontSize: 14),
            ),
            pw.Text(
              'Nhân viên: ${invoice.nhanvien}',
              style: pw.TextStyle(font: font, fontSize: 14),
            ),
            pw.SizedBox(height: 20),
            table,
            pw.SizedBox(height: 20),
            totalText,
          ],
        );
      },
    ),
  );

  final Uint8List pdfData = await pdf.save();
  return pdfData;

  // AnchorElement(
  //     href:
  //         "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(pdfData)}")
  //   ..setAttribute("download", "report.pdf")
  //   ..click();
}
