import '../../../../core/domain/paginated_result.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._remote);
  final CategoryRemoteDataSource _remote;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      return await _remote.getCategories();
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }

  @override
  Future<PaginatedResult<ProductEntity>> getCategoryProducts(
    String categoryId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _remote.getCategoryProducts(
        categoryId,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }
}
