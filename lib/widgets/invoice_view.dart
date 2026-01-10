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
      _companyStream = Stream.value([]);
      _customerStream = Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CompanyModel>>(
      stream: _companyStream,
      builder: (context, companySnapshot) {
        final companies = companySnapshot.data ?? [];
        final company = companies.isNotEmpty
            ? companies.first
            : CompanyModel(
                name: "Your Company Name",
                email: "company@email.com",
                address: "Your Address",
                phone: "01XXXXXXXXX",
                photo: "",
              );

        return StreamBuilder<List<CustomerModel>>(
          stream: _customerStream,
          builder: (context, customerSnapshot) {
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
                    loadingWidget: const SizedBox.shrink(),
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


