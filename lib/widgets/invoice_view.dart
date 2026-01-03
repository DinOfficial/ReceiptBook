import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/provider/customer_provider.dart';
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
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Screenshot(
            controller: screenshotController,
            child: RepaintBoundary(
              key: _invoiceKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

                    StreamBuilder<List<CustomerModel>>(
                      stream: context.watch<CustomerProvider>().streamCustomers(uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Customer Loading');
                        }
                        final customers = snapshot.data;
                        final customer = customers?.firstWhere(
                          (c) => c.id == widget.invoice.customerId,
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bill To:", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(customer!.name.isNotEmpty ? customer.name : 'Unknown Customer'),
                            Text(customer.address),
                            Text(customer.phone),
                            Text('Invoice No: ${widget.invoice.invoiceNo}'),
                            Text('Date: ${DateFormat('dd-MMM-yy').format(widget.invoice.date)}'),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    /// ===== ITEMS TABLE =====
                    Row(
                      children: [
                        _cell('Description', flex: 3, isHeader: true),
                        _cell('Qty', flex: 1, isHeader: true),
                        _cell('Amount', flex: 2, isHeader: true),
                      ],
                    ),
                    ...widget.invoice.items.map((item) {
                      return Row(
                        children: [
                          _cell(item.title, flex: 3),
                          _cell(item.quantity.toString(), flex: 1),
                          _cell("৳ ${item.amount.toStringAsFixed(2)}", flex: 2),
                        ],
                      );
                    }),

                    // Table(
                    //   border: TableBorder(
                    //     top: BorderSide(color: Colors.grey.shade300),
                    //     right: BorderSide(color: Colors.grey.shade300),
                    //     bottom: BorderSide(color: Colors.grey.shade300),
                    //     left: BorderSide(color: Colors.grey.shade300),
                    //     verticalInside: BorderSide(color: Colors.grey.shade300),
                    //     horizontalInside: BorderSide(color: Colors.grey.shade300),
                    //   ),
                    //   columnWidths: const {
                    //     0: FlexColumnWidth(3),
                    //     1: FlexColumnWidth(1),
                    //     2: FlexColumnWidth(2),
                    //   },
                    //   children: [
                    //     TableRow(
                    //       children: [
                    //         TableCell(
                    //           verticalAlignment: TableCellVerticalAlignment.middle,
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(10),
                    //             child: Text(
                    //               'Description',
                    //               style: TextStyle(fontWeight: FontWeight.bold),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ),
                    //         ),
                    //         TableCell(
                    //           verticalAlignment: TableCellVerticalAlignment.middle,
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(10),
                    //             child: Text(
                    //               'Qty',
                    //               style: TextStyle(fontWeight: FontWeight.bold),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ),
                    //         ),
                    //         TableCell(
                    //           verticalAlignment: TableCellVerticalAlignment.middle,
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(10),
                    //             child: Text(
                    //               'Amount',
                    //               style: TextStyle(fontWeight: FontWeight.bold),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     ...widget.invoice.items.map(
                    //       (item) => TableRow(
                    //         children: [
                    //           TableCell(
                    //             verticalAlignment: TableCellVerticalAlignment.middle,
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(4),
                    //               child: Center(child: Text(item.title)),
                    //             ),
                    //           ),
                    //           TableCell(
                    //             verticalAlignment: TableCellVerticalAlignment.middle,
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(4),
                    //               child: Center(child: Text(item.quantity.toString())),
                    //             ),
                    //           ),
                    //           TableCell(
                    //             verticalAlignment: TableCellVerticalAlignment.middle,
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(4),
                    //               child: Center(
                    //                 child: Text("৳  ${item.amount.toStringAsFixed(2)}"),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 10),

                    /// ===== TOTAL =====
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _priceRow(
                            title: "Subtotal",
                            value: "৳ ${widget.invoice.subtotal.toStringAsFixed(2)}",
                          ),
                          _priceRow(
                            title: "Discount (5%)",
                            value: "৳ ${widget.invoice.discount.toStringAsFixed(2)}",
                          ),
                          _priceRow(
                            title: "TAX (5%)",
                            value: "৳ ${widget.invoice.tax.toStringAsFixed(2)}",
                          ),
                          Divider(thickness: 1),
                          _priceRow(
                            title: "Grand Total",
                            value: "৳ ${widget.invoice.total.toStringAsFixed(2)}",
                            isBold: true,
                          ),
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

Widget _cell(String text, {required int flex, bool isHeader = false}) {
  return Expanded(
    flex: flex,
    child: Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: Text(
        text,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    ),
  );
}
