import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:receipt_book/screens/auth/forgot_email_screen.dart';
import 'package:receipt_book/screens/auth/register_screen.dart';
import 'package:receipt_book/welcome_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static final String name = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                'Don\'t have an account ? Create Account',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapLogin() {
    Navigator.pushNamed(context, RegisterScreen.name);
  }
}
