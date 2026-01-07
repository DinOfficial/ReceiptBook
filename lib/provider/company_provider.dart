import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipt_book/models/company_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receipt_book/screens/internet_access_screen.dart';
import 'package:receipt_book/utils/network_checker.dart';

import '../services/imgbb_controller.dart';
import '../utils/toast_helper.dart';

class CompanyProvider extends ChangeNotifier {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool get isLoading => _isLoading;

  String? get uid => _auth.currentUser?.uid;

  final _imgbb = ImgbbController();

  Stream<List<CompanyModel>> streamCompany(String uid) {
    return _db.collection('users').doc(uid).collection('companies').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CompanyModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> addCompany(
    BuildContext context,
    String name,
    String email,
    String address,
    String phone,
    XFile photo,
  ) async {
    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, InternetAccessScreen.name, (p) => false);
      return;
    }

    if (uid == null) {
      if (kDebugMode) {
        print('User not logged in');
      }
      if (!context.mounted) return;
      ToastHelper.showError(context, 'You must be logged in to add a company.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final photoUrl = await _imgbb.uploadImage(photo);

      if (photoUrl == null) {
        throw Exception("Image upload failed!");
      }

      final company = CompanyModel(
        name: name,
        email: email,
        address: address,
        phone: phone,
        photo: photoUrl,
      );

      await _db.collection('users').doc(uid).collection('companies').add(company.toFirestore());

      if (!context.mounted) return;
      ToastHelper.showSuccess(context, 'Company data saved successfully!');
    } catch (e) {
      if (kDebugMode) {
        print('Error saving company data : $e');
      }
      if (!context.mounted) return;
      ToastHelper.showError(context, 'Error saving company data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
