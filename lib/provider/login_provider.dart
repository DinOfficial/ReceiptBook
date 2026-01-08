import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/screens/auth/confirm_email_verification.dart';
import 'package:receipt_book/utils/network_checker.dart';

import '../screens/internet_access_screen.dart';
import '../utils/toast_helper.dart';
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
    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        InternetAccessScreen.name,
        (p) => false,
      );
    } else {
      _isGoogleUserLoading = true;
      notifyListeners();
      try {
        final GoogleSignInAccount? googleSignIn = await GoogleSignIn().signIn();

        if (googleSignIn == null) {
          _isGoogleUserLoading = false;
          notifyListeners();
          return;
        }

        final GoogleSignInAuthentication auth =
            await googleSignIn.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);

        if (userCredential.user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
                'email': userCredential.user!.email,
                'name': userCredential.user!.displayName,
                'createdAt': DateTime.now(),
              }, SetOptions(merge: true));
          if (!context.mounted) return;
          ToastHelper.showSuccess(context, 'User login successfully');
          if (!context.mounted) return;
          await context.read<AuthCheckProvider>().authCheckAndRedirection(
            context,
            checkBiometrics: false,
          );
        }
      } catch (error) {
        if (kDebugMode) {
          print('errrrror: $error');
        }
        if (!context.mounted) return;
        ToastHelper.showError(context, 'User login failed');
      } finally {
        _isGoogleUserLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> emailSignUp(
    BuildContext context,
    String email,
    String password,
    String name,
  ) async {
    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        InternetAccessScreen.name,
        (p) => false,
      );
    } else {
      _isEmailRegisterIsLoading = true;
      notifyListeners();
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (credential.user != null) {
          await credential.user!.sendEmailVerification();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(credential.user!.uid)
              .set({
                'email': credential.user!.email,
                'name': name, // Use the name from the parameter
                'createdAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
          if (!context.mounted) return;
          ToastHelper.showInfo(
            context,
            "Verification email has been sent please check !",
          );
          Navigator.of(context).pushNamedAndRemoveUntil(
            ConfirmEmailVerification.name,
            (p) => false,
            arguments: credential.user!.email,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) return;
        ToastHelper.showError(context, e.message ?? 'User registration failed');
        if (kDebugMode) {
          print(e.code);
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
  }

  Future<void> emailLogIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        InternetAccessScreen.name,
        (p) => false,
      );
    } else {
      _isEmailLoginIsLoading = true;
      notifyListeners();
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final user = credential.user;
        if (user != null && !user.emailVerified) {
          await credential.user!.sendEmailVerification();
          if (!context.mounted) return;
          ToastHelper.showInfo(
            context,
            "Verification email has been sent please check !",
          );
          Navigator.of(context).pushNamedAndRemoveUntil(
            ConfirmEmailVerification.name,
            (p) => false,
            arguments: credential.user!.email,
          );
        } else if (user != null) {
          if (!context.mounted) return;
          ToastHelper.showSuccess(context, 'User login successfully');
          if (!context.mounted) return;
          await context.read<AuthCheckProvider>().authCheckAndRedirection(
            context,
            checkBiometrics: false,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) return;
        ToastHelper.showError(context, e.message ?? 'Login failed.');
        if (kDebugMode) {
          print(e.code);
        }
      } catch (e) {
        if (!context.mounted) return;
        ToastHelper.showError(context, 'Something went wrong');
        if (kDebugMode) {
          print(e);
        }
      } finally {
        _isEmailLoginIsLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    if (!await NetworkChecker.hasInternet) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        InternetAccessScreen.name,
        (p) => false,
      );
      return;
    }
    _isResetPasswordIsLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      ToastHelper.showInfo(
        context,
        'Password reset email sent. Please check your inbox.',
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      if (!context.mounted) return;
      ToastHelper.showError(
        context,
        e.message ?? 'Failed to send reset email.',
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (!context.mounted) return;
      ToastHelper.showError(context, 'An unexpected error occurred.');
    } finally {
      _isResetPasswordIsLoading = false;
      notifyListeners();
    }
  }
}
