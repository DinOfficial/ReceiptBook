import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:receipt_book/screens/auth/forgot_email_screen.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/screens/auth/register_screen.dart';
import 'package:receipt_book/welcome_app_bar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static final String name = 'welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();

}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String selectedValue = 'English';
  List<String> items = ['English', 'বাংলা', 'हिन्दी'];

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
            SizedBox(height: 52),
            Image.asset(
              'assets/images/logo.png',
              width: 160,
              height: 160,
            ).animate().fadeIn(duration: 900.ms),
            Text(
              '"Receipt Book"',
              style: GoogleFonts.akayaKanadaka(fontSize: 38, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _onTapGoogle,
                child: Row(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  children: [
                    Image.asset(
                      'assets/images/glogo.png',
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Text('Continue with Google', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: _onTapEmail,
                child: Row(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedMail02, size: 28),
                    SizedBox(width: 8),
                    Text('Continue with Email', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: _onTapForgot,
              child: Text('Forgot Password', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
            SizedBox(height: 8),
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

  void _onTapGoogle() {}

  void _onTapEmail() {
    Navigator.pushNamed(context, RegisterScreen.name);
  }

  void _onTapForgot() {
    Navigator.pushNamed(context, ForgotEmailScreen.name);
  }

  void _onTapLogin() {
    Navigator.pushNamed(context, LogInScreen.name);
  }
}
