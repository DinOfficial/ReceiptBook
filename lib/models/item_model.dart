class ItemModel {
  String title;
  String quantity;
  int amount;

  ItemModel({required this.title, required this.quantity, required this.amount});

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(title: map['title'], quantity: map['quantity'], amount: map['amount']);
  }

  Map<String, dynamic> toMap() {
    return {"title": title, "quantity": quantity, "quantity": quantity};
  }
}
