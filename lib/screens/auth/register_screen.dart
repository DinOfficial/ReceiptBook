import 'package:easy_localization/easy_localization.dart';
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
                    context.tr('login.welcome'),
                    style: GoogleFonts.akayaKanadaka(fontSize: 32, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '"${'login.receipt_book'}"',
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
                    decoration: InputDecoration(label: Text(context.tr('register.your_name'))),
                    validator: (String? value) {
                      if (value == null || value.isEmpty)
                        return context.tr('register.enter_your_name');
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailTEController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(label: Text(context.tr('register.email'))),
                    validator: (String? value) {
                      if (value == null || value.isEmpty)
                        return context.tr('register.enter_your_email');
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: !passwordToggleProvider.isVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text(context.tr('register.password')),
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
                      if (value == null || value.isEmpty)
                        return context.tr('register.enter_your_password');
                      if (value.length < 5) return context.tr('register.sixty_character');
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    obscureText: !passwordToggleProvider.isConfirmVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text(context.tr('register.confirm_password')),
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
                      if (value == null || value.isEmpty) {
                        return context.tr('register.enter_your_confirm_password');
                      }
                      if (_passwordTEController.text != value) {
                        return context.tr('register.password_must_confirm');
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
                          : Text(context.tr('register.register'), style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('OR')),
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
                      label: Text(context.tr('welcome_screen.continue_with_google')),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: _onTapLogin,
                    child: Text(
                      context.tr('register.have_an_account'),
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),
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
