class AddressModel {
  final String id;
  final String city;
  final String street;
  final String phone;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.city,
    required this.street,
    required this.phone,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'street': street,
      'phone': phone,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(String id, Map<String, dynamic> map) {
    return AddressModel(
      id: id,
      city: map['city'] ?? '',
      street: map['street'] ?? '',
      phone: map['phone'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }
}