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

  /// ======================= PRINT =========================
  Future<void> printInvoice({
    required CompanyModel company,
    required CustomerModel customer,
    required String template,
  }) async {
    final pdf = await _generatePdf(company, customer, template);
    await Printing.layoutPdf(onLayout: (_) => pdf);
  }

  /// ======================= SHARE PDF =====================
  Future<void> shareInvoicePdf({
    required CompanyModel company,
    required CustomerModel customer,
    required String template,
  }) async {
    final pdf = await _generatePdf(company, customer, template);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${invoice.invoiceNo}.pdf');
    await file.writeAsBytes(pdf);
    Share.shareXFiles([
      XFile(file.path),
    ], text: 'Invoice - ${invoice.invoiceNo}');
  }

  /// ======================= INTERNAL PDF BUILDER =========
  Future<Uint8List> generatePdf(
    CompanyModel company,
    CustomerModel customer,
    String template,
  ) async {
    final pdf = pw.Document();

    pw.ImageProvider? profileImage;
    if (company.photo.isNotEmpty && company.photo.startsWith('http')) {
      try {
        // ছবি লোড করার জন্য সর্বোচ্চ ৩ সেকেন্ড সময় দেওয়া হয়েছে, যাতে এটি আটকে না থাকে
        profileImage = await networkImage(company.photo).timeout(
          const Duration(seconds: 3),
          onTimeout: () => throw Exception('Image timeout'),
        );
      } catch (e) {
        debugPrint('Error loading logo: $e');
        profileImage = null; // ছবি না পেলে বা সময় বেশি নিলে null থাকবে
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          switch (template) {
            case 'modern':
              return _buildClassicLayout(company, customer, profileImage); // Temporary fallback
            case 'minimal':
              return _buildClassicLayout(company, customer, profileImage);
            case 'professional':
              return _buildProfessionalLayout(company, customer, profileImage);
            case 'classic':
            default:
              return _buildClassicLayout(company, customer, profileImage);
          }
        },
      ),
    );
    return pdf.save();
  }

  Future<Uint8List> _generatePdf(
    CompanyModel company,
    CustomerModel customer,
    String template,
  ) async {
    return generatePdf(company, customer, template);
  }

  // --- TEMPLATE: CLASSIC ---
  pw.Widget _buildClassicLayout(
    CompanyModel company,
    CustomerModel customer,
    pw.ImageProvider? logo,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildClassicHeader(company, logo),
        pw.SizedBox(height: 25),
        _buildClassicRecipientInfo(customer),
        pw.SizedBox(height: 20),
        _buildClassicItemsTable(),
        pw.SizedBox(height: 10),
        _buildClassicTotals(),
      ],
    );
  }

  pw.Widget _buildClassicHeader(CompanyModel company, pw.ImageProvider? logo) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Row(
          children: [
            if (logo != null)
              pw.Container(
                width: 60,
                height: 60,
                margin: const pw.EdgeInsets.only(right: 15),
                child: pw.Image(logo),
              ),
            pw.Text(
              "INVOICE",
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              company.name,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(company.address),
            pw.Text("Phone: ${company.phone}"),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildClassicRecipientInfo(CustomerModel customer) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Bill To:",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(customer.name.isNotEmpty ? customer.name : 'Unknown Customer'),
            pw.Text(customer.address),
            pw.Text("Phone: ${customer.phone}"),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text("Invoice No: ${invoice.invoiceNo}"),
            pw.Text("Date: ${invoice.date.toString().split(' ')[0]}"),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildClassicItemsTable() {
    return pw.TableHelper.fromTextArray(
      headers: ["Item", "Qty", "Amount"],
      data: invoice.items
          .map(
            (item) => [
              item.title,
              item.quantity.toString(),
              "BDT ${item.amount.toStringAsFixed(2)}",
            ],
          )
          .toList(),
    );
  }

  pw.Widget _buildClassicTotals() {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          _buildTotalRow('SubTotal', invoice.subtotal.toStringAsFixed(2)),
          _buildTotalRow('Discount', invoice.discount.toStringAsFixed(2)),
          _buildTotalRow('Tax', invoice.tax.toStringAsFixed(2)),
          pw.Divider(thickness: 1),
          _buildTotalRow('Total', invoice.total.toStringAsFixed(2), isBold: true),
        ],
      ),
    );
  }

  pw.Widget _buildProfessionalLayout(CompanyModel company, CustomerModel customer, pw.ImageProvider? logo) {
    // Basic fallback for professional to ensure it renders
    return _buildClassicLayout(company, customer, logo);
  }

  pw.Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
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
