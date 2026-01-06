import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/biometric_provider.dart';
import 'package:receipt_book/screens/app_main_layout.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/screens/company_setup_screen.dart';
import 'package:receipt_book/screens/internet_access_screen.dart';
import 'package:receipt_book/utils/network_checker.dart';
import 'package:receipt_book/utils/toast_helper.dart';
import '../screens/welcome_screen.dart';

class AuthCheckProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  Future<void> authCheckAndRedirection(
    BuildContext context, {
    bool checkBiometrics = true,
  }) async {
    if (!context.mounted) return;

    // Check internet connection
    if (!await NetworkChecker.hasInternet) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          InternetAccessScreen.name,
          (p) => false,
        );
      }
      return;
    }

    final User? user = _auth.currentUser;
    if (user == null) {
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(WelcomeScreen.name, (p) => false);
      }
      return;
    }

    try {
      // User is logged in, check company
      final uid = user.uid;
      final snapshot = await _fireStore
          .collection('users')
          .doc(uid)
          .collection('company')
          .get();

      if (!context.mounted) return;

      // Check Biometric Auth
      if (checkBiometrics) {
        final biometricProvider = context.read<BiometricProvider>();
        // Ensure provider settings are loaded before checking
        await biometricProvider.ensureInitialized();

        if (!context.mounted) return;

        print(
          '🔍 [AuthCheck] Biometric enabled: ${biometricProvider.isBiometricEnabled}, Can check: ${biometricProvider.canCheckBiometrics}',
        );
        if (biometricProvider.isBiometricEnabled &&
            biometricProvider.canCheckBiometrics) {
          print('🔍 [AuthCheck] Requesting biometric authentication...');
          bool authenticated = await biometricProvider.authenticate();

          if (!context.mounted) return;

          if (!authenticated) {
            ToastHelper.showError(context, 'Biometric authentication failed');
            Navigator.pushReplacementNamed(context, LoginScreen.name);
            return;
          }
          print('✅ [AuthCheck] Biometric authentication passed');
        } else {
          print(
            '⏭️ [AuthCheck] Skipping biometric (not enabled or not available)',
          );
        }
      }

      if (!context.mounted) return;

      if (snapshot.docs.isNotEmpty) {
        Navigator.pushReplacementNamed(context, AppMainLayout.name);
      } else {
        Navigator.pushReplacementNamed(context, CompanySetupScreen.name);
      }
    } catch (e) {
      if (context.mounted) {
        // Don't auto-redirect to Welcome on error, it confuses the user.
        // Show error and stay, or go to Login if really needed.
        ToastHelper.showError(context, 'Authentication check failed: $e');
        // Fallback to login if it's a critical state issue, but usually stay put so user can see error.
        // For now, let's NOT redirect to WelcomeScreen blindly.
      }
    }
  }
}
