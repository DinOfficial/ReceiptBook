import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:receipt_book/screens/welcome_screen.dart';

class UserAccountDeleteProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isProcessing => _isLoading;

  Future<void> deleteAccount(BuildContext context, {String? password}) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      AuthCredential? credential;

      String providerId = user.providerData.first.providerId;

      if (providerId == 'google.com') {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
      } else if (providerId == 'password') {
        if (password == null) {
          throw Exception("Password required for this provider");
        }
        credential = EmailAuthProvider.credential(email: user.email!, password: password);
      }
      if (credential != null) {
        await user.reauthenticateWithCredential(credential);
      }
      await clearUserData(user.uid);
      await user.delete();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.name, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Error: ${e.code}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearUserData(String uid) async {
    final storeData = FirebaseFirestore.instance;
    final batch = storeData.batch();

    try {
      // delete companies data
      final companies = await storeData.collection('users').doc(uid).collection('companies').get();
      for (final company in companies.docs) {
        batch.delete(company.reference);
      }

      // delete invoice data
      final invoices = await storeData
          .collection('users')
          .doc(uid)
          .collection('customers')
          .doc(uid)
          .collection('invoices')
          .get();
      for (final invoice in invoices.docs) {
        batch.delete(invoice.reference);
      }

      // delete customer data
      final customers = await storeData.collection('users').doc(uid).collection('customers').get();
      for (final customer in customers.docs) {
        batch.delete(customer.reference);
      }

      // delete user data
      batch.delete(storeData.collection('users').doc(uid));

      await batch.commit();
      debugPrint('All Firestore data requested for deletion');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
