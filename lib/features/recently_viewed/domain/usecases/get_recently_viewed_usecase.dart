import '../repositories/recently_viewed_repository.dart';

class GetRecentlyViewedUseCase {
  GetRecentlyViewedUseCase(this._repository);

  final RecentlyViewedRepository _repository;

  Future<List<String>> call() => _repository.getRecentlyViewedIds();
}
