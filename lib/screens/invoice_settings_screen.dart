import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/invoice_settings_provider.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class InvoiceSettingsScreen extends StatelessWidget {
  const InvoiceSettingsScreen({super.key});

  static const String name = 'invoice-settings';

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<InvoiceSettingsProvider>();

    final templates = [
      InvoiceSettingsProvider.TEMPLATE_CLASSIC,
      InvoiceSettingsProvider.TEMPLATE_MODERN,
      InvoiceSettingsProvider.TEMPLATE_MINIMAL,
      InvoiceSettingsProvider.TEMPLATE_PROFESSIONAL,
    ];

    return Scaffold(
      appBar: MainAppBar(title: context.tr('invoice_settings_screen.settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.tr('invoice_settings_screen.invoice_template'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('invoice_settings_screen.select_template'),
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...templates.map((template) {
            final isSelected = settingsProvider.selectedTemplate == template;
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: isSelected ? 4 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? const Color(0xff2a8bdc) : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  settingsProvider.setTemplate(template);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(
                          color: _getTemplateColor(template),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Icon(_getTemplateIcon(template), size: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              settingsProvider.getTemplateName(template),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              settingsProvider.getTemplateDescription(template),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Color(0xff2a8bdc), size: 32),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('invoice_settings_screen.payment_methods'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => _showAddPaymentMethodDialog(context, settingsProvider),
                icon: const Icon(Icons.add_circle, color: Color(0xff2a8bdc)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (settingsProvider.paymentMethods.isEmpty)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(context.tr('invoice_settings_screen.no_payment_methods_added')),
            )
          else
            ...settingsProvider.paymentMethods.map((method) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  title: Text(method),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      settingsProvider.removePaymentMethod(method);
                    },
                  ),
                ),
              );
            }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showAddPaymentMethodDialog(BuildContext context, InvoiceSettingsProvider provider) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.tr('invoice_settings_screen.add_payment_method'), style: TextStyle(fontSize: 20)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Method Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(context.tr('invoice_settings_screen.cancel'))),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  provider.addPaymentMethod(controller.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Text(context.tr('invoice_settings_screen.add')),
            ),
          ],
        );
      },
    );
  }

  Color _getTemplateColor(String template) {
    switch (template) {
      case InvoiceSettingsProvider.TEMPLATE_CLASSIC:
        return const Color(0xff2a8bdc);
      case InvoiceSettingsProvider.TEMPLATE_MODERN:
        return const Color(0xffff6b6b);
      case InvoiceSettingsProvider.TEMPLATE_MINIMAL:
        return const Color(0xff4ecdc4);
      case InvoiceSettingsProvider.TEMPLATE_PROFESSIONAL:
        return const Color(0xff2c3e50);
      default:
        return const Color(0xff2a8bdc);
    }
  }

  IconData _getTemplateIcon(String template) {
    switch (template) {
      case InvoiceSettingsProvider.TEMPLATE_CLASSIC:
        return Icons.description;
      case InvoiceSettingsProvider.TEMPLATE_MODERN:
        return Icons.auto_awesome;
      case InvoiceSettingsProvider.TEMPLATE_MINIMAL:
        return Icons.minimize;
      case InvoiceSettingsProvider.TEMPLATE_PROFESSIONAL:
        return Icons.business_center;
      default:
        return Icons.description;
    }
  }
}
