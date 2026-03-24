import '../../../../core/storage/hive_manager.dart';

/// Use case: set onboarding complete flag in local storage.
class CompleteOnboardingUseCase {
  Future<void> call() async {
    final box = HiveManager.box<dynamic>(HiveBox.onboarding);
    await box.put('completed', true);
  }
}
