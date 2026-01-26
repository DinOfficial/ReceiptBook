import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SettingsProvider extends ChangeNotifier{
Future<void> deleteAccount()async{
  final auth = FirebaseAuth.instance;
  final uid = auth.currentUser!.uid;
  final storeData = FirebaseFirestore.instance;
  try{

  }catch (e){

  }
}
}