import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class InvoiceView extends StatefulWidget {
  const InvoiceView({super.key, required this.invoice});

  final InvoiceModel invoice;

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  late final InvoiceActionsController _actionsController;
  late final Stream<List<CompanyModel>> _companyStream;
  late final Stream<List<CustomerModel>> _customerStream;

  @override
  void initState() {
    super.initState();
    _actionsController = InvoiceActionsController(widget.invoice);
    
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _companyStream = context.read<CompanyProvider>().streamCompany(uid);
      _customerStream = context.read<CustomerProvider>().streamCustomers(uid);
    } else {
      // Handle logged out state if necessary
      _companyStream = Stream.value([]);
      _customerStream = Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CompanyModel>>(
      stream: _companyStream,
      builder: (context, companySnapshot) {
        if (companySnapshot.hasError) {
          return Scaffold(body: Center(child: Text('Company Stream Error: ${companySnapshot.error}')));
        }
        
        // Show loading only if we have no data and it's still waiting
        if (companySnapshot.connectionState == ConnectionState.waiting && !companySnapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        final companies = companySnapshot.data ?? [];
        final company = companies.isNotEmpty
            ? companies.first
            : CompanyModel(name: "Company Name", email: "companyemail@email.com", address: "Address", phone: "99999999", photo: "");

        return StreamBuilder<List<CustomerModel>>(
          stream: _customerStream,
          builder: (context, customerSnapshot) {
            if (customerSnapshot.hasError) {
              return Scaffold(body: Center(child: Text('Customer Stream Error: ${customerSnapshot.error}')));
            }

            if (customerSnapshot.connectionState == ConnectionState.waiting && !customerSnapshot.hasData) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final customers = customerSnapshot.data ?? [];
            final customer = customers.firstWhere(
              (c) => c.id == widget.invoice.customerId,
              orElse: () => CustomerModel(id: '', name: 'Unknown Customer', address: '', phone: ''),
            );

            return Consumer<InvoiceSettingsProvider>(
              builder: (context, settings, _) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: const Text('Invoice Preview'),
                    backgroundColor: AppThemeStyle.primaryColor,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: Colors.white),
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.close),
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
                    loadingWidget: const Center(child: CircularProgressIndicator()),
                    actions: [
                      PdfPreviewAction(
                        icon: const Icon(Icons.image),
                        onPressed: (context, build, pageFormat) async {
                          final pdfBytes = await build(pageFormat);
                          await for (final page in Printing.raster(pdfBytes, pages: [0], dpi: 72)) {
                            final image = await page.toPng();
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InvoiceImageSave(
                                    imageBytes: image,
                                    fileName: 'Invoice_${widget.invoice.invoiceNo}',
                                  ),
                                ),
                              );
                            }
                            break;
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
