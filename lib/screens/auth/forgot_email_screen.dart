import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/login_provider.dart';

import '../../widgets/welcome_app_bar.dart';

class ForgotEmailScreen extends StatefulWidget {
  const ForgotEmailScreen({super.key});

  static final String name = 'forgot-email';

  @override
  State<ForgotEmailScreen> createState() => _ForgotEmailScreenState();
}

class _ForgotEmailScreenState extends State<ForgotEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WelcomeAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Consumer<LoginProvider>(
            builder: (context, logiProvider, _) {
              return Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ).animate().fadeIn(duration: 900.ms),
                  Text(
                    '${context.tr('forgot_email_screen.enter_email')}\n'
                    ' ${context.tr('forgot_email_screen.a_password_reset_link')}',
                    style: GoogleFonts.akayaKanadaka(fontSize: 20, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text(context.tr('forgot_email_screen.email')),
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await logiProvider.resetPassword(context, _emailController.text.trim());
                        }
                      },
                      child: logiProvider.getResetPasswordIsLoading
                          ? CircularProgressIndicator()
                          : Text(
                              context.tr('forgot_email_screen.send_reset_link'),
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
