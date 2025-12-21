import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:receipt_book/screens/auth/forgot_email_screen.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/screens/auth/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static final String name = 'welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              // TODO: MAKE Dropdown menu
              Text('English'),
              SizedBox(width: 8,),
              HugeIcon(icon: HugeIcons.strokeRoundedInternet),

            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 24,
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 160,
                  height: 160,
                ).animate().fadeIn(duration: 900.ms),
              ),
              Text(
                '"Receipt Book"',
                style: GoogleFonts.akayaKanadaka(fontSize: 38, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _onTapGoogle,
                  child: Row(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      Image.asset(
                        'assets/images/glogo.png',
                        width: 32,
                        height: 32,
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
                height: 60,
                child: OutlinedButton(
                  onPressed: _onTapEmail,
                  child: Row(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      HugeIcon(icon: HugeIcons.strokeRoundedMail02, size: 32),
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
