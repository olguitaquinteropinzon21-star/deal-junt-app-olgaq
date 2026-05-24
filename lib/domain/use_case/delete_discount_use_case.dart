import '../../data/repositories/discount_repository.dart';

class DeleteDiscountUseCase {
  final IDiscountRepository _repository;

  DeleteDiscountUseCase(this._repository);

  Future<void> call(int id) async {
    return _repository.delete(id);
  }
}
