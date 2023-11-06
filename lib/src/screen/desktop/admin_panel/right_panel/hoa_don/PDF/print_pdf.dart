import 'dart:convert';
import 'dart:typed_data';

import 'package:managerfoodandcoffee/src/model/invoice_model.dart';
import 'package:managerfoodandcoffee/src/utils/format_price.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;

Future<Uint8List> createPdf(Invoice invoice) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.nunitoExtraLight();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      build: (pw.Context context) {
        final tableHeaders = ['Tên món', 'Giá'];
        final tableData = invoice.products
            .map(
                (product) => [product.tensp, "${formatPrice(product.giasp)} đ"])
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
        double totalPrice = invoice.products.fold(
            0, (total, product) => total + (product.giasp * product.soluong));
        double totalPriceCoupons = totalPrice;
        // Create a text widget for the total price
        invoice.persentCoupons != 0 && invoice.persentCoupons != null
            ? totalPriceCoupons = totalPrice -
                ((totalPrice *
                        int.parse(
                          invoice.persentCoupons.toString(),
                        )) /
                    100)
            : totalPrice;
        final totalText = pw.Text(
          'Tổng: ${formatPrice(totalPrice.toInt())} VNĐ',
          style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
        );
        final totalTextCoupons = pw.Text(
          'Thành tiền: ${formatPrice(int.parse(totalPriceCoupons.toString()))} đ',
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
              'Người mua: Bàn ${invoice.tableName}',
              style: pw.TextStyle(font: font, fontSize: 14),
            ),
            pw.Text(
              'Nhân viên: ${invoice.nhanvien}',
              style: pw.TextStyle(font: font, fontSize: 14),
            ),
            pw.SizedBox(height: 20),
            table,
            pw.SizedBox(height: 10),
            totalText,
            pw.SizedBox(height: 4),
            invoice.persentCoupons != 0 && invoice.persentCoupons != null
                ? pw.Text("-${invoice.persentCoupons}%",
                    style: pw.TextStyle(font: font))
                : pw.SizedBox(),
            pw.SizedBox(height: 4),
            invoice.persentCoupons != 0 && invoice.persentCoupons != null
                ? totalTextCoupons
                : pw.SizedBox(),
          ],
        );
      },
    ),
  );

  final Uint8List pdfData = await pdf.save();
  return pdfData;
}

void downloadPDF(Uint8List pdfData, String date) {
  final blob = html.Blob([pdfData]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "$date.pdf")
    ..click();
  html.Url.revokeObjectUrl(url);
}

void createPDFAndDownload(Invoice invoice) async {
  Uint8List filePDF = await createPdf(invoice);
  downloadPDF(filePDF, invoice.date);
}
