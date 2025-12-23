import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

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
      appBar: MainAppBar(title: 'Add New Invoice'),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
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
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedAddInvoice,
                      color: Colors.white,
                      size: 100,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create new invoice',
                      style: GoogleFonts.akayaKanadaka(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {},
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
                    HugeIcon(icon: HugeIcons.strokeRoundedUser, color: Colors.white, size: 100),
                    Text(
                      'Create new customer',
                      style: GoogleFonts.akayaKanadaka(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
