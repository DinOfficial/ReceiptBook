import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/welcome_app_bar.dart';

class ForgotEmailScreen extends StatefulWidget {
  const ForgotEmailScreen({super.key});

  static final String name = 'forgot-email';

  @override
  State<ForgotEmailScreen> createState() => _ForgotEmailScreenState();
}

class _ForgotEmailScreenState extends State<ForgotEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WelcomeAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ).animate().fadeIn(duration: 900.ms),
            Text(
              'Enter your email, a password \n'
              ' reset link will be sent',
              style: GoogleFonts.akayaKanadaka(fontSize: 20, fontWeight: FontWeight.w400,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(decoration: InputDecoration(label: Text('Email'))),
            SizedBox(height: 24),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: Text('Send reset link ', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
