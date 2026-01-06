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

  /// ======================= DOWNLOAD IMAGE ================
  Future<Uint8List?> captureInvoiceImage(
    ScreenshotController screenshotController,
  ) async {
    try {
      final image = await screenshotController.capture(
        delay: const Duration(milliseconds: 500),
      );
      return image;
    } catch (e) {
      debugPrint('Screenshot error: $e');
      return null;
    }
  }

  /// ======================= INTERNAL PDF BUILDER =========
  Future<Uint8List> generatePdf(
    CompanyModel company,
    CustomerModel customer,
    String template,
  ) async {
    final pdf = pw.Document();

    // Fetch image if present
    // Fetch image if present
    pw.ImageProvider? profileImage;
    if (company.photo.isNotEmpty) {
      try {
        final provider = await Printing.convertHtml(
          format: PdfPageFormat.a4,
          html: '<html><img src="${company.photo}"></html>',
        );
        // Note: convertHtml returns bytes of a PDF. This isn't efficient for just an image.
        // Better to use network fetch if allowed.
        // Printing package 'networkImage' helper:
        final netImage = await networkImage(company.photo);
        profileImage = netImage;
      } catch (e) {
        debugPrint('Error loading logo: $e');
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          switch (template) {
            case 'modern':
              return _buildModernLayout(company, customer, profileImage);
            case 'minimal':
              return _buildMinimalLayout(company, customer, profileImage);
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

  // --- TEMPLATE: CLASSIC (Original) ---
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
            pw.Text(
              customer.name.isNotEmpty ? customer.name : 'Unknown Customer',
            ),
            pw.Text(customer.address),
            pw.Text("Phone: ${customer.phone}"),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Invoice No: ${invoice.invoiceNo}"),
            pw.Text("Invoice Date: ${invoice.date.toString().split(' ')[0]}"),
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
              pw.Center(child: pw.Text(item.title)),
              pw.Center(child: pw.Text(item.quantity.toString())),
              pw.Center(child: pw.Text("BDT ${item.amount}")),
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
          _buildTotalRow('SubTotal', invoice.subtotal.toString()),
          _buildTotalRow('Discount', invoice.discount.toString()),
          _buildTotalRow('Tax', invoice.tax.toString()),
          pw.Divider(thickness: 1),
          _buildTotalRow('Total', invoice.total.toString(), isBold: true),
        ],
      ),
    );
  }

  // --- TEMPLATE: MODERN ---
  pw.Widget _buildModernLayout(
    CompanyModel company,
    CustomerModel customer,
    pw.ImageProvider? logo,
  ) {
    final pdfColor = PdfColors.blue600;
    return pw.Column(
      children: [
        pw.Header(
          level: 0,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(
                children: [
                  if (logo != null)
                    pw.Container(
                      width: 50,
                      height: 50,
                      margin: const pw.EdgeInsets.only(right: 10),
                      child: pw.Image(logo),
                    ),
                  pw.Text(
                    company.name,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: pdfColor,
                    ),
                  ),
                ],
              ),
              pw.Text(
                "INVOICE",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        //...
        //...
        //...
      ],
    );
  }

  // --- TEMPLATE: MINIMAL ---
  pw.Widget _buildMinimalLayout(
    CompanyModel company,
    CustomerModel customer,
    pw.ImageProvider? logo,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            if (logo != null)
              pw.Container(
                width: 40,
                height: 40,
                margin: const pw.EdgeInsets.only(right: 10),
                child: pw.Image(logo),
              ),
            pw.Text(
              "INVOICE",
              style: pw.TextStyle(fontSize: 20, letterSpacing: 5),
            ),
          ],
        ),
        pw.SizedBox(height: 30),
        //...
        //...
      ],
    );
  }

  // --- TEMPLATE: PROFESSIONAL ---
  pw.Widget _buildProfessionalLayout(
    CompanyModel company,
    CustomerModel customer,
    pw.ImageProvider? logo,
  ) {
    final bg = PdfColors.grey200;
    return pw.Column(
      children: [
        pw.Container(
          color: bg,
          padding: const pw.EdgeInsets.all(20),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    company.name,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(company.address),
                  pw.Text(company.phone),
                ],
              ),
              pw.Text(
                "INVOICE",
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "INVOICE TO:",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(customer.name, style: pw.TextStyle(fontSize: 14)),
                pw.Text(customer.address),
                pw.Text(customer.phone),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  "INVOICE #: ${invoice.invoiceNo}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text("DATE: ${invoice.date.toString().split(' ')[0]}"),
                pw.Text("STATUS: ${invoice.status}"),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.TableHelper.fromTextArray(
          headers: ["ITEM DESCRIPTION", "QUANTITY", "TOTAL"],
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
          headerDecoration: pw.BoxDecoration(color: PdfColors.black),
          cellAlignment: pw.Alignment.centerLeft,
          data: invoice.items
              .map(
                (item) => [
                  item.title,
                  item.quantity.toString(),
                  "BDT ${item.amount}",
                ],
              )
              .toList(),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Container(
              width: 200,
              child: pw.Column(
                children: [
                  _buildTotalRow('SUBTOTAL', invoice.subtotal.toString()),
                  _buildTotalRow('DISCOUNT', invoice.discount.toString()),
                  _buildTotalRow('TAX', invoice.tax.toString()),
                  pw.Container(height: 1, color: PdfColors.black),
                  _buildTotalRow(
                    'GRAND TOTAL',
                    invoice.total.toString(),
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.Spacer(),
        pw.Text(
          "Thank you for your business.",
          style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
        ),
      ],
    );
  }

  pw.Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
