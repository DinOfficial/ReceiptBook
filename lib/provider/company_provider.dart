import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:receipt_book/models/company_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompanyProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addCompany(CompanyModel company) async {
    try {
      _isLoading = true;
      notifyListeners();
      await db.collection('users').doc(uid).collection('company').add(company.toFirestore());
      if (kDebugMode) {
        print('Company data save successfully!');
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
