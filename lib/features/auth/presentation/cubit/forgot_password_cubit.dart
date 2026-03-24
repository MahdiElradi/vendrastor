import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import 'forgot_password_state.dart';

/// Handles forgot password form and submission.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._forgotPasswordUseCase)
      : super(const ForgotPasswordState());

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  void setEmail(String value) {
    emit(state.copyWith(email: value, emailError: null, failure: null));
  }

  Future<void> submit() async {
    final email = state.email.trim();
    if (email.isEmpty) {
      emit(state.copyWith(emailError: 'Email is required'));
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emit(state.copyWith(emailError: 'Enter a valid email'));
      return;
    }
    emit(state.copyWith(isLoading: true, failure: null, emailError: null));
    try {
      await _forgotPasswordUseCase(email);
      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        failure: e is Failure ? e : ServerFailure(e.toString()),
      ));
    }
  }

  void reset() {
    emit(const ForgotPasswordState());
  }
}
