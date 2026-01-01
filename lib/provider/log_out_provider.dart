import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogOutProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleAuth = GoogleSignIn();

  Future<void> logOut() async {
    try {
      await auth.signOut();
      await googleAuth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error during logout: $e');
      }
    }
  }
}
