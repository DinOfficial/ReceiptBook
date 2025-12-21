import 'package:flutter/material.dart';

// *********** Welcome Screen Provider ***************//
class WelcomeScreenProvider extends ChangeNotifier {
  String? _selectedValue = 'English';
  final List<String> _items = ['English', 'বাংলা', 'हिन्दी'];

  void _onChangeMenu(String? value) {
    _selectedValue = value;
    notifyListeners();
  }

  String? get selectedValue => _selectedValue;

  List<String> get menuItemList => _items;

  void Function(String?) get onChangeMenu => _onChangeMenu;
}

class PasswordTogglerProvider extends ChangeNotifier {
  bool _isVisible = false;
  bool _isConfirmVisible = false;

  void _togglePassword() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  void _toggleConfirmPassword() {
    _isConfirmVisible = !_isConfirmVisible;
    notifyListeners();
  }

  bool get isVisible => _isVisible;

  bool get isConfirmVisible => _isConfirmVisible;

  void Function() get togglePassword => _togglePassword;

  void Function() get toggleConfirmPassword => _toggleConfirmPassword;
}
