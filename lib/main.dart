import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/storage/hive_manager.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      try {
        await HiveManager.init();
      } catch (e, st) {
        debugPrint('Hive initialization failed: $e');
        debugPrint('$st');
        rethrow;
      }

      await initGetIt();
      await sl<SettingsCubit>().loadSettings();

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        if (details.exception is AssertionError &&
            details.exceptionAsString().contains('KeyUpEvent')) {
          return;
        }
        debugPrint('FlutterError: ${details.exception}');
      };

      runApp(const ShopSphereApp());
    },
    (error, stackTrace) {
      debugPrint('Unhandled app error: $error');
      debugPrint('$stackTrace');
    },
  );
}
