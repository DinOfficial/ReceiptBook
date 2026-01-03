import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../models/invoice_model.dart';

class InvoiceActionsController {
  final InvoiceModel invoice;
  final ScreenshotController screenshotController = ScreenshotController();

  InvoiceActionsController(this.invoice);

  /// ======================= PRINT =========================
  Future<void> printInvoice() async {
    final pdf = await _generatePdf();
    await Printing.layoutPdf(onLayout: (_) => pdf);
  }

  /// ======================= SHARE PDF =====================
  Future<void> shareInvoicePdf() async {
    final pdf = await _generatePdf();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${invoice.invoiceNo}.pdf');
    await file.writeAsBytes(pdf);
    Share.shareXFiles([XFile(file.path)], text: 'Invoice - ${invoice.invoiceNo}');
  }

  /// ======================= DOWNLOAD IMAGE ================
  Future<Uint8List?> captureInvoiceImage(ScreenshotController screenshotController) async {
    try {
      final image = await screenshotController.capture(delay: const Duration(milliseconds: 500));
      return image;
    } catch (e) {
      debugPrint('Screenshot error: $e');
      return null;
    }
  }

  /// ======================= INTERNAL PDF BUILDER =========
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "INVOICE",
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      "ReceiptBook",
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text("Dhaka, Bangladesh"),
                    pw.Text("Phone: +8801700000000"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 25),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Bill To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text("Mohammad Abdullah"),
                    pw.Text("Mirpur, Dhaka"),
                    pw.Text("Phone: +8801XXXXXXXXX"),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [pw.Text("Invoice No: RB-1023"), pw.Text("Invoice Date: 28 Dec 2025")],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ["Item", "Qty", "Amount"],
              data: invoice.items
                  .map(
                    (item) => [
                      pw.Center(child: pw.Text(item.title)),
                      pw.Center(child: pw.Text(item.quantity.toString())),
                      pw.Center(child: pw.Text("BDT ${item.amount}")),
                    ],
                  )
                  .toList(),
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text('SubTotal', style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                        pw.SizedBox(width: 12),
                        pw.Text(
                          invoice.subtotal.toString(),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text('SubTotal', style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                        pw.SizedBox(width: 12),
                        pw.Text(
                          invoice.discount.toString(),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text('SubTotal', style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                        pw.SizedBox(width: 12),
                        pw.Text(
                          invoice.tax.toString(),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  pw.Divider(thickness: 1),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text('SubTotal', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 12),
                        pw.Text(
                          invoice.total.toString(),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return pdf.save();
  }
}

/// view for image export
// class _InvoiceExportView extends StatelessWidget {
//   final InvoiceModel invoice;
//
//   const _InvoiceExportView({required this.invoice});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "INVOICE",
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text("ReceiptBook", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Text("Dhaka, Bangladesh"),
//                   Text("Phone: +8801700000000"),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 25),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Bill To:", style: TextStyle(fontWeight: FontWeight.bold)),
//                   SizedBox(height: 4),
//                   Text("Mohammad Abdullah"),
//                   Text("Mirpur, Dhaka"),
//                   Text("Phone: +8801XXXXXXXXX"),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [Text("Invoice No: RB-1023"), Text("Invoice Date: 28 Dec 2025")],
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           Table(
//             border: TableBorder.all(color: Colors.grey.shade300),
//             columnWidths: const {
//               0: FlexColumnWidth(3),
//               1: FlexColumnWidth(1),
//               2: FlexColumnWidth(2),
//             },
//             children: [
//               TableRow(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//               ...invoice.items.map(
//                 (item) => TableRow(
//                   children: [
//                     Center(child: Text(item.title)),
//                     Center(child: Text(item.quantity.toString())),
//                     Center(child: Text("BDT ${item.amount}")),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           SizedBox(height: 10),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 2),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('SubTotal', style: TextStyle(fontWeight: FontWeight.normal)),
//                       SizedBox(width: 12),
//                       Text(
//                         invoice.subtotal.toString(),
//                         style: TextStyle(fontWeight: FontWeight.normal),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 2),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('SubTotal', style: TextStyle(fontWeight: FontWeight.normal)),
//                       SizedBox(width: 12),
//                       Text(
//                         invoice.discount.toString(),
//                         style: TextStyle(fontWeight: FontWeight.normal),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 2),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('SubTotal', style: TextStyle(fontWeight: FontWeight.normal)),
//                       SizedBox(width: 12),
//                       Text(invoice.tax.toString(), style: TextStyle(fontWeight: FontWeight.normal)),
//                     ],
//                   ),
//                 ),
//                 Divider(thickness: 1),
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 2),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('SubTotal', style: TextStyle(fontWeight: FontWeight.bold)),
//                       SizedBox(width: 12),
//                       Text(invoice.total.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
