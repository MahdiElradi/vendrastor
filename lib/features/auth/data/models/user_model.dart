import '../../domain/entities/user_entity.dart';

/// DTO matching backend user JSON.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'email': email,
        'name': name,
      };
}
