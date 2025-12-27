import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/theme_mode_provider.dart';
import 'package:receipt_book/screens/app_main_layout.dart';
import 'package:receipt_book/screens/auth/confirm_email_verification.dart';
import 'package:receipt_book/screens/auth/forgot_email_screen.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/screens/auth/register_screen.dart';
import 'package:receipt_book/screens/company_setup_screen.dart';
import 'package:receipt_book/screens/create_update_customer_screen.dart';
import 'package:receipt_book/screens/splash_screen.dart';
import 'package:receipt_book/screens/welcome_screen.dart';
import 'package:receipt_book/services/app_theme_style.dart';

class ReceiptBookApp extends StatefulWidget {
  const ReceiptBookApp({super.key});

  @override
  State<ReceiptBookApp> createState() => _ReceiptBookAppState();
}

class _ReceiptBookAppState extends State<ReceiptBookApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeStyle.lightTheme,
      darkTheme: AppThemeStyle.darkTheme,
      themeMode: context.watch<ThemeModeProvider>().themeMode,
      initialRoute: SplashScreen.name,
      routes: {
        SplashScreen.name: (_) => SplashScreen(),
        WelcomeScreen.name: (_) => WelcomeScreen(),
        RegistrationScreen.name: (_) => RegistrationScreen(),
        ConfirmEmailVerification.name: (_) => ConfirmEmailVerification(),
        LoginScreen.name: (_) => LoginScreen(),
        ForgotEmailScreen.name: (_) => ForgotEmailScreen(),
        AppMainLayout.name: (_) => AppMainLayout(),
        CompanySetupScreen.name: (_) => CompanySetupScreen(),
        CreateUpdateCustomerScreen.name:(_)=> CreateUpdateCustomerScreen(),
      },
    );
  }
}
