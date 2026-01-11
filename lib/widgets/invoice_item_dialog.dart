import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receipt_book/models/item_model.dart';

class InvoiceItemDialog extends StatefulWidget {
  final ItemModel? item;
  final int? index;

  const InvoiceItemDialog({super.key, this.item, this.index});

  @override
  State<InvoiceItemDialog> createState() => _InvoiceItemDialogState();
}

class _InvoiceItemDialogState extends State<InvoiceItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _quantityController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _quantityController = TextEditingController(text: widget.item?.quantity.toString() ?? '');
    _amountController = TextEditingController(text: widget.item?.amount.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;

    return AlertDialog(
      title: Text(
        isEditing
            ? context.tr('invoice_item_dialog.edit_item')
            : context.tr('invoice_item_dialog.add_item'),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: context.tr('invoice_item_dialog.item_title'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.tr('invoice_item_dialog.enter_title');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: context.tr('invoice_item_dialog.quantity'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.tr('invoice_item_dialog.enter_quantity');
                  }
                  final qty = int.tryParse(value);
                  if (qty == null || qty <= 0) {
                    return context.tr('invoice_item_dialog.valid_quantity');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: context.tr('invoice_item_dialog.amount'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.tr('invoice_item_dialog.enter_amount');
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return context.tr('invoice_item_dialog.valid_amount');
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final item = ItemModel(
                title: _titleController.text.trim(),
                quantity: int.parse(_quantityController.text.trim()),
                amount: double.parse(_amountController.text.trim()),
              );
              Navigator.pop(context, {'item': item, 'index': widget.index});
            }
          },
          child: Text(
            isEditing
                ? context.tr('invoice_item_dialog.update')
                : context.tr('invoice_item_dialog.add'),
          ),
        ),
      ],
    );
  }
}
