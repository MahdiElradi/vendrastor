import '../../domain/entities/user_entity.dart';

/// Session state: authenticated, unauthenticated, or loading.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final UserEntity user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAuthenticated && user == other.user;

  @override
  int get hashCode => Object.hash(runtimeType, user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthUnauthenticated;

  @override
  int get hashCode => runtimeType.hashCode;
}
