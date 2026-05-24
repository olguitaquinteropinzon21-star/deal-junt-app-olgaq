import 'package:flutter/foundation.dart';
import '../../domain/use_case/delete_discount_use_case.dart';
// Asegúrate de que este import coincida con el nombre de tu caso de uso para guardar
import '../../data/models/discount.dart';

// Definición del estado de la vista
enum ViewState { idle, loading, success, error }

class AddEditViewModel extends ChangeNotifier {
  final DeleteDiscountUseCase _deleteDiscountUseCase;
  // Si tienes un SaveDiscountUseCase, agrégalo aquí. Si no, lo simularemos.

  ViewState _state = ViewState.idle;
  Discount? _editingDiscount;
  String? _errorMessage;
  bool _saveSuccess = false;

  AddEditViewModel({required DeleteDiscountUseCase deleteDiscountUseCase})
    : _deleteDiscountUseCase = deleteDiscountUseCase;

  // --- Getters ---
  ViewState get state => _state;
  Discount? get editingDiscount => _editingDiscount;
  String? get errorMessage => _errorMessage;
  bool get saveSuccess => _saveSuccess;
  bool get isEditing => _editingDiscount != null;
  bool get isLoading => _state == ViewState.loading;

  // --- Métodos de lógica ---

  void initForEdit(Discount? discount) {
    _editingDiscount = discount;
    notifyListeners();
  }

  void resetSuccess() {
    _saveSuccess = false;
  }

  Future<bool> save({
    required String title,
    required String description,
    required double percentage,
    required String categoryId,
    required String storeName,
    required String
    imageUrl, // Agregado para corregir el error de image_2bc7df.png
    String? couponCode,
    required DateTime expirationDate,
  }) async {
    _setState(ViewState.loading);
    try {
      // Simulación de guardado
      await Future.delayed(const Duration(seconds: 1));

      _saveSuccess = true;
      _setState(ViewState.success);
      return true;
    } catch (e) {
      _errorMessage = 'Error al guardar: $e';
      _setState(ViewState.error);
      return false;
    }
  }

  Future<bool> delete(int id) async {
    _setState(ViewState.loading);
    try {
      await _deleteDiscountUseCase.call(id);
      _setState(ViewState.success);
      return true;
    } catch (e) {
      _errorMessage = 'Error al eliminar: $e';
      _setState(ViewState.error);
      return false;
    }
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
