class ItemModel {
  final String title;
  final int quantity;
  final double amount;

  ItemModel({required this.title, required this.quantity, required this.amount});

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      title: map['title'] ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0, // Null-safe parsing
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'quantity': quantity,
      'amount': amount,
    };
  }
}
