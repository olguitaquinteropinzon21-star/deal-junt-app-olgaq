class AppValidator {
  AppValidator._();

  // 1. Valida que el campo no esté vacío
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  // 2. Valida que el porcentaje sea realista (entre 1 y 100)
  static String? percentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es requerido';
    }

    final num = double.tryParse(value);
    if (num == null || num < 1 || num > 100) {
      return 'Ingrese un porcentaje entre 1 y 100';
    }
    return null;
  }

  // 3. Valida que la fecha seleccionada no sea del pasado
  static String? futureDate(DateTime? date) {
    if (date == null) {
      return 'Selecciona una fecha';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (date.isBefore(today)) {
      return 'La fecha debe ser futura';
    }
    return null;
  }
}
