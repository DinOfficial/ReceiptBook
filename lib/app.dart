import 'package:flutter/material.dart';
import 'package:receipt_book/screens/app_main_layout.dart';
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
      initialRoute: SplashScreen.name,
      routes: {
        SplashScreen.name: (_) => SplashScreen(),
        WelcomeScreen.name: (_) => WelcomeScreen(),
        AppMainLayout.name: (_) => AppMainLayout(),
      },
    );
  }
}
