import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/app_router.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../onboarding/domain/usecases/is_onboarding_complete_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';

/// Decides navigation to onboarding, auth, or home after splash.
class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required AuthCubit authCubit,
    required IsOnboardingCompleteUseCase isOnboardingCompleteUseCase,
  })  : _checkAuthStatusUseCase = checkAuthStatusUseCase,
        _authCubit = authCubit,
        _isOnboardingCompleteUseCase = isOnboardingCompleteUseCase,
        super(SplashState.initial());

  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final AuthCubit _authCubit;
  final IsOnboardingCompleteUseCase _isOnboardingCompleteUseCase;

  Future<void> checkAuth() async {
    emit(SplashState.loading());
    final completed = await _isOnboardingCompleteUseCase();
    if (!completed) {
      emit(SplashState.loaded(route: AppRouter.onboarding));
      return;
    }
    final user = await _checkAuthStatusUseCase();
    if (user != null) {
      _authCubit.setAuthenticated(user);
      emit(SplashState.loaded(route: AppRouter.home));
    } else {
      _authCubit.setUnauthenticated();
      emit(SplashState.loaded(route: AppRouter.login));
    }
  }
}

enum SplashStatus { initial, loading, loaded }

class SplashState {
  const SplashState({required this.status, this.route});
  final SplashStatus status;
  final String? route;

  factory SplashState.initial() =>
      const SplashState(status: SplashStatus.initial);
  factory SplashState.loading() =>
      const SplashState(status: SplashStatus.loading);
  factory SplashState.loaded({required String route}) =>
      SplashState(status: SplashStatus.loaded, route: route);
}
