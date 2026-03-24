import '../repositories/recently_viewed_repository.dart';

class AddRecentlyViewedUseCase {
  AddRecentlyViewedUseCase(this._repository);

  final RecentlyViewedRepository _repository;

  Future<void> call(String productId) =>
      _repository.addRecentlyViewed(productId);
}
