import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/company_provider.dart';
import 'package:receipt_book/screens/app_main_layout.dart';
import 'package:receipt_book/utils/toast_helper.dart';

class CompanySetupScreen extends StatefulWidget {
  const CompanySetupScreen({super.key});

  static final name = 'company-setup';

  @override
  State<CompanySetupScreen> createState() => _CompanySetupScreenState();
}

class _CompanySetupScreenState extends State<CompanySetupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final companyProvider = context.read<CompanyProvider>();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        companyProvider.streamCompany(uid).first.then((companies) {
          if (companies.isNotEmpty) {
            final company = companies.first;
            setState(() {
              _nameController.text = company.name;
              _emailController.text = company.email;
              _addressController.text = company.address;
              _phoneController.text = company.phone;
            });
          }
        });
      }
    });
  }

  Future pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _image = img);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              Animate(
                effects: [
                  FadeEffect(duration: 900.milliseconds),
                  SlideEffect(),
                ],
                child: Text(
                  'Setup your company details',
                  style: GoogleFonts.akayaKanadaka(fontSize: 24, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 48),
              InkWell(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xff2692ce), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 54,
                        width: MediaQuery.of(context).size.width * .25,
                        decoration: BoxDecoration(
                          color: Color(0xff2692ce),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Logo',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _image != null ? Text(_image!.name) : Text('Select Logo')),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              if (_image != null)
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(_image!.path)),
                  ),
                ),
              SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(label: Text('Company Name')),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Company name required !';
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
                  if (value == null || value.isEmpty) {
                    return 'Email  required !';
                  }
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
              Consumer<CompanyProvider>(
                builder: (context, companyProvider, _) {
                  return Visibility(
                    visible: !companyProvider.isLoading,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _onTapSubmit,
                        child: HugeIcon(icon: HugeIcons.strokeRoundedCircleArrowRight01, size: 28),
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

  void _onTapSubmit() {
    final isFormValid = _formKey.currentState!.validate();
    if (_image == null) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      ToastHelper.showError(context, 'Please select company logo (Required for update)');
      return;
    }
    if (isFormValid) {
      addCompany();
    }
  }

  Future<void> addCompany() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String address = _addressController.text.trim();
    final String phone = _phoneController.text.trim();
    final XFile photo = _image!;

    final CompanyProvider companyProvider = context.read<CompanyProvider>();
    await companyProvider.addCompany(context, name, email, address, phone, photo);
    if (mounted) {
      clearData();
      Navigator.of(context).pushNamedAndRemoveUntil(AppMainLayout.name, (p) => false);
    }
  }

  void clearData() {
    _nameController.clear();
    _emailController.clear();
    _addressController.clear();
    _phoneController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
