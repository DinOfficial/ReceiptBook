import 'package:flutter/material.dart';

class WelcomeScreenProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [
    {"code": "en", "name": "English"},
    {"code": "bn", "name": "বাংলা"},
    {"code": "ar", "name": "عربي"},
  ];

  List<Map<String, dynamic>> get menuItemList => _items;

}

class PasswordTogglerProvider extends ChangeNotifier {
  bool _isVisible = false;
  bool _isConfirmVisible = false;

  void togglePassword() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    _isConfirmVisible = !_isConfirmVisible;
    notifyListeners();
  }

  bool get isVisible => _isVisible;

  bool get isConfirmVisible => _isConfirmVisible;
}
