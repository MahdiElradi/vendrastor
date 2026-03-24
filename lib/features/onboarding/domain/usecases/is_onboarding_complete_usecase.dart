import '../../../../core/storage/hive_manager.dart';

/// Returns true if the user has completed onboarding.
class IsOnboardingCompleteUseCase {
  Future<bool> call() async {
    final box = HiveManager.box<dynamic>(HiveBox.onboarding);
    return box.get('completed') == true;
  }
}
