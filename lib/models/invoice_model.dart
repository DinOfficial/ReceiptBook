import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipt_book/models/item_model.dart';

class InvoiceModel {
  final String invoiceId;
  final String invoiceNo;
  final String status;
  final DateTime date;
  final String time;
  final String paymentSystem;
  final double total;
  final List<ItemModel> items;

  InvoiceModel({
    required this.invoiceId,
    required this.invoiceNo,
    required this.status,
    required this.date,
    required this.time,
    required this.paymentSystem,
    required this.total,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'invoiceNo': invoiceNo,
      'status': status,
      'date': date.toIso8601String(),
      'time': time,
      'paymentSystem': paymentSystem,
      'total': total,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      invoiceId: map['invoiceId'],
      invoiceNo: map['invoiceNo'],
      status: map['status'],
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'],
      paymentSystem: map['paymentSystem'],
      total: (map['total'] as double).toDouble(),
      items: (map['items'] as List).map((i) => ItemModel.fromMap(i)).toList(),
    );
  }
}
