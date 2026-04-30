import 'package:flutter/foundation.dart';
// Usamos rutas relativas para que no fallen por el nombre del proyecto
import '../../domain/use_case/toggle_favorite_use_case.dart';
import '../../data/models/discount.dart';
// Asegúrate de crear este archivo o ajustarlo si el nombre es distinto
import '../../domain/use_case/get_discount_use_case.dart';

// Si ViewState ya está definido en otro lado, puedes borrar esta línea
enum ViewState { idle, loading, success, error }

class FavoritesViewModel extends ChangeNotifier {
  final GetDiscountUseCase _getDiscountUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  ViewState _state = ViewState.idle;
  List<Discount> _favorites = [];
  String? _errorMessage;

  FavoritesViewModel({
    required GetDiscountUseCase getDiscountUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
  }) : _getDiscountUseCase = getDiscountUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase;

  // Getters para que la pantalla pueda leer los datos
  ViewState get state => _state;
  List<Discount> get favorites => _favorites;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;

  Future<void> loadFavorites() async {
    _setState(ViewState.loading);
    try {
      // Cargamos todos y filtramos los que son favoritos
      final allDiscounts = await _getDiscountUseCase.call();
      _favorites = allDiscounts.where((d) => d.isFavorite).toList();
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = 'Error al cargar favoritos: $e';
      _setState(ViewState.error);
    }
  }

  Future<void> removeFavorite(int id) async {
    try {
      // Usamos el caso de uso para quitarlo de favoritos (false)
      await _toggleFavoriteUseCase.call(id, false);
      _favorites.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al quitar de favoritos';
      notifyListeners();
    }
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
