import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/company_model.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/provider/company_provider.dart';
import 'package:receipt_book/provider/customer_provider.dart';
import 'package:receipt_book/provider/invoice_settings_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _actionsController = InvoiceActionsController(widget.invoice);
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<List<CompanyModel>>(
      stream: context.watch<CompanyProvider>().streamCompany(uid),
      builder: (context, companySnapshot) {
        if (!companySnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final companies = companySnapshot.data!;
        final company = companies.isNotEmpty
            ? companies.first
            : CompanyModel(
                name: "Company Name",
                email: "",
                address: "Address",
                phone: "",
                photo: "",
              );

        return StreamBuilder<List<CustomerModel>>(
          stream: context.watch<CustomerProvider>().streamCustomers(uid),
          builder: (context, customerSnapshot) {
            if (!customerSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final customers = customerSnapshot.data!;
            final customer = customers.firstWhere(
              (c) => c.id == widget.invoice.customerId,
              orElse: () => CustomerModel(
                id: '',
                name: 'Unknown Customer',
                address: '',
                phone: '',
              ),
            );

            return Consumer<InvoiceSettingsProvider>(
              builder: (context, settings, _) {
                return Scaffold(
                  backgroundColor: Colors.transparent, // Important for modal
                  appBar: AppBar(
                    title: const Text('Invoice Preview'),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.black),
                    titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  body: PdfPreview(
                    build: (format) => _actionsController.generatePdf(
                      company,
                      customer,
                      settings.selectedTemplate,
                    ),
                    allowPrinting: true,
                    allowSharing: true,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    loadingWidget: Center(child: CircularProgressIndicator()),
                    actions: [
                      PdfPreviewAction(
                        icon: const Icon(Icons.image),
                        onPressed: (context, build, pageFormat) async {
                          // Generate PDF bytes
                          final pdfBytes = await build(pageFormat);
                          // Rasterize the first page to image
                          await for (final page in Printing.raster(
                            pdfBytes,
                            pages: [0],
                            dpi: 72,
                          )) {
                            final image = await page.toPng();
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InvoiceImageSave(
                                    imageBytes: image,
                                    fileName:
                                        'Invoice_${widget.invoice.invoiceNo}',
                                  ),
                                ),
                              );
                            }
                            break; // Process only the first page
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
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

  const _priceRow({
    required this.title,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
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
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
