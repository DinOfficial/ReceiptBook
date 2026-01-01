import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipt_book/models/item_model.dart';

class InvoiceModel {
  final String invoiceId;
  final String invoiceNo;
  final String customerId;
  final String customerName;
  final String status;
  final DateTime date;
  final String time;
  final String paymentSystem;
  final double total;
  final List<ItemModel> items;

  InvoiceModel({
    required this.invoiceId,
    required this.invoiceNo,
    required this.customerId,
    required this.customerName,
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
      'customerId': customerId,
      'customerName': customerName,
      'status': status,
      'date': date, // Store as DateTime, Firestore will convert to Timestamp
      'time': time,
      'paymentSystem': paymentSystem,
      'total': total,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      invoiceId: map['invoiceId'] ?? '',
      invoiceNo: map['invoiceNo'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? 'N/A',
      status: map['status'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'] ?? '',
      paymentSystem: map['paymentSystem'] ?? '',
      total: (map['total'] as num?)?.toDouble() ?? 0.0, // Null-safe parsing
      items: (map['items'] as List).map((i) => ItemModel.fromMap(i)).toList(),
    );
  }
}
