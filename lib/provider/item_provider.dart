import 'package:flutter/cupertino.dart';
import 'package:receipt_book/models/item_model.dart';

class ItemProvider extends ChangeNotifier {
  final bool _inProgress = false;
  final List<ItemModel> _itemList = [];

  List<ItemModel> get itemList => _itemList;

  bool get inProgress => _inProgress;

  void addItem(ItemModel item) {
    _itemList.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _itemList.removeAt(index);
    notifyListeners();
  }
}
