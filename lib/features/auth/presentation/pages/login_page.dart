import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vendrastor_app/core/config/theme/app_theme.dart';
import 'package:vendrastor_app/core/localization/l10n_extension.dart';
import 'package:vendrastor_app/core/routing/app_router.dart';
import 'package:vendrastor_app/core/widgets/app_logo.dart';
import 'package:vendrastor_app/core/widgets/loading_spinner.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/login_state.dart';

/// Login form with validation and loading state.
/// Requires [LoginCubit] and [AuthCubit] to be provided by the route.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed(AppRouter.home);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                final loginCubit = context.read<LoginCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    const Center(child: VendraStorLogo(size: 82)),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome to VendraStor',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Sign in to explore deals, track orders, and save your favorites.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.login,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      initialValue: state.email,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        errorText: state.emailError,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: loginCubit.setEmail,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      initialValue: state.password,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        errorText: state.passwordError,
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: loginCubit.togglePasswordVisibility,
                        ),
                      ),
                      obscureText: !state.showPassword,
                      textInputAction: TextInputAction.done,
                      onChanged: loginCubit.setPassword,
                      onFieldSubmitted: (_) => loginCubit.submit(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushNamed(AppRouter.forgotPassword),
                        child: Text(l10n.forgotPassword),
                      ),
                    ),
                    if (state.failure != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        state.failure!.message,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => loginCubit.submit(),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: LoadingSpinner(),
                              )
                            : Text(l10n.login),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.noAccount),
                        TextButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRouter.register),
                          child: Text(l10n.register),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
