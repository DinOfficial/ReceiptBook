import 'package:flutter/cupertino.dart';
import 'package:receipt_book/models/item_model.dart';

class ItemProvider extends ChangeNotifier {
  final bool _inProgress = false;
  final List<ItemModel> _itemList = [];
  double _subtotal = 0.0;
  double _discount = 0.0;
  double _tax = 0.0;
  double _grandTotal = 0.0;

  List<ItemModel> get itemList => _itemList;

  bool get inProgress => _inProgress;

  double get subtotal => _subtotal;

  double get discount => _discount;

  double get tax => _tax;

  double get grandTotal => _grandTotal;

  void addItem(ItemModel items) {
    _itemList.add(items);
    calculateTotals(_itemList);
    notifyListeners();
  }

  void removeItem(int index) {
    _itemList.removeAt(index);
    calculateTotals(_itemList);
    notifyListeners();
  }

  void calculateTotals(List<ItemModel> items) {
    _subtotal = items.fold(0.0, (sum, currntItem) => sum + currntItem.amount);
    double discountValue = (_subtotal * _discount) / 100;
    double taxValue = ((_subtotal - discountValue) * _tax) / 100;
    _grandTotal = (_subtotal - discountValue) + taxValue;
    notifyListeners();
  }

  void updateDiscount(String value) {
    _discount = double.tryParse(value) ?? 0.0;
    notifyListeners();
  }

  void updateTax(String value) {
    _tax = double.tryParse(value) ?? 0.0;
    notifyListeners();
  }
}
