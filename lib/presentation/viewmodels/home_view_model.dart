import 'package:flutter/foundation.dart';
import '../../domain/use_case/delete_discount_use_case.dart';
import '../../domain/use_case/get_discount_use_case.dart';
import '../../domain/use_case/toggle_favorite_use_case.dart';
import '../../data/models/discount.dart';

enum ViewState { idle, loading, success, error }

class HomeViewModel extends ChangeNotifier {
  final GetDiscountUseCase _getDiscountUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final DeleteDiscountUseCase _deleteDiscountUseCase;

  ViewState _state = ViewState.idle;
  List<Discount> _discounts = [];
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String? _errorMessage;

  HomeViewModel({
    required GetDiscountUseCase getDiscountUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required DeleteDiscountUseCase deleteDiscountUseCase,
  }) : _getDiscountUseCase = getDiscountUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       _deleteDiscountUseCase = deleteDiscountUseCase;

  ViewState get state => _state;
  List<Discount> get discounts => _discounts;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;

  Future<void> loadDiscounts() async {
    _setState(ViewState.loading);
    try {
      final result = await _getDiscountUseCase.call(
        categoryId: _selectedCategoryId,
        query: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _discounts = result;
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = 'Error al cargar descuentos: $e';
      _setState(ViewState.error);
    }
  }

  void selectCategory(String categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    _searchQuery = '';
    loadDiscounts();
  }

  Future<void> toggleFavorite(int id, bool currentValue) async {
    try {
      await _toggleFavoriteUseCase.call(id, !currentValue);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al actualizar favorito';
      notifyListeners();
    }
  }

  Future<void> deleteDiscount(int id) async {
    try {
      await _deleteDiscountUseCase.call(id);
      _discounts.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al eliminar descuento';
      notifyListeners();
    }
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
