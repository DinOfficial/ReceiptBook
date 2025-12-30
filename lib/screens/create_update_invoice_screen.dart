import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/models/item_model.dart';
import 'package:receipt_book/provider/customer_provider.dart';
import 'package:receipt_book/provider/item_provider.dart';
import 'package:receipt_book/provider/theme_mode_provider.dart';
import 'package:receipt_book/screens/create_update_customer_screen.dart';
import 'package:receipt_book/services/app_theme_style.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class CreateUpdateInvoiceScreen extends StatefulWidget {
  const CreateUpdateInvoiceScreen({super.key});

  static const String name = 'create-update-invoice';

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

  String? selectedCustomerId;
  String? selectedValue;

  final _formKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController _invoiceDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // item add TEC
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _itemAmountController = TextEditingController();

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
    _invoiceDateController.text = 'Select a date';
    _timeController.text = 'Select Time';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeModeProvider>();
    final itemProvider = context.watch<ItemProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: const MainAppBar(title: 'Create New Invoice'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
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
                        final customer = snapshot.data!;
                        return DropdownButtonFormField2<String>(
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
                          items: customer
                              .map(
                                (customer) => DropdownMenuItem<String>(
                                  value: customer.id,
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
                          value: customer.any((c) => c.id == selectedCustomerId)
                              ? selectedCustomerId
                              : null,
                          onChanged: (value) {
                            setState(() {
                              selectedCustomerId = value;
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              selectedCustomerId = value;
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
                      decoration: const InputDecoration(
                        labelText: 'Invoice No.',
                        prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedFile02),
                        prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 34),
                      ),
                      initialValue: 'INV-001',
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
                      hint: const Text('Type', style: TextStyle(fontSize: 14)),
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
                          return 'Please select type.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        selectedValue = value.toString();
                      },
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
                      decoration: const InputDecoration(
                        labelText: 'Invoice Date',
                        prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar01),
                        prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 34),
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
                        prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 34),
                      ),
                      readOnly: true,
                      onTap: () async {
                        _selectTime(context);
                      },
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
                  prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedDocumentAttachment),
                  prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 48),
                ),
                barrierDismissible: true,
                hint: const Text('Select payment system', style: TextStyle(fontSize: 14)),
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
                    return 'Please select payment.';
                  }
                  return null;
                },
                onChanged: (value) {
                  selectedValue = value.toString();
                },
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
                    color: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 24),

              // === পণ্য বা সেবার তালিকা সেকশন ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  OutlinedButton.icon(
                    onPressed: () {
                      _addInvoiceItem();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Consumer<ItemProvider>(
                builder: (context, itemProvider, _) {
                  if (itemProvider.itemList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Text('No items added yet.', style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemProvider.itemList.length,
                    itemBuilder: (context, index) {
                      return _buildItemRow(
                        itemProvider.itemList[index].title,
                        itemProvider.itemList[index].quantity,
                        itemProvider.itemList[index].amount.toString(),
                        index,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 12);
                    },
                  );
                },
              ),
              const Divider(),

              // === মোট গণনার সেকশন ===
              _buildCalculationRow('Subtotal', itemProvider.subtotal.toString()),
              const SizedBox(height: 8),
              _buildCalculationRow('Discount (5%)', '- ${itemProvider.discount.toString()}'),
              const SizedBox(height: 8),
              _buildCalculationRow('Tax (10%)', '+ ৳ ${itemProvider.tax.toString()}'),
              const Divider(thickness: 1, height: 24),
              _buildCalculationRow(
                'Grand Total',
                '৳ ${itemProvider.grandTotal.toString()}',
                isTotal: true,
              ),

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
    );
  }

  // একটি স্ট্যাটিক আইটেম রো তৈরি করার জন্য হেল্পার উইজেট
  Widget _buildItemRow(String name, String qty, String price, index) {
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
        Consumer<ItemProvider>(
          builder: (context, itemProvider, _) {
            return IconButton(
              onPressed: () {
                itemProvider.removeItem(index);
              },
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            );
          },
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

  void _addInvoiceItem() {
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
                      return 'Write item title';
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
                      return 'Write item quantity';
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
                      return 'Write item Amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Consumer<ItemProvider>(
                  builder: (context, itemProvider, _) {
                    return Visibility(
                      visible: !itemProvider.inProgress,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(onPressed: _onTapAddItem, child: Text('Save Item')),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onTapAddItem() {
    if (!_itemFormKey.currentState!.validate()) return;
    final items = ItemModel(
      title: _itemTitleController.text.trim(),
      quantity: _itemQuantityController.text.trim(),
      amount: int.parse(_itemAmountController.text.trim()),
    );
    final itemProvider = context.read<ItemProvider>();
    itemProvider.addItem(items);
    clearData();
    Navigator.pop(context);
  }

  void clearData() {
    _itemTitleController.clear();
    _itemQuantityController.clear();
    _itemAmountController.clear();
  }

  @override
  void dispose() {
    _invoiceDateController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
