import '../models/auth_token_model.dart';
import '../models/user_model.dart';

/// Remote data source for auth API (login, register, forgot password).
abstract class AuthRemoteDataSource {
  Future<(UserModel, AuthTokenModel)> login(String email, String password);
  Future<(UserModel, AuthTokenModel)> register(
    String name,
    String email,
    String password,
  );
  Future<void> forgotPassword(String email);

  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({String? name});
}
