import 'package:flutter/material.dart';

import '../widgets/main_app_bar.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  static const String name = 'terms-of-service';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Terms & Conditions'),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text('''
Terms and Conditions

Effective Date: January 2026

Welcome to Receipt Book. By using this application, you agree to comply with and be bound by the following terms and conditions.

1. Use of the App
Receipt Book is designed to help users manage invoices, receipts, and customer records. You agree to use the app only for lawful business purposes.

2. User Accounts
You are responsible for maintaining the confidentiality of your account credentials. Any activity under your account is your responsibility.

3. Data Responsibility
All data entered into the app, including customer and invoice information, is managed by the user. Receipt Book is not responsible for data accuracy.

4. Account Deletion
Users may delete their account at any time using the Delete Account option available in the app. Once deleted, all data will be permanently removed.

5. Service Availability
We strive to keep the app available at all times, but we do not guarantee uninterrupted access or error-free operation.

6. Intellectual Property
All app content, design, and features are the property of Receipt Book. Unauthorized copying or misuse is prohibited.

7. Limitation of Liability
Receipt Book shall not be held liable for any loss, damage, or business interruption resulting from the use of this app.

8. Changes to Terms
We reserve the right to update these Terms and Conditions at any time. Continued use of the app indicates acceptance of the updated terms.

9. Contact Information
If you have any questions about these Terms and Conditions, please contact us at:
your-email@gmail.com
          ''', style: TextStyle(fontSize: 15, height: 1.5)),
      ),
    );
  }
}
