import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

  /// ======================= SAVE PDF ======================
  Future<void> savePdfLocally() async {
    final pdf = await _generatePdf();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${invoice.invoiceNo}.pdf');
    await file.writeAsBytes(pdf);
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
  Future<void> downloadAsImage(GlobalKey invoiceKey) async {
    final Uint8List? image = await screenshotController.captureFromWidget(
      RepaintBoundary(
        key: invoiceKey,
        child: _InvoiceExportView(invoice: invoice),
      ),
    );

    if (image != null) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${invoice.invoiceNo}.png');
      await file.writeAsBytes(image);
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
class _InvoiceExportView extends StatelessWidget {
  final InvoiceModel invoice;

  const _InvoiceExportView({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text("Invoice: ${invoice.invoiceNo}", style: const TextStyle(fontSize: 20)),
          Text("Customer: ${invoice.customerName}"),
          Text("Total: ৳ ${invoice.total}"),
        ],
      ),
    );
  }
}
