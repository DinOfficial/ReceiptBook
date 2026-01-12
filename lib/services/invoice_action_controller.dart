import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../models/company_model.dart';
import '../models/customer_model.dart';
import '../models/invoice_model.dart';

class InvoiceActionsController {
  final InvoiceModel invoice;
  final ScreenshotController screenshotController = ScreenshotController();

  InvoiceActionsController(this.invoice);

  Future<Uint8List> generatePdf(
    CompanyModel company,
    CustomerModel customer,
    String template,
  ) async {
    final pdf = pw.Document();

    pw.ImageProvider? profileImage;
    if (company.photo.isNotEmpty && company.photo.startsWith('http')) {
      try {
        profileImage = await networkImage(company.photo).timeout(
          const Duration(seconds: 1),
          onTimeout: () => throw Exception('Timeout'),
        );
      } catch (e) {
        debugPrint('Logo skipped: $e');
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {

          return _buildClassicLayout(company, customer, profileImage);
        },
      ),
    );
    return pdf.save();
  }

  pw.Widget _buildClassicLayout(CompanyModel company, CustomerModel customer, pw.ImageProvider? logo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildHeader(company, logo),
        pw.SizedBox(height: 20),
        _buildInfo(customer),
        pw.SizedBox(height: 20),
        _buildItemsTable(),
        pw.SizedBox(height: 20),
        _buildTotals(),
      ],
    );
  }

  pw.Widget _buildHeader(CompanyModel company, pw.ImageProvider? logo) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (logo != null) pw.Container(width: 50, height: 50, child: pw.Image(logo)),
            pw.Text(company.name.isEmpty ? "Your Company" : company.name, 
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text(company.address.isEmpty ? "Address Not Set" : company.address, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
      ],
    );
  }

  pw.Widget _buildInfo(CustomerModel customer) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("BILL TO:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.Text(customer.name.isEmpty ? "Customer Name" : customer.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(customer.address, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text("Invoice #: ${invoice.invoiceNo}"),
            pw.Text("Date: ${invoice.date.toString().split(' ')[0]}"),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildItemsTable() {
    return pw.TableHelper.fromTextArray(
      headers: ['Description', 'Qty', 'Price', 'Total'],
      data: invoice.items.map((item) => [
        item.title.isEmpty ? "Item" : item.title,
        item.quantity.toString(),
        item.amount.toStringAsFixed(2),
        (item.quantity * item.amount).toStringAsFixed(2),
      ]).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
      cellHeight: 25,
      cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center, 2: pw.Alignment.centerRight, 3: pw.Alignment.centerRight},
    );
  }

  pw.Widget _buildTotals() {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          _row("Subtotal", invoice.subtotal.toStringAsFixed(2)),
          _row("Discount", invoice.discount.toStringAsFixed(2)),
          _row("Tax", invoice.tax.toStringAsFixed(2)),
          pw.Divider(),
          _row("Grand Total", invoice.total.toStringAsFixed(2), isBold: true),
        ],
      ),
    );
  }

  pw.Widget _row(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.SizedBox(width: 20),
          pw.Text(value, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }
}
