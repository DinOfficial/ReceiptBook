import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/common_provider.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/widgets/welcome_app_bar.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static final String name = 'registration';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WelcomeAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Consumer<PasswordTogglerProvider>(
          builder: (context, passwordToggleProvider, _) {
            return Form(
              key: _formKey,
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
                    'Welcome',
                    style: GoogleFonts.akayaKanadaka(fontSize: 32, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '"Receipt Book"',
                    style: GoogleFonts.akayaKanadaka(
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2692ce),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _nameTEController,
                    decoration: InputDecoration(label: Text('Your Name')),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: InputDecoration(label: Text('Email')),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: passwordToggleProvider.isVisible,
                    decoration: InputDecoration(
                      label: Text('Password'),
                      suffixIcon: IconButton(
                        onPressed: () {
                          passwordToggleProvider.togglePassword();
                        },
                        icon: HugeIcon(
                          icon: passwordToggleProvider.isVisible
                              ? HugeIcons.strokeRoundedView
                              : HugeIcons.strokeRoundedViewOffSlash,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    obscureText: passwordToggleProvider.isConfirmVisible,
                    decoration: InputDecoration(
                      label: Text('Confirm Password'),
                      suffixIcon: IconButton(
                        onPressed: () {
                          passwordToggleProvider.toggleConfirmPassword();
                        },
                        icon: HugeIcon(
                          icon: passwordToggleProvider.isConfirmVisible
                              ? HugeIcons.strokeRoundedView
                              : HugeIcons.strokeRoundedViewOffSlash,
                        ),
                      ),
                    ),
                  ),
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
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onTapLogin() {
    Navigator.pushNamed(context, LoginScreen.name);
  }
}
