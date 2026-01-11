import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/models/item_model.dart';
import 'package:receipt_book/provider/customer_provider.dart';
import 'package:receipt_book/provider/invoice_provider.dart';
import 'package:receipt_book/provider/invoice_settings_provider.dart';
import 'package:receipt_book/provider/item_provider.dart';
import 'package:receipt_book/provider/theme_mode_provider.dart';
import 'package:receipt_book/screens/create_update_customer_screen.dart';
import 'package:receipt_book/services/app_theme_style.dart';
import 'package:receipt_book/utils/toast_helper.dart';
import 'package:receipt_book/widgets/invoice_item_dialog.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/widgets/invoice_view.dart';

class CreateUpdateInvoiceScreen extends StatefulWidget {
  const CreateUpdateInvoiceScreen({super.key, this.invoice});

  final InvoiceModel? invoice;

  static const String name = 'create-update-invoice';

  @override
  State<CreateUpdateInvoiceScreen> createState() => _CreateUpdateInvoiceScreenState();
}

class _CreateUpdateInvoiceScreenState extends State<CreateUpdateInvoiceScreen> {
  final List<String> statusItems = ['Draft', 'Sent', 'Paid'];

  CustomerModel? selectedCustomer;
  String? selectedStatus;
  String? selectedPaymentSystem;

  final TextEditingController _invoiceNoController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _invoiceDateController = TextEditingController();
  DateTime? selectedDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _customerSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize defaults
    _invoiceNoController.text = 'INV${Random().nextInt(999999).toString().padLeft(6, '0')}';
    selectedDate = DateTime.now();
    _invoiceDateController.text = DateFormat('dd-MMM-yyyy').format(selectedDate!);
    _timeController.text = DateFormat('HH:mm a').format(DateTime.now());
    selectedStatus = statusItems[0];

