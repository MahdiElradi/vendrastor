import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vendrastor_app/l10n/app_localizations.dart';

import 'core/config/app_constants.dart';
import 'core/config/theme/app_theme.dart';
import 'core/di/injection_container.dart';
import 'core/routing/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';

/// Root widget: theme, localization (en/ar with RTL), and routing.
class ShopSphereApp extends StatelessWidget {
  const ShopSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: sl<AuthCubit>()),
        BlocProvider<SettingsCubit>.value(value: sl<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) =>
            prev.themeMode != curr.themeMode ||
            prev.languageCode != curr.languageCode,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeModeEnum,
            locale: state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            localeResolutionCallback:
                (Locale? locale, Iterable<Locale> supported) {
                  for (final supportedLocale in supported) {
                    if (supportedLocale.languageCode == locale?.languageCode) {
                      return supportedLocale;
                    }
                  }
                  return supported.first;
                },
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: AppRouter.splash,
          );
        },
      ),
    );
  }
}
