import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

/// Holds session state (authenticated / unauthenticated).
/// Login/Register cubits notify by calling [setAuthenticated].
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._logoutUseCase) : super(const AuthInitial());

  final LogoutUseCase _logoutUseCase;

  void setAuthenticated(UserEntity user) {
    emit(AuthAuthenticated(user));
  }

  void setUnauthenticated() {
    emit(const AuthUnauthenticated());
  }

  void setLoading() {
    emit(const AuthLoading());
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    await _logoutUseCase();
    emit(const AuthUnauthenticated());
  }

  void checkSession() {
    // No-op: actual token check is done in Splash via CheckAuthStatusUseCase.
    // This cubit is updated by Login/Register success or by Splash after restore.
  }
}
