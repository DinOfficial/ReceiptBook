import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/common_provider.dart';
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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WelcomeScreenProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              alignment: Alignment.center,
              foregroundColor: Color(0xff2692ce),
              side: BorderSide(color: Color(0xff2692ce)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              // padding: EdgeInsets.zero,
            ),
          ),
          inputDecorationTheme: InputDecorationThemeData(
            hintStyle: TextStyle(color: Color(0xff2692ce)),
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
        initialRoute: SplashScreen.name,
        routes: {
          SplashScreen.name: (_) => SplashScreen(),
          WelcomeScreen.name: (_) => WelcomeScreen(),
          RegisterScreen.name: (_) => RegisterScreen(),
          LoginScreen.name: (_) => LoginScreen(),
          ForgotEmailScreen.name: (_) => ForgotEmailScreen(),
          AppMainLayout.name: (_) => AppMainLayout(),
        },
      ),
    );
  }
}
