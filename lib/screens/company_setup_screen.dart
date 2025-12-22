import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:receipt_book/screens/app_main_layout.dart';

class CompanySetupScreen extends StatefulWidget {
  const CompanySetupScreen({super.key});

  static final name = 'company-setup';

  @override
  State<CompanySetupScreen> createState() => _CompanySetupScreenState();
}

class _CompanySetupScreenState extends State<CompanySetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
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
              onTap: () {},
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
                    Expanded(child: Text('Select your company logo')),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(decoration: InputDecoration(label: Text('Company Name'))),
            SizedBox(height: 12),
            TextFormField(decoration: InputDecoration(label: Text('Email'))),
            SizedBox(height: 12),
            TextFormField(decoration: InputDecoration(label: Text('Address'))),
            SizedBox(height: 12),
            TextFormField(decoration: InputDecoration(label: Text('Phone'))),
            SizedBox(height: 28),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _onTapSubmit,
                child: HugeIcon(icon: HugeIcons.strokeRoundedCircleArrowRight01, size: 28),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _onTapSubmit() {
    Navigator.pushNamedAndRemoveUntil(context, AppMainLayout.name, (p) => false);
  }
}
