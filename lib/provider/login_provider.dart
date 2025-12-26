import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:receipt_book/screens/company_setup_screen.dart';
import 'package:receipt_book/screens/welcome_screen.dart';

class GoogleLoginProvider extends ChangeNotifier {
  bool _isGoogleUserLoading = false;

  bool get getGoogleUserLoading => _isGoogleUserLoading;

  Future<void> singInWithGoogle(BuildContext context) async {
    _isGoogleUserLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleSignIn = await GoogleSignIn().signIn();

      if (googleSignIn == null) {
        _isGoogleUserLoading = false;
        return;
      }

      final GoogleSignInAuthentication auth = await googleSignIn.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        Navigator.pushNamedAndRemoveUntil(context, CompanySetupScreen.name, (p) => false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User login successfully')));
      }
    } catch (error) {
      print('errrrror: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User login failed'), backgroundColor: Colors.red,));
    }

    _isGoogleUserLoading = false;
    notifyListeners();
  }

  Future<void> googleSignOut() async {
    await GoogleSignIn().signOut();
  }
}

class LoginProvider extends ChangeNotifier {}
