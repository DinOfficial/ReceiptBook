import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/common_provider.dart';
import 'package:receipt_book/provider/login_provider.dart';
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
        child: Consumer2<PasswordTogglerProvider, LoginProvider>(
          builder: (context, passwordToggleProvider, loginProvider, _) {
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(label: Text('Your Name')),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Enter your name';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailTEController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(label: Text('Email')),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Enter your email';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: !passwordToggleProvider.isVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      if (value == null || value.isEmpty) return 'Enter your password';
                      if (value.length < 5) return 'Password must be 6 character';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    obscureText: !passwordToggleProvider.isConfirmVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Enter your confirm password';
                      if (_passwordTEController.text != value) {
                        return 'Password and confirm password must be same';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: loginProvider.getEmailRegisterIsLoading ? null : _onTapSignUp,
                      child: loginProvider.getEmailRegisterIsLoading
                          ? CircularProgressIndicator()
                          : Text('Register ', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: loginProvider.getGoogleUserLoading
                          ? null
                          : () => loginProvider.singInWithGoogle(context),
                      icon: loginProvider.getGoogleUserLoading
                          ? CircularProgressIndicator()
                          : Image.asset('assets/images/g_logo.png', height: 24, width: 24),
                      label: const Text('Sign up with Google'),
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
                  const SizedBox(height: 24,)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onTapSignUp() {
    if (_formKey.currentState!.validate()) {
      signUp();
    }
  }

  Future<void> signUp() async {
    final name = _nameTEController.text.trim();
    final email = _emailTEController.text.trim();
    final password = _confirmPasswordTEController.text;
    context.read<LoginProvider>().emailSignUp(context, email, password, name);
  }

  void _onTapLogin() {
    Navigator.pushNamed(context, LoginScreen.name);
  }
}
