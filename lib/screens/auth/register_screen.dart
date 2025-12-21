import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/welcome_app_bar.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static final String name = 'registration';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
              width: 120,
              height: 120,
            ).animate().fadeIn(duration: 900.ms),
            Text(
              'Welcome',
              style: GoogleFonts.akayaKanadaka(fontSize: 32, fontWeight: FontWeight.w400),
            ),
            Text(
              '"Receipt Book"',
              style: GoogleFonts.akayaKanadaka(fontSize: 38, fontWeight: FontWeight.w600, color: Color(0xff2692ce)),
            ),
            SizedBox(height: 16),
            TextFormField(decoration: InputDecoration(hintText: 'Email')),
            SizedBox(height: 16),
            TextFormField(decoration: InputDecoration(hintText: 'Password')),
            SizedBox(height: 24),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: Text('Log in ', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: _onTapLogin,
              child: Text(
                'Have an account ? Login',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapLogin() {
    Navigator.pushNamed(context, LoginScreen.name);
  }
}
