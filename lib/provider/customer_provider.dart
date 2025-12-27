import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receipt_book/models/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool get isLoading => _isLoading;

  String? get uid => _auth.currentUser?.uid;

  Future<void> addCustomer(BuildContext context, String name, String address, String phone) async {
    if (uid == null) {
      if (kDebugMode) {
        print('User not logged in');
      }
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();

      final customer = CustomerModel(name: name, address: address, phone: phone);
      await _db.collection('users').doc(uid).collection('customer').add(customer.toFirestore());
      if (kDebugMode) {
        print('Customer data save successfully!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving company data : $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
