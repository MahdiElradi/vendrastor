/// Represents a user shipping address.
class AddressEntity {
  const AddressEntity({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String recipientName;
  final String phone;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;

  AddressEntity copyWith({
    String? id,
    String? label,
    String? recipientName,
    String? phone,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isDefault,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'recipientName': recipientName,
      'phone': phone,
      'line1': line1,
      'line2': line2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'isDefault': isDefault,
    };
  }

  factory AddressEntity.fromMap(Map<String, dynamic> map) {
    return AddressEntity(
      id: map['id'] as String,
      label: map['label'] as String,
      recipientName: map['recipientName'] as String,
      phone: map['phone'] as String,
      line1: map['line1'] as String,
      line2: map['line2'] as String?,
      city: map['city'] as String,
      state: map['state'] as String,
      postalCode: map['postalCode'] as String,
      country: map['country'] as String,
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }
}
