import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  static const String name = 'share-app';

  void _shareApp(BuildContext context) {
    Share.share('Check out this amazing ReceiptBook app! Download it now.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Share App'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.share, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Share ReceiptBook with friends!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Help us grow by sharing the app with your network.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _shareApp(context),
                  icon: const Icon(Icons.share),
                  label: const Text('Share Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
