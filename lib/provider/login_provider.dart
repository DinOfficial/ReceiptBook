import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/screens/auth/confirm_email_verification.dart';

import 'auth_check_provider.dart';

class LoginProvider extends ChangeNotifier {
  bool _isGoogleUserLoading = false;
  bool _isEmailRegisterIsLoading = false;
  bool _isEmailLoginIsLoading = false;
  bool _isResetPasswordIsLoading = false;

  bool get getGoogleUserLoading => _isGoogleUserLoading;

  bool get getEmailRegisterIsLoading => _isEmailRegisterIsLoading;

  bool get getEmailLoginIsLoading => _isEmailLoginIsLoading;

  bool get getResetPasswordIsLoading => _isResetPasswordIsLoading;

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
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        context.read<AuthCheckProvider>().authCheckAndRedirection(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User login successfully')));
      }
    } catch (error) {
      print('errrrror: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User login failed'), backgroundColor: Colors.red));
    } finally {
      _isGoogleUserLoading = false;
      notifyListeners();
    }
  }

  Future<void> emailSignUp(BuildContext context, String email, String password, String name) async {
    try {
      _isEmailRegisterIsLoading = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await credential.user!.sendEmailVerification();
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'email': credential.user!.email,
          'name': credential.user!.displayName,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Verification email has been sent please check !")));
        Navigator.of(context).pushNamedAndRemoveUntil(
          ConfirmEmailVerification.name,
          (p) => false,
          arguments: credential.user!.email,
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registration failed'), backgroundColor: Colors.red),
      );
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _isEmailRegisterIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> emailLogIn(BuildContext context, String email, String password) async {
    try {
      _isEmailLoginIsLoading = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null && !user.emailVerified) {
        await credential.user!.sendEmailVerification();
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'email': credential.user!.email,
          'name': credential.user!.displayName,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Verification email has been sent please check !")));
        Navigator.of(context).pushNamedAndRemoveUntil(
          ConfirmEmailVerification.name,
          (p) => false,
          arguments: credential.user!.email,
        );
      } else {
        context.read<AuthCheckProvider>().authCheckAndRedirection(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User login successfully')));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found for that email.'), backgroundColor: Colors.red),
        );
        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong password provided for that user.'),
            backgroundColor: Colors.red,
          ),
        );
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong'), backgroundColor: Colors.red));
    } finally {
      _isEmailLoginIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isEmailLoginIsLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
      }
    } finally {
      _isEmailLoginIsLoading = false;
      notifyListeners();
    }
  }
}
