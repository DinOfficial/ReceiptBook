import 'package:flutter/cupertino.dart';
import 'package:receipt_book/models/item_model.dart';

class ItemProvider extends ChangeNotifier {
  final List<ItemModel> _itemList = [];
  double _subtotal = 0.0;
  double _discount = 0.0;
  double _tax = 0.0;
  double _grandTotal = 0.0;

  List<ItemModel> get itemList => _itemList;

  double get subtotal => _subtotal;

  double get discount => _discount;

  double get tax => _tax;

  double get grandTotal => _grandTotal;

  void addItem(ItemModel items) {
    _itemList.add(items);
    _calculateTotals();
    notifyListeners();
  }

  void removeItem(int index) {
    _itemList.removeAt(index);
    _calculateTotals();
    notifyListeners();
  }

  void updateItem(int index, ItemModel item) {
    if (index >= 0 && index < _itemList.length) {
      _itemList[index] = item;
      _calculateTotals();
      notifyListeners();
    }
  }

  void _calculateTotals() {
    _subtotal = _itemList.fold(
      0.0,
      (sum, currntItem) => sum + currntItem.amount,
    );
    double discountValue = (_subtotal * _discount) / 100;
    double taxValue = ((_subtotal - discountValue) * _tax) / 100;
    _grandTotal = (_subtotal - discountValue) + taxValue;
  }

  void updateDiscount(String value) {
    _discount = double.tryParse(value) ?? 0.0;
    _calculateTotals();
    notifyListeners();
  }

  void updateTax(String value) {
    _tax = double.tryParse(value) ?? 0.0;
    _calculateTotals();
    notifyListeners();
  }

  void setItems(List<ItemModel> items, double discount, double tax) {
    _itemList.clear();
    _itemList.addAll(items);
    _discount = discount;
    _tax = tax;
    _calculateTotals();
    notifyListeners();
  }
}
