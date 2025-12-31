import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:receipt_book/models/invoice_model.dart';

class InvoiceProvider extends ChangeNotifier {
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveInvoice(String uid, String customerId, InvoiceModel invoice) async {
    try {
      _isProcessing = true;
      notifyListeners();

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
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Invoice save error: $e');
      }
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
