import 'package:flutter/material.dart';
import 'package:receipt_book/screens/app_main_layout.dart';
import 'package:receipt_book/screens/auth/forgot_email_screen.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/screens/auth/register_screen.dart';
import 'package:receipt_book/screens/splash_screen.dart';
import 'package:receipt_book/screens/welcome_screen.dart';

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
      theme: ThemeData(
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            alignment: Alignment.center,
            foregroundColor: Colors.black87,
            side: BorderSide(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            // padding: EdgeInsets.zero,
          ),
        ),
      ),
      initialRoute: SplashScreen.name,
      routes: {
        SplashScreen.name: (_) => SplashScreen(),
        WelcomeScreen.name: (_) => WelcomeScreen(),
        RegisterScreen.name: (_) => RegisterScreen(),
        LogInScreen.name: (_) => LogInScreen(),
        ForgotEmailScreen.name: (_) => ForgotEmailScreen(),
        AppMainLayout.name: (_) => AppMainLayout(),
      },
    );
  }
}