    // Check if editing
    if (widget.invoice != null) {
      final inv = widget.invoice!;
      _invoiceNoController.text = inv.invoiceNo;
      selectedDate = inv.date;
      _invoiceDateController.text = DateFormat('dd-MMM-yyyy').format(selectedDate!);
      _timeController.text = inv.time;
      selectedStatus = inv.status;
      selectedPaymentSystem = inv.paymentSystem;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ItemProvider>().setItems(inv.items, inv.discount, inv.tax);
      });
    }
  }

  @override
  void dispose() {
    _invoiceNoController.dispose();
    _timeController.dispose();
    _invoiceDateController.dispose();
    _customerSearchController.dispose();
    super.dispose();
  }

  Future<void> _selectedDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _invoiceDateController.text = DateFormat('dd-MMM-yyyy').format(selectedDate!);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    } else {
      _timeController.text = TimeOfDay.now().format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeModeProvider>();
    final itemProvider = context.watch<ItemProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final invoiceProvider = context.watch<InvoiceProvider>();
    final settingsProvider = context.watch<InvoiceSettingsProvider>();
    final paymentSystemItems = settingsProvider.paymentMethods;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: MainAppBar(
        title: widget.invoice == null
            ? context.tr('create_update_invoice_screen.create_new_invoice')
            : context.tr('create_update_invoice_screen.edit_invoice'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Center(
            child: ElevatedButton(
              onPressed: invoiceProvider.isProcessing
                  ? null
                  : () async {
                      if (itemProvider.itemList.isEmpty) {
                        ToastHelper.showError(
                          context,
                          context.tr('create_update_invoice_screen.add_items'),
                        );
                      } else {
                        if (_formKey.currentState!.validate()) {
                          if (selectedCustomer == null) {
                            ToastHelper.showError(
                              context,
                              context.tr('create_update_invoice_screen.select_customer'),
                            );
                            return;
                          }
                          if (widget.invoice == null) {
                            // Create
                            final newInvoice = await invoiceProvider.createInvoice(
                              context: context,
                              uid: uid,
                              customer: selectedCustomer!,
                              invoiceNo: _invoiceNoController.text,
                              status: selectedStatus!,
                              date: selectedDate!,
                              time: _timeController.text,
                              paymentSystem: selectedPaymentSystem ?? 'Cash',
                              // Default
                              items: itemProvider.itemList,
                              total: itemProvider.grandTotal,
                              subtotal: itemProvider.subtotal,
                              discount: itemProvider.discountAmount(),
                              tax: itemProvider.taxAmount(),
                            );

                            if (newInvoice != null && context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InvoiceView(invoice: newInvoice),
                                ),
                              );
                            }
                          } else {
                            // Update
                            final updatedInvoice = widget.invoice!.copyWith(
                              invoiceNo: _invoiceNoController.text,
                              customerId: selectedCustomer!.id!,
                              customerName: selectedCustomer!.name,
                              status: selectedStatus!,
                              date: selectedDate!,
                              time: _timeController.text,
                              paymentSystem: selectedPaymentSystem ?? 'Cash',
                              items: itemProvider.itemList,
                              total: itemProvider.grandTotal,
                              subtotal: itemProvider.subtotal,
                              discount: itemProvider.discountAmount(),
                              tax: itemProvider.taxAmount(),
                            );

                            final success = await invoiceProvider.saveInvoice(
                              context,
                              uid,
                              selectedCustomer!.id!,
                              updatedInvoice,
                            );

                            if (success && context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InvoiceView(invoice: updatedInvoice),
                                ),
                              );
                            }
                          }
                        }
                      }
                    },
              child: invoiceProvider.isProcessing
                  ? CircularProgressIndicator()
                  : Text(
                      widget.invoice == null
                          ? context.tr('create_update_invoice_screen.create_invoice')
                          : context.tr('create_update_invoice_screen.update_invoice'),
                    ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('create_update_invoice_screen.bill_to'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<List<CustomerModel>>(
                      stream: customerProvider.streamCustomers(uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();
                        final customers = snapshot.data!;

                        // Handle Customer Selection for Edit Mode
                        if (widget.invoice != null && selectedCustomer == null) {
                          try {
                            selectedCustomer = customers.firstWhere(
                              (c) => c.id == widget.invoice?.customerId,
                            );
                          } catch (e) {
                            selectedCustomer = null;
                          }
                        }

                        // Ensure selectedCustomer is valid
                        final validSelectedCustomer =
                            selectedCustomer != null && customers.contains(selectedCustomer)
                            ? selectedCustomer
                            : null;

                        return DropdownButtonFormField2<CustomerModel>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: HugeIcon(icon: HugeIcons.strokeRoundedUser, size: 24),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minHeight: 24,
                              minWidth: 24,
                            ),
                          ),
                          hint: Text(context.tr('create_update_invoice_screen.customer')),
                          style: TextStyle(fontSize: 14),
                          items: customers
                              .map(
                                (customer) => DropdownMenuItem<CustomerModel>(
                                  value: customer,
                                  child: Text(customer.name, style: const TextStyle(fontSize: 14)),
                                ),
                              )
                              .toList(),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _customerSearchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                              child: TextFormField(
                                controller: _customerSearchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: context.tr('create_update_invoice_screen.search'),
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return (item.value as CustomerModel).name.toLowerCase().contains(
                                searchValue.toLowerCase(),
                              );
                            },
                          ),
                          validator: (value) {
                            if (value == null) {
                              return context.tr('create_update_invoice_screen.select_customer');
                            }
                            return null;
                          },
                          value: validSelectedCustomer,
                          onChanged: (value) {
                            setState(() {
                              selectedCustomer = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedSquareArrowDown01,
                              color: AppThemeStyle.primaryColor,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppThemeStyle.primaryColor),
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppThemeStyle.primaryColor, width: 1.5),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CreateUpdateCustomerScreen.name);
                      },
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedAddCircle,
                        color: AppThemeStyle.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _invoiceNoController,
                      decoration: InputDecoration(
                        labelText: context.tr('create_update_invoice_screen.invoice_no'),
                        prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedFile02),
                        prefixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 34),
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedDocumentAttachment),
                        prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 34),
                      ),
                      barrierDismissible: true,
                      hint: Text(
                        context.tr('create_update_invoice_screen.status'),
                        style: TextStyle(fontSize: 14),
                      ),
                      items: statusItems
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item, style: const TextStyle(fontSize: 14)),
                            ),
                          )
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return context.tr('create_update_invoice_screen.select_status');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        selectedStatus = value.toString();
                      },
                      value: selectedStatus,
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                      iconStyleData: const IconStyleData(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedSquareArrowDown01,
                          color: AppThemeStyle.primaryColor,
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppThemeStyle.primaryColor),
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _invoiceDateController,
                      readOnly: true,
                      onTap: _selectedDate,
                      decoration: InputDecoration(
                        labelText: context.tr('create_update_invoice_screen.date'),
                        prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedCalendar01),
                        prefixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 34),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      decoration: InputDecoration(
                        labelText: context.tr('create_update_invoice_screen.time'),
                        prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedStopWatch),
                        prefixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 34),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedCreditCard),
                  prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 34),
                ),
                hint: Text(
                  context.tr('create_update_invoice_screen.payment_system'),
                  style: TextStyle(fontSize: 14),
                ),
                items: paymentSystemItems
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: const TextStyle(fontSize: 14)),
                      ),
                    )
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return context.tr('create_update_invoice_screen.select_payment_system');
                  }
                  return null;
                },
                onChanged: (value) {
                  selectedPaymentSystem = value.toString();
                },
                value: selectedPaymentSystem,
                buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                iconStyleData: const IconStyleData(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedSquareArrowDown01,
                    color: AppThemeStyle.primaryColor,
                  ),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppThemeStyle.primaryColor),
                    color: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    context.tr('create_update_invoice_screen.items'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _openItemDialog(context, itemProvider);
                      },
                      icon: const HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
                      label: Text(context.tr('create_update_invoice_screen.add_items')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              itemProvider.itemList.isEmpty
                  ? SizedBox(
                      height: 140,
                      child: Center(
                        child: Column(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedCheckList,
                              color: Colors.black38,
                              size: 92,
                            ),
                            Text(
                              context.tr('create_update_invoice_screen.not_item'),
                              style: TextStyle(fontSize: 20, color: Colors.black38),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemProvider.itemList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = itemProvider.itemList[index];
                        return ListTile(
                          onTap: () =>
                              _openItemDialog(context, itemProvider, item: item, index: index),
                          title: Text(item.title),
                          subtitle: Text(
                            context.tr('create_update_invoice_screen.quantity ${item.quantity}'),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('৳ ${item.amount.toStringAsFixed(2)}'),
                              IconButton(
                                onPressed: () {
                                  itemProvider.removeItem(index);
                                },
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: AppThemeStyle.primaryColor, width: .5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 24),
              Text(
                context.tr('create_update_invoice_screen.payment_details'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.tr('create_update_invoice_screen.subtotal')),
                  Text('৳ ${itemProvider.subtotal.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${context.tr('create_update_invoice_screen.discount')} ${itemProvider.discountAmount().toStringAsFixed(2)}',
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (value) => itemProvider.updateDiscount(value),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(4),
                        hintText: '0%',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${context.tr('create_update_invoice_screen.tax')} ${itemProvider.taxAmount().toStringAsFixed(2)}',
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (value) => itemProvider.updateTax(value),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(4),
                        hintText: '0%',
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('create_update_invoice_screen.grand_total'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '৳ ${itemProvider.grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openItemDialog(
    BuildContext context,
    ItemProvider itemProvider, {
    ItemModel? item,
    int? index,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context) => InvoiceItemDialog(item: item, index: index),
    );

    if (result != null && result is Map) {
      final newItem = result['item'] as ItemModel;
      final idx = result['index'] as int?;

      if (idx != null) {
        // Edit
        itemProvider.updateItem(idx, newItem);
      } else {
        // Add
        itemProvider.addItem(newItem);
      }
    }
  }
}
