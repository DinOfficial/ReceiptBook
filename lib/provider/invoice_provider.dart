import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/models/item_model.dart';
import 'package:receipt_book/utils/network_checker.dart';

import '../screens/internet_access_screen.dart';

class InvoiceProvider extends ChangeNotifier {
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<InvoiceModel>> getAllInvoices(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .snapshots()
        .asyncMap((customerSnapshot) async {
      List<InvoiceModel> allInvoices = [];
      for (var customerDoc in customerSnapshot.docs) {
        final invoiceSnapshot = await customerDoc.reference.collection('invoices').get();
        for (var invoiceDoc in invoiceSnapshot.docs) {
          try {
            allInvoices.add(InvoiceModel.fromMap(invoiceDoc.data()));
          } catch (e) {
            if (kDebugMode) {
              print('Failed to parse invoice: ${invoiceDoc.id}, error: $e');
            }
          }
        }
      }
      return allInvoices;
    });
  }

  Future<void> createInvoice({
    required BuildContext context,
    required String uid,
    required CustomerModel customer,
    required String invoiceNo,
    required String status,
    required DateTime date,
    required String time,
    required String paymentSystem,
    required List<ItemModel> items,
    required double total,
  }) async {
    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, InternetAccessScreen.name, (p) => false);
      return;
    }

    _isProcessing = true;
    notifyListeners();

    try {
      final newInvoiceRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('customers')
          .doc(customer.id)
          .collection('invoices')
          .doc();

      final invoice = InvoiceModel(
        invoiceId: newInvoiceRef.id,
        invoiceNo: invoiceNo,
        customerId: customer.id!,
        customerName: customer.name,
        status: status,
        date: date,
        time: time,
        paymentSystem: paymentSystem,
        total: total,
        items: items,
      );

      await newInvoiceRef.set(invoice.toMap());

      if (kDebugMode) {
        print('invoice saved successfully !');
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice created successfully!')),
      );
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Invoice creation error: $e');
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Invoice creation error: ${e.message}'), backgroundColor: Colors.red),
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> saveInvoice(
    BuildContext context,
    String uid,
    String customerId,
    InvoiceModel invoice,
  ) async {
    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, InternetAccessScreen.name, (p) => false);
      return;
    }

    _isProcessing = true;
    notifyListeners();

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('customers')
          .doc(customerId)
          .collection('invoices')
          .doc(invoice.invoiceId)
          .set(invoice.toMap());

      if (kDebugMode) {
        print('invoice saved successfully !');
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice saved successfully!')),
      );
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Invoice save error: $e');
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice save error: ${e.message}'), backgroundColor: Colors.red),
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
