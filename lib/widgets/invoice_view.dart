import 'package:easy_localization/easy_localization.dart';
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
import 'package:receipt_book/screens/app_main_layout.dart';
import 'package:receipt_book/screens/home_screen.dart';
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

  CompanyModel _company = CompanyModel(
    name: "Your Company",
    email: "company@email.com",
    address: "Address Not Set",
    phone: "00000000",
    photo: "",
  );

  late CustomerModel _customer;

  @override
  void initState() {
    super.initState();
    _actionsController = InvoiceActionsController(widget.invoice);

    _customer = CustomerModel(
      id: widget.invoice.customerId,
      name: widget.invoice.customerName.isEmpty ? "Customer" : widget.invoice.customerName,
      address: "",
      phone: "",
    );
    _refreshData();
  }

  Future<void> _refreshData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final companyList = await context.read<CompanyProvider>().streamCompany(uid).first;
      if (companyList.isNotEmpty && mounted) {
        setState(() => _company = companyList.first);
      }
      final customerList = await context.read<CustomerProvider>().streamCustomers(uid).first;
      final found = customerList.firstWhere((c) => c.id == widget.invoice.customerId);
      if (mounted) setState(() => _customer = found);
    } catch (e) {
      debugPrint("Data refresh skipped or failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AppMainLayout()),
            (route) => false,
          ),
        ),
      ),
      body: Consumer<InvoiceSettingsProvider>(
        builder: (context, settings, _) {
          return PdfPreview(
            build: (format) =>
                _actionsController.generatePdf(_company, _customer, settings.selectedTemplate),
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
          );
        },
      ),
    );
  }
}
