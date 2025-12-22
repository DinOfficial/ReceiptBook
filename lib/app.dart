import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/common_provider.dart';
import 'package:receipt_book/provider/login_provider.dart';
import 'package:receipt_book/screens/app_main_layout.dart';
import 'package:receipt_book/screens/auth/forgot_email_screen.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/screens/auth/register_screen.dart';
import 'package:receipt_book/screens/company_setup_screen.dart';
import 'package:receipt_book/screens/home_screen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WelcomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => WelcomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => PasswordTogglerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              alignment: Alignment.center,
              foregroundColor: Color(0xff2692ce),
              side: BorderSide(color: Color(0xff2692ce)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          inputDecorationTheme: InputDecorationThemeData(
            labelStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
          ),
        ),
        initialRoute: AppMainLayout.name,
        routes: {
          SplashScreen.name: (_) => SplashScreen(),
          WelcomeScreen.name: (_) => WelcomeScreen(),
          RegistrationScreen.name: (_) => RegistrationScreen(),
          LoginScreen.name: (_) => LoginScreen(),
          ForgotEmailScreen.name: (_) => ForgotEmailScreen(),
          AppMainLayout.name: (_) => AppMainLayout(),
          CompanySetupScreen.name:(_)=> CompanySetupScreen(),
        },
      ),
    );
  }
}
