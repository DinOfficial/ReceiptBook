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
  final double subtotal;
  final double discount;
  final double tax;
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
    required this.subtotal,
    required this.total,
    required this.items,
    required this.discount,
    required this.tax,
  });

  InvoiceModel copyWith({
    String? invoiceId,
    String? invoiceNo,
    String? customerId,
    String? customerName,
    String? status,
    DateTime? date,
    String? time,
    String? paymentSystem,
    double? subtotal,
    double? discount,
    double? tax,
    double? total,
    List<ItemModel>? items,
  }) {
    return InvoiceModel(
      invoiceId: invoiceId ?? this.invoiceId,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      status: status ?? this.status,
      date: date ?? this.date,
      time: time ?? this.time,
      paymentSystem: paymentSystem ?? this.paymentSystem,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      items: items ?? this.items,
    );
  }

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
      'tax': tax,
      'subtotal': subtotal,
      'discount': discount,
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
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (map['tax'] as num?)?.toDouble() ?? 0.0,
      items: (map['items'] as List).map((i) => ItemModel.fromMap(i)).toList(),
    );
  }
}
