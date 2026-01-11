import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/common_provider.dart';
import 'package:receipt_book/provider/login_provider.dart';
import 'package:receipt_book/screens/auth/forgot_email_screen.dart';
import 'package:receipt_book/screens/auth/register_screen.dart';
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
                    width: 120,
                    height: 120,
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
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(label: Text(context.tr('login.email'))),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return context.tr('login.enter_email');
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: !passwordToggleProvider.isVisible,
                    decoration: InputDecoration(
                      label: Text(context.tr('login.password')),
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
                      if (value == null || value.isEmpty) return context.tr('login.enter_password');
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ForgotEmailScreen.name);
                      },
                      child: Text(
                        context.tr('login.forgot_password'),
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: loginProvider.getEmailLoginIsLoading ? null : _onTapLogin,
                      child: loginProvider.getEmailLoginIsLoading
                          ? CircularProgressIndicator()
                          : Text(context.tr('login.log_in'), style: TextStyle(fontSize: 20)),
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
                    onPressed: _onTapRegistration,
                    child: Text(
                      context.tr('welcome_screen.don\'t_account'),
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
