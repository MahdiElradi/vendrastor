/// Repository for managing the list of recently viewed products.
abstract class RecentlyViewedRepository {
  Future<List<String>> getRecentlyViewedIds();
  Future<void> addRecentlyViewed(String productId);
}
