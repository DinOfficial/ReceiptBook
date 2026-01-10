import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/biometric_provider.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class AppAndSecurityScreen extends StatefulWidget {
  const AppAndSecurityScreen({super.key});

  static const String name = 'app_and_security';

  @override
  State<AppAndSecurityScreen> createState() => _AppAndSecurityScreenState();
}

class _AppAndSecurityScreenState extends State<AppAndSecurityScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BiometricProvider>(context, listen: false).ensureInitialized();
    });
  }

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
                title: const Text('Biometric Login', style: TextStyle(fontSize: 20)),
                subtitle: Text(
                  biometricProvider.canCheckBiometrics
                      ? 'Use fingerprint or face unlock for extra security'
                      : 'No biometric credentials found. Please add fingerprint or face lock in device settings',
                ),
                secondary: const Icon(Icons.fingerprint, size: 32, color: Color(0xff2692ce)),
                value: biometricProvider.isBiometricEnabled,
                onChanged: biometricProvider.canCheckBiometrics
                    ? (value) async {
                        await biometricProvider.toggleBiometric(value);
                      }
                    : null,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
