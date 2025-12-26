import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogOutProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleAuth = GoogleSignIn();

  Future<void> logOut() async {
    auth.signOut();
    googleAuth.signOut();
  }
}
