import 'package:flutter/material.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class DataPrivacyScreen extends StatelessWidget {
  const DataPrivacyScreen({super.key});

  static const String name = 'data-privacy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Data Privacy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Your privacy is important to us. This policy explains how we handle your data.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '1. Data Collection\nWe collect minimal data necessary for the app to function.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text(
              '2. Data Security\nYour data is stored securely using Firebase services.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
