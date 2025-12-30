import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String? id;
  final String name;
  final String address;
  final String phone;

  CustomerModel({this.id, required this.name, required this.address, required this.phone});

  factory CustomerModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return CustomerModel(id: snapshot.id, name: data?['name'], address: data?['address'], phone: data?['phone']);
  }

  Map<String, dynamic> toFirestore() {
    return {"name": name, "address": address, "phone": phone};
  }
}
