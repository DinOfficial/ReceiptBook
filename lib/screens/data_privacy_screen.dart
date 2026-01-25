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
              '🔐 Privacy Policy for Receipt Book App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Effective Date: January 2026', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'Receipt Book (“we”, “our”, “us”) is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile and web application.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('📌 Information We Collect', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'We may collect the following information:\n'
              'Personal Information (name, email address) for authentication \n'
              'Customer and invoice data entered by the user \n'
              'App usage data for performance improvement \n'
              'Customer and invoice data entered by the user \n'
              'App usage data for performance improvement',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('📌 How We Use Information', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'We use the collected information to: \n'
              'Authenticate users securely \n'
              'Manage invoices and customer records \n'
              'Improve app performance and user experience \n',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('📌 Data Storage & Security', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'All data is securely stored using Google Firebase services.\n'
              ' We implement industry-standard security measures to protect user data. \n',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('📌 Third-Party Services', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'Receipt Book uses trusted third-party services: \n'
              'Google Firebase (Authentication, Database, Storage) \n'
              'Google Sign-In \n'
              'These services may collect information as per their own privacy policies. \n',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('📌 User Rights', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'Users have the right to: \n'
              'Access their data \n'
              'Update their information \n'
              'Request account and data deletion \n'
              'To delete your account, please use the Delete Account option inside settings in the app. \n',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('📌 Data Deletion', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'When a user requests account deletion: \n'
              'Authentication data is permanently deleted \n'
              'All associated invoice and customer data is removed from our database \n',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('📌 Children’s Privacy', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'This app is intended for users aged 18 years and above. \n'
              'We do not knowingly collect data from children. \n',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('📌 Changes to This Policy', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'We may update this Privacy Policy from time to time. \n'
              'Any changes will be reflected on this page. \n',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text('📌 Contact Us', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at: \n'
              '📧 deserthookofficial@gmail.com \n',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
