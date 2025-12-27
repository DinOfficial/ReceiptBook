import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/common_provider.dart';
import 'package:receipt_book/provider/login_provider.dart';
import 'package:receipt_book/screens/auth/register_screen.dart';
import 'package:receipt_book/screens/company_setup_screen.dart';
import 'package:receipt_book/widgets/welcome_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static final String name = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                    width: 120,
                    height: 120,
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
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(label: Text('Email')),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Enter registered email';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Enter password';
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _onTapLogin,
                      child: Text('Log in ', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: _onTapRegistration,
                    child: Text(
                      'Don\'t have an account ? Create Account',
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
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    context.read<LoginProvider>().emailLogIn(context, email, password);
  }

  void _onTapRegistration() {
    Navigator.pushNamed(context, RegistrationScreen.name);
  }
}
