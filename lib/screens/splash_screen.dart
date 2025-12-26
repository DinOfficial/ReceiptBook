import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:receipt_book/screens/app_main_layout.dart';
import 'package:receipt_book/screens/company_setup_screen.dart';
import 'package:receipt_book/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static final String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _nextScreen() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    await Future.delayed(Duration(seconds: 2));
    final uid = user?.uid;
    final hasCompany = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('company')
        .get();
    if (user == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(WelcomeScreen.name, (p) => false);
      return;
    }
    if (hasCompany.docs.isEmpty) {
      Navigator.of(context).pushNamedAndRemoveUntil(CompanySetupScreen.name, (p) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(AppMainLayout.name, (p) => false);
    }
  }

  @override
  void initState() {
    _nextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200,
          height: 200,
        ).animate().fadeIn(duration: 900.ms),
      ),
    );
  }
}
