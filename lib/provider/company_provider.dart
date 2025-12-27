import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipt_book/models/company_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controller/imgbb_controller.dart';

class CompanyProvider extends ChangeNotifier {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool get isLoading => _isLoading;

  String? get uid => _auth.currentUser?.uid;

  final _imgbb = ImgbbController();

  Future<void> addCompany(
    String name,
    String email,
    String address,
    String phone,
    XFile photo,
  ) async {
    if (uid == null) {
      if (kDebugMode) {
        print('User not logged in');
      }
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
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
      await _db.collection('users').doc(uid).collection('company').add(company.toFirestore());
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
