import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  final String name;
  final String email;
  final String address;
  final String phone;
  final String photo;

  CompanyModel({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.photo,
  });

  factory CompanyModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CompanyModel(
      name: data?['name'],
      email: data?['email'],
      address: data?['address'],
      phone: data?['phone'],
      photo: data?['photo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {"name": name, "email": email, "address": address, "phone": phone, "photo": photo};
  }
}
