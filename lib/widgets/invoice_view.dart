import 'package:flutter/material.dart';
import 'package:receipt_book/models/company_model.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/services/app_theme_style.dart';
import 'package:receipt_book/services/invoice_action_controller.dart';
import 'package:receipt_book/widgets/invoice_image_screen.dart';
import 'package:screenshot/screenshot.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({super.key, required this.invoice});

  final InvoiceModel invoice;

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  late final InvoiceActionsController _actionsController;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _actionsController = InvoiceActionsController(widget.invoice);
  }

  final GlobalKey _invoiceKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF2C3E50);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Screenshot(
            controller: screenshotController,
            child: RepaintBoundary(
              key: _invoiceKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===== HEADER =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "INVOICE",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                            letterSpacing: 2,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              "ReceiptBook",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text("Dhaka, Bangladesh"),
                            Text("Phone: +8801700000000"),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// ===== BILLING INFO =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_billTo(), _invoiceInfo()],
                    ),

                    const SizedBox(height: 20),

                    /// ===== ITEMS TABLE =====
                    const _invoiceTable(),

                    const SizedBox(height: 10),

                    /// ===== TOTAL =====
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          _priceRow(title: "Subtotal", value: "৳ 3,000.00"),
                          _priceRow(title: "Discount (5%)", value: "৳ 150.00"),
                          _priceRow(title: "VAT (5%)", value: "৳ 150.00"),
                          Divider(thickness: 1),
                          _priceRow(title: "Grand Total", value: "৳ 3,150.00", isBold: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// ===== FOOTER TEXT =====
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Thank you for your business!",
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),

          /// ===== ACTION BUTTONS =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _invoiceButton(Icons.print, "Print", () {
                _actionsController.printInvoice();
              }),
              _invoiceButton(Icons.share, "Share", () {
                _actionsController.shareInvoicePdf();
              }),
              _invoiceButton(Icons.download, "Image", _onImagePressed),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _onImagePressed() async {
    final image = await _actionsController.captureInvoiceImage(screenshotController);

    if (image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image capture failed')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoiceImageSave(imageBytes: image, fileName: widget.invoice.invoiceNo),
      ),
    );
  }
}

/// ===== REUSABLE WIDGETS =====

Widget _invoiceButton(IconData icon, String title, VoidCallback onTap) {
  return InkWell(
    focusColor: AppThemeStyle.primaryColor,
    borderRadius: BorderRadius.circular(10),
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(radius: 22, child: Icon(icon, size: 22)),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}

Widget _billTo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text("Bill To:", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 4),
      Text("Mohammad Abdullah"),
      Text("Mirpur, Dhaka"),
      Text("Phone: +8801XXXXXXXXX"),
    ],
  );
}

Widget _invoiceInfo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [Text("Invoice No: RB-1023"), Text("Invoice Date: 28 Dec 2025")],
  );
}

class _invoiceTable extends StatelessWidget {
  const _invoiceTable();

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(1), 2: FlexColumnWidth(2)},
      children: [
        _tableHeader(),
        _tableRow("Item 01", "2", "৳ 1,200.00"),
        _tableRow("Item 02", "1", "৳ 600.00"),
      ],
    );
  }
}

class _tableHeader extends TableRow {
  _tableHeader()
    : super(
        children: [
          _cell("Description", isHeader: true),
          _cell("Qty", isHeader: true),
          _cell("Amount", isHeader: true),
        ],
      );
}

class _tableRow extends TableRow {
  _tableRow(String title, String qty, String amount)
    : super(children: [_cell(title), _cell(qty), _cell(amount)]);
}

class _cell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _cell(this.text, {this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}

class _priceRow extends StatelessWidget {
  final String title, value;
  final bool isBold;

  const _priceRow({required this.title, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          const SizedBox(width: 12),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
