import '../entities/banner_entity.dart';
import '../repositories/product_repository.dart';

class GetHomeBannersUseCase {
  GetHomeBannersUseCase(this._repository);
  final ProductRepository _repository;

  Future<List<BannerEntity>> call() => _repository.getBanners();
}
