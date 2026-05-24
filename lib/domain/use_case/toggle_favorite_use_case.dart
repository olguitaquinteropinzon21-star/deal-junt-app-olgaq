import '../../data/repositories/discount_repository.dart';

class ToggleFavoriteUseCase {
  final IDiscountRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<void> call(int id, bool isFavorite) async {
    return _repository.updateFavorite(id, isFavorite);
  }
}
