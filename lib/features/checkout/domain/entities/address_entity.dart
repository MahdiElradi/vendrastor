/// Address for checkout/delivery.
class AddressEntity {
  const AddressEntity({
    required this.id,
    required this.label,
    this.street,
    this.city,
    this.country,
    this.zip,
  });
  final String id;
  final String label;
  final String? street;
  final String? city;
  final String? country;
  final String? zip;
}
