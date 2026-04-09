import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  // 1. Formateador para fechas (ej: 15 abr. 2026)
  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy', 'es');

  // 2. Función para obtener la etiqueta de vencimiento
  static String expiryLabel(DateTime date) {
    final now = DateTime.now();
    // Comparamos solo las fechas sin la hora
    final today = DateTime(now.year, now.month, now.day);
    final expiryDate = DateTime(date.year, date.month, date.day);

    final difference = expiryDate.difference(today).inDays;

    if (difference < 0) {
      return 'Vencido';
    } else if (difference == 0) {
      return 'Vence hoy';
    } else if (difference == 1) {
      return 'Vence mañana';
    } else if (difference <= 7) {
      return 'Vence en $difference días';
    } else {
      return 'Vence el ${_displayFormat.format(date)}';
    }
  }

  // 3. Función para formato simple
  static String format(DateTime date) => _displayFormat.format(date);
}
