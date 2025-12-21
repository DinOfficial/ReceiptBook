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
