import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/models/item_model.dart';
import 'package:receipt_book/utils/network_checker.dart';

import '../screens/internet_access_screen.dart';
import '../utils/toast_helper.dart';

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
        .switchMap((customerSnapshot) {
          if (customerSnapshot.docs.isEmpty) {
            return Stream.value(<InvoiceModel>[]);
          }

          final invoiceStreams = customerSnapshot.docs.map((customerDoc) {
            return customerDoc.reference.collection('invoices').snapshots().map(
              (invoiceSnapshot) {
                return invoiceSnapshot.docs
                    .map((doc) {
                      try {
                        return InvoiceModel.fromMap(doc.data());
                      } catch (e) {
                        if (kDebugMode) {
                          print(
                            'Failed to parse invoice: ${doc.id}, error: $e',
                          );
                        }
                        return null;
                      }
                    })
                    .where((invoice) => invoice != null)
                    .cast<InvoiceModel>()
                    .toList();
              },
            );
          }).toList();

          return CombineLatestStream.list(invoiceStreams).map((listOfLists) {
            return listOfLists.expand((x) => x).toList();
          });
        });
  }

  Future<InvoiceModel?> createInvoice({
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
    required double subtotal,
    required double discount,
    required double tax,
  }) async {
    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return null;
      Navigator.pushNamedAndRemoveUntil(
        context,
        InternetAccessScreen.name,
        (p) => false,
      );
      return null;
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
        subtotal: subtotal,
        discount: discount,
        tax: tax,
      );

      await newInvoiceRef.set(invoice.toMap());

      if (kDebugMode) {
        print('invoice saved successfully !');
      }

      if (!context.mounted) return null;
      ToastHelper.showSuccess(context, 'Invoice created successfully!');
      // Navigator.pop(context); // We will handle navigation in the UI
      return invoice;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Invoice creation error: $e');
      }
      if (!context.mounted) return null;
      ToastHelper.showError(context, 'Invoice creation error: ${e.message}');
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<bool> saveInvoice(
    BuildContext context,
    String uid,
    String customerId,
    InvoiceModel invoice,
  ) async {
    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return false;
      Navigator.pushNamedAndRemoveUntil(
        context,
        InternetAccessScreen.name,
        (p) => false,
      );
      return false;
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

      if (!context.mounted) return false;
      ToastHelper.showSuccess(context, 'Invoice saved successfully!');
      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Invoice save error: $e');
      }
      if (!context.mounted) return false;
      ToastHelper.showError(context, 'Invoice save error: ${e.message}');
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> deleteInvoice(
    BuildContext context,
    String? uid,
    String? customerId,
    String? invoiceId,
  ) async {
    if (uid == null || customerId == null || invoiceId == null) return;

    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return;
      if (!context.mounted) return;
      ToastHelper.showError(context, 'No internet connection');
      return;
    }

    try {
      _isProcessing = true;
      notifyListeners();

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('customers')
          .doc(customerId)
          .collection('invoices')
          .doc(invoiceId)
          .delete();

      if (!context.mounted) return;
      ToastHelper.showSuccess(context, 'Invoice deleted successfully');
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting invoice: $e');
      }
      if (context.mounted) {
        ToastHelper.showError(context, 'Error: $e');
      }
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Use for cascading delete. context is optional as this might be called from another provider.
  Future<void> deleteInvoicesByCustomer(String uid, String customerId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('customers')
          .doc(customerId)
          .collection('invoices')
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting customer invoices: $e');
      }
      rethrow; // Propagate error to caller
    }
  }
}
