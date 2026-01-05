import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/biometric_provider.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class AppAndSecurityScreen extends StatelessWidget {
  const AppAndSecurityScreen({super.key});

  static const String name = 'app_and_security';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'App & Security'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Consumer<BiometricProvider>(
            builder: (context, biometricProvider, _) {
              return SwitchListTile(
                activeColor: const Color(0xff2692ce),
                title: const Text(
                  'Biometric Login',
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: const Text(
                  'Enable biometric authentication for extra security',
                ),
                secondary: const Icon(
                  Icons.fingerprint,
                  size: 32,
                  color: Color(0xff2692ce),
                ),
                value: biometricProvider.isBiometricEnabled,
                onChanged: biometricProvider.canCheckBiometrics
                    ? (value) async {
                        await biometricProvider.toggleBiometric(value);
                      }
                    : null,
              );
            },
          ),
          // Placeholder for other security settings
          const SizedBox(height: 20),
          const ListTile(
            title: Text('Terms and Conditions'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const ListTile(
            title: Text('Data Privacy'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}
