import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/models/item_model.dart';
import 'package:receipt_book/provider/customer_provider.dart';
import 'package:receipt_book/provider/invoice_provider.dart';
import 'package:receipt_book/provider/item_provider.dart';
import 'package:receipt_book/provider/theme_mode_provider.dart';
import 'package:receipt_book/screens/create_update_customer_screen.dart';
import 'package:receipt_book/services/app_theme_style.dart';
import 'package:receipt_book/widgets/invoice_view.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

import '../models/invoice_model.dart';

class CreateUpdateInvoiceScreen extends StatefulWidget {
  const CreateUpdateInvoiceScreen({super.key, this.invoice});

  static const String name = 'create-update-invoice';
  final InvoiceModel? invoice;

  @override
  State<CreateUpdateInvoiceScreen> createState() => _CreateUpdateInvoiceScreenState();
}

class _CreateUpdateInvoiceScreenState extends State<CreateUpdateInvoiceScreen> {
  final List<String> statusItems = ['Draft', 'Sent', 'Paid'];
  final List<String> paymentSystemItems = [
    'Bank Transfer',
    'Deposit',
    'Mobile Banking',
    'Card Payment',
    'Others',
  ];

  CustomerModel? selectedCustomer;
  String? selectedStatus;
  String? selectedPaymentSystem;

  final _formKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();
  final TextEditingController _invoiceNoController = .new();
  final TextEditingController _invoiceDateController = .new();
  final TextEditingController _timeController = .new();

  // item add TEC
  final TextEditingController _itemTitleController = .new();
  final TextEditingController _itemQuantityController = .new();
  final TextEditingController _itemAmountController = .new();

  DateTime? selectedDate;

  Future<void> _selectedDate() async {
    final DateTime? pickedDate = await showDatePicker(
      barrierColor: AppThemeStyle.primaryColor.withOpacity(.3),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _invoiceDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      });
    }
  }

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      barrierColor: AppThemeStyle.primaryColor.withOpacity(.3),
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _selectedTime.format(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _invoiceNoController.text = 'INV-${(Random().nextInt(900) + 100).toString()}';
    _invoiceDateController.text = 'Select a date';
    _timeController.text = 'Select Time';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeModeProvider>();
    final itemProvider = context.watch<ItemProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final invoiceProvider = context.watch<InvoiceProvider>();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: const MainAppBar(title: 'Create New Invoice'),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Center(
            child: ElevatedButton(
              onPressed: invoiceProvider.isProcessing
                  ? null
                  : () {
                      if (itemProvider.itemList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(backgroundColor: Colors.red, content: Text('Please add items')),
                        );
                      } else {
                        if (_formKey.currentState!.validate()) {
                          invoiceProvider.createInvoice(
                            context: context,
                            uid: uid,
                            customer: selectedCustomer!,
                            invoiceNo: _invoiceNoController.text,
                            status: selectedStatus!,
                            date: selectedDate!,
                            time: _timeController.text,
                            paymentSystem: selectedPaymentSystem!,
                            items: itemProvider.itemList,
                            total: itemProvider.grandTotal,
                            subtotal: itemProvider.subtotal,
                            discount: itemProvider.discount,
                            tax: itemProvider.tax,
                          );
                        }
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> InvoiceView(invoice: widget.invoice)));
                        // itemProvider.itemList.clear();
                      }
                    },
              child: invoiceProvider.isProcessing
                  ? CircularProgressIndicator()
                  : Text('Create Invoice'),
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
              const Text('Bill To', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<List<CustomerModel>>(
                      stream: customerProvider.streamCustomers(uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();
                        final customers = snapshot.data!;
                        if (kDebugMode) {
                          print('all customer : $customers');
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
                          hint: const Text('Select customer', style: TextStyle(fontSize: 14)),
                          items: customers
                              .map(
                                (customer) => DropdownMenuItem<CustomerModel>(
                                  value: customer,
                                  child: Text(customer.name, style: const TextStyle(fontSize: 14)),
                                ),
                              )
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select customer.';
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
                        icon: HugeIconsStrokeRounded.addCircle,
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
                      decoration: const InputDecoration(
                        labelText: 'Invoice No.',
                        prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedFile02),
                        prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 34),
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
                      hint: const Text('Status', style: TextStyle(fontSize: 14)),
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
                          return 'Please select status.';
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
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar01),
                        prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 34),
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
                        labelText: 'Time',
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
                hint: const Text('Payment System', style: TextStyle(fontSize: 14)),
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
                    return 'Please select payment system.';
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
              const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: itemProvider.itemList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = itemProvider.itemList[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Row(
                      mainAxisSize: .min,
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
                      side: BorderSide(color: AppThemeStyle.primaryColor, width: .5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddItemDialog(context, itemProvider);
                  },
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
                  label: const Text('Add Item'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal'),
                  Text('৳ ${itemProvider.subtotal.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Discount'),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.number,
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
                  const Text('Tax'),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.number,
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
                  const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // void _showAddItemDialog(BuildContext context, ItemProvider itemProvider) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Add Item'),
  //         content: SingleChildScrollView(
  //           child: Form(
  //             key: _itemFormKey,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextFormField(
  //                   controller: _itemTitleController,
  //                   decoration: const InputDecoration(labelText: 'Item Title'),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter item title.';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 const SizedBox(height: 12),
  //                 TextFormField(
  //                   controller: _itemQuantityController,
  //                   decoration: const InputDecoration(labelText: 'Quantity'),
  //                   keyboardType: TextInputType.number,
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter quantity.';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 const SizedBox(height: 12),
  //                 TextFormField(
  //                   controller: _itemAmountController,
  //                   decoration: const InputDecoration(labelText: 'Amount'),
  //                   keyboardType: TextInputType.number,
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter amount.';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (_itemFormKey.currentState!.validate()) {
  //                 final item = ItemModel(
  //                   title: _itemTitleController.text,
  //                   quantity: int.parse(_itemQuantityController.text),
  //                   amount: double.parse(_itemAmountController.text),
  //                 );
  //                 Navigator.pop(context);
  //                 itemProvider.addItem(item);
  //                 _itemTitleController.clear();
  //                 _itemQuantityController.clear();
  //                 _itemAmountController.clear();
  //               }
  //             },
  //             child: const Text('Add'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showAddItemDialog(BuildContext context, ItemProvider itemProvider) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      isDismissible: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _itemFormKey,
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _itemTitleController,
                  decoration: InputDecoration(label: Text('Item Title')),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _itemQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(label: Text('Quantity')),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _itemAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(label: Text('Amount')),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      if (_itemFormKey.currentState!.validate()) {
                        final item = ItemModel(
                          title: _itemTitleController.text,
                          quantity: int.parse(_itemQuantityController.text),
                          amount: double.parse(_itemAmountController.text),
                        );
                        itemProvider.addItem(item);
                        _itemTitleController.clear();
                        _itemQuantityController.clear();
                        _itemAmountController.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Save Item'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
