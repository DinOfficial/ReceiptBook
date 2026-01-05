import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/customer_provider.dart';
import 'package:receipt_book/utils/toast_helper.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class CreateUpdateCustomerScreen extends StatefulWidget {
  const CreateUpdateCustomerScreen({super.key});

  static final name = 'create-update-customer';

  @override
  State<CreateUpdateCustomerScreen> createState() =>
      _CreateUpdateCustomerScreenState();
}

class _CreateUpdateCustomerScreenState
    extends State<CreateUpdateCustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: 'Create customer'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              SizedBox(height: 32),
              Text(
                'Add customer to create invoice',
                style: GoogleFonts.akayaKanadaka(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              TextFormField(
                controller: _nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(label: Text('Customer name')),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Customer name required !';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(label: Text('Email')),
                validator: (String? value) {
                  // Optional email, or valid email check?
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(label: Text('Address')),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Address  required !';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(label: Text('Phone')),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone  required !';
                  }
                  return null;
                },
              ),
              SizedBox(height: 28),
              Consumer<CustomerProvider>(
                builder: (context, customerProvider, _) {
                  return Visibility(
                    visible: !customerProvider.isLoading,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _addCustomer,
                        child: Text('Add', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _addCustomer() {
    if (_formKey.currentState!.validate()) {
      addCustomer();
    }
  }

  Future<void> addCustomer() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    context.read<CustomerProvider>().addCustomer(
      context,
      name,
      address,
      phone,
      email,
    );
    if (mounted) {
      clearData();
      ToastHelper.showSuccess(context, 'Customer data save successfully!');
    } else {
      ToastHelper.showError(context, 'Error saving customer data');
    }
  }

  void clearData() {
    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
