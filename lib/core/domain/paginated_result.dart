/// Generic paginated result for list endpoints.
class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalCount;

  bool get hasMore => currentPage < totalPages;
}
