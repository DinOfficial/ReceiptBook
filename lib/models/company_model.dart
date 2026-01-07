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

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      photo: map['photo'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {"name": name, "email": email, "address": address, "phone": phone, "photo": photo};
  }
}
