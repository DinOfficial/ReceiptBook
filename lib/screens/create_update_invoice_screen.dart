import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:receipt_book/services/app_theme_style.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class CreateUpdateInvoiceScreen extends StatefulWidget {
  const CreateUpdateInvoiceScreen({super.key});

  static const String name = 'create-update-invoice';

  @override
  State<CreateUpdateInvoiceScreen> createState() => _CreateUpdateInvoiceScreenState();
}

class _CreateUpdateInvoiceScreenState extends State<CreateUpdateInvoiceScreen> {
  final List<String> genderItems = ['Male', 'Female'];
  final List<String> statusItems = ['Draft', 'Sent', 'Paid'];

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController _invoiceDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _selectedDate() async {
    final DateTime? pickedDate = await showDatePicker(
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
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);

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
    _invoiceDateController.text = 'Select a date';
    _timeController.text = 'Select Time';
  }

  @override
  void dispose() {
    _invoiceDateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Create New Invoice'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: IntrinsicHeight(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bill To',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: HugeIcon(icon: HugeIcons.strokeRoundedUser, size: 24),
                      ),
                      prefixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 48),
                    ),
                    hint: const Text('Select customer', style: TextStyle(fontSize: 14)),
                    items: genderItems
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item, style: const TextStyle(fontSize: 14)),
                          ),
                        )
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {},
                    onSaved: (value) {
                      selectedValue = value.toString();
                    },
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
                        color: Colors.white,
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Invoice No.',
                            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedFile02),
                            prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 48),
                          ),
                          initialValue: 'INV-001', // স্ট্যাটিক ভ্যালু
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
                            prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 48),
                          ),
                          barrierDismissible: true,
                          hint: const Text('Select customer', style: TextStyle(fontSize: 14)),
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
                              return 'Please select gender.';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                          onSaved: (value) {
                            selectedValue = value.toString();
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
                              color: Colors.white,
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
                          decoration: const InputDecoration(
                            labelText: 'Invoice Date',
                            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar01),
                            prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 48),
                          ),
                          readOnly: true,
                          onTap: () async {
                            _selectedDate();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _timeController,
                          decoration: const InputDecoration(
                            labelText: 'Time',
                            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedTimeQuarterPass),
                            prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 48),
                          ),
                          readOnly: true,
                          onTap: () async {
                            _selectTime(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // === পণ্য বা সেবার তালিকা সেকশন ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Items',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          // ভবিষ্যতে এখানে নতুন আইটেম যোগ করার লজিক থাকবে
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Item'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // স্ট্যাটিক আইটেম লিস্ট
                  _buildItemRow('Website Design', '1', '50000'),
                  const Divider(height: 24),
                  _buildItemRow('Logo Design', '2', '5000'),
                  const Divider(height: 24),

                  // === মোট গণনার সেকশন ===
                  _buildCalculationRow('Subtotal', '৳60000'),
                  const SizedBox(height: 8),
                  _buildCalculationRow('Discount (5%)', '- ৳3000'),
                  const SizedBox(height: 8),
                  _buildCalculationRow('Tax (10%)', '+ ৳5700'),
                  const Divider(thickness: 1, height: 24),
                  _buildCalculationRow('Grand Total', '৳62700', isTotal: true),

                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Save Invoice',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // একটি স্ট্যাটিক আইটেম রো তৈরি করার জন্য হেল্পার উইজেট
  Widget _buildItemRow(String name, String qty, String price) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'Qty: $qty',
                style: TextStyle(color: Theme.of(context).inputDecorationTheme.labelStyle?.color),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '৳$price',
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        ),
      ],
    );
  }

  // গণনার জন্য হেল্পার উইজেট
  Widget _buildCalculationRow(String title, String amount, {bool isTotal = false}) {
    final style = TextStyle(
      fontSize: isTotal ? 18 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(amount, style: style),
      ],
    );
  }
}
