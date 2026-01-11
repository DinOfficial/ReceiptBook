import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:receipt_book/screens/create_update_customer_screen.dart';
import 'package:receipt_book/screens/create_update_invoice_screen.dart';

import '../widgets/main_app_bar.dart';

class AddNewScreen extends StatefulWidget {
  const AddNewScreen({super.key, required this.title});

  final String title;

  @override
  State<AddNewScreen> createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: 'Add New '),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: _onTapAddInvoice,
            child: Container(
              height: MediaQuery.of(context).size.height * .36,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff4fb6c2), Color(0xff2a8bdc)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  HugeIcon(icon: HugeIcons.strokeRoundedAddInvoice, color: Colors.white, size: 100),
                  const SizedBox(height: 12),
                  Text(
                    context.tr('add_new_screen.create_new_invoice'),
                    style: GoogleFonts.akayaKanadaka(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _onTapAddCustomer,
            child: Container(
              height: MediaQuery.of(context).size.height * .36,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff4fb6c2), Color(0xff2a8bdc)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  const HugeIcon(icon: HugeIcons.strokeRoundedUser, color: Colors.white, size: 100),
                  Text(
                    context.tr('add_new_screen.create_new_customer'),
                    style: GoogleFonts.akayaKanadaka(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapAddCustomer() {
    Navigator.pushNamed(context, CreateUpdateCustomerScreen.name);
  }

  void _onTapAddInvoice() {
    Navigator.pushNamed(context, CreateUpdateInvoiceScreen.name);
  }
}
