import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../screens/app_main_layout.dart';
import '../screens/company_setup_screen.dart';
import '../screens/welcome_screen.dart';

class AuthCheckProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  Future<void> authCheckAndRedirection(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    if (!context.mounted) return;

    final User? user = _auth.currentUser;

    if (user == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(WelcomeScreen.name, (p) => false);
      return;
    }
    try {
      final uid = user.uid;
      final hasCompany = await _fireStore.collection('users').doc(uid).collection('company').get();
      if (!context.mounted) return;
      if (hasCompany.docs.isEmpty) {
        Navigator.of(context).pushNamedAndRemoveUntil(CompanySetupScreen.name, (p) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(AppMainLayout.name, (p) => false);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(WelcomeScreen.name, (p) => false);
      }
    }
  }
}
