/// Domain entity for the authenticated user.
class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    this.name,
  });
  final String id;
  final String email;
  final String? name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          id == other.id &&
          email == other.email &&
          name == other.name;

  @override
  int get hashCode => Object.hash(id, email, name);
}
