import 'package:flutter/material.dart';

class WelcomeScreenProvider extends ChangeNotifier {
  String? _selectedValue = 'English';
  final List<String> _items = ['English', 'বাংলা', 'हिन्दी'];

  void onChangeMenu(String? value) {
    _selectedValue = value;
    notifyListeners();
  }

  String? get selectedValue => _selectedValue;

  List<String> get menuItemList => _items;
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
