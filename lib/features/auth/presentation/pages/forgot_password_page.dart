import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vendrastor_app/core/config/theme/app_theme.dart';
import 'package:vendrastor_app/core/localization/l10n_extension.dart';
import 'package:vendrastor_app/core/widgets/loading_spinner.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/forgot_password_state.dart';

/// Forgot password form; sends reset link to email.
/// Requires [ForgotPasswordCubit] to be provided by the route.
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.forgotPasswordTitle),
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
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.forgotPasswordHint),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              final cubit = context.read<ForgotPasswordCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.forgotPasswordHint,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  TextFormField(
                    initialValue: state.email,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      errorText: state.emailError,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onChanged: cubit.setEmail,
                    onFieldSubmitted: (_) => cubit.submit(),
                  ),
                  if (state.failure != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      state.failure!.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          state.isLoading ? null : () => cubit.submit(),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: LoadingSpinner(),
                            )
                          : Text(l10n.sendResetLink),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
