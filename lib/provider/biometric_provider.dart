import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricProvider extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricEnabled = false;
  bool _canCheckBiometrics = false;
  bool _isInitialized = false;
  Future<void>? _initFuture;

  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get canCheckBiometrics => _canCheckBiometrics;
  bool get isInitialized => _isInitialized;

  BiometricProvider() {
    _initFuture = _init();
  }

  Future<void> _init() async {
    await _checkBiometrics();
    await _loadSettings();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> ensureInitialized() async {
    if (_initFuture != null) {
      await _initFuture;
    }
  }

  Future<void> _checkBiometrics() async {
    try {
      final isSupported = await auth.isDeviceSupported();
      final biometrics = await auth.getAvailableBiometrics();

      _canCheckBiometrics =
          isSupported && biometrics.isNotEmpty;

    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error checking biometrics: $e");
      }
      _canCheckBiometrics = false;
    }

    notifyListeners();
  }


  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    notifyListeners();
  }

  Future<bool> authenticate() async {
    if (!_canCheckBiometrics) return false;

    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Authentication error: $e");
      }
      return false;
    }
  }

  Future<void> toggleBiometric(bool value) async {
    if (value) {
      if (!_canCheckBiometrics) return;

      bool authenticated = await authenticate();
      if (!authenticated) return;

      _isBiometricEnabled = true;
    } else {
      _isBiometricEnabled = false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', _isBiometricEnabled);
    notifyListeners();
  }

}
