import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vendrastor_app/core/config/theme/app_theme.dart';
import 'package:vendrastor_app/core/localization/l10n_extension.dart';
import 'package:vendrastor_app/core/routing/app_router.dart';
import 'package:vendrastor_app/core/widgets/app_logo.dart';
import 'package:vendrastor_app/core/widgets/loading_spinner.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/register_cubit.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/register_state.dart';

/// Register form with validation and loading state.
/// Requires [RegisterCubit] and [AuthCubit] to be provided by the route.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
        appBar: AppBar(
          title: Text(l10n.register),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                final registerCubit = context.read<RegisterCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: VendraStorLogo(size: 82)),
                    const SizedBox(height: AppSpacing.lg),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/banners/pexels-the-glorious-studio-3584518-6716441.jpg',
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.register,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      initialValue: state.name,
                      decoration: InputDecoration(
                        labelText: l10n.name,
                        errorText: state.nameError,
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: registerCubit.setName,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      initialValue: state.email,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        errorText: state.emailError,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: registerCubit.setEmail,
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
                          onPressed: registerCubit.togglePasswordVisibility,
                        ),
                      ),
                      obscureText: !state.showPassword,
                      textInputAction: TextInputAction.next,
                      onChanged: registerCubit.setPassword,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      initialValue: state.confirmPassword,
                      decoration: InputDecoration(
                        labelText: l10n.confirmPassword,
                        errorText: state.confirmPasswordError,
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: registerCubit.togglePasswordVisibility,
                        ),
                      ),
                      obscureText: !state.showPassword,
                      textInputAction: TextInputAction.done,
                      onChanged: registerCubit.setConfirmPassword,
                      onFieldSubmitted: (_) => registerCubit.submit(),
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
                            : () => registerCubit.submit(),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: LoadingSpinner(),
                              )
                            : Text(l10n.register),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.haveAccount),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.login),
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
