import 'package:flutter/material.dart';

class ForgotEmailScreen extends StatefulWidget {
  const ForgotEmailScreen({super.key});

  static final String name = 'forgot-email';

  @override
  State<ForgotEmailScreen> createState() => _ForgotEmailScreenState();
}

class _ForgotEmailScreenState extends State<ForgotEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('forgot email')));
  }
}
