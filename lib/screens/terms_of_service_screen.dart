import 'package:flutter/material.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  static const String name = 'terms-of-service';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Terms and Conditions'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to ReceiptBook. By using this app, you agree to the following terms...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '1. Usage\nYou agree to use this app for lawful purposes only.',
              style: TextStyle(fontSize: 14),
            ),
            // Add more dummy content as needed
          ],
        ),
      ),
    );
  }
}
