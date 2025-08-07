import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../constants/app_strings.dart';

class Formatters {
  Formatters._();
  
  // Formateador de moneda
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'es_US',
    symbol: AppStrings.currencySymbol,
    decimalDigits: 2,
  );
  
  // Formateador de números
  static final NumberFormat _numberFormat = NumberFormat.decimalPattern('es_US');  
  
  // Formatear moneda
  static String currency(double value) {
    return _currencyFormat.format(value);
  }
  
  // Formatear moneda sin símbolo
  static String currencyNoSymbol(double value) {
    return NumberFormat.currency(
      locale: 'es_US',
      symbol: '',
      decimalDigits: 2,
    ).format(value).trim();
  }
  
  // Formatear número con decimales
  static String number(double value, {int decimals = 2}) {
    return NumberFormat.decimalPattern('es_US')
      .format(double.parse(value.toStringAsFixed(decimals)));
  }
  
  // Formatear número entero
  static String integer(int value) {
    return _numberFormat.format(value);
  }
  
  // Formatear porcentaje
  static String percentage(double value, {int decimals = 1}) {
    return NumberFormat.percentPattern('es_US')
      .format(value / 100)
      .replaceAll(',', '.')
      .replaceAll(' ', '');
  }
  
  // Formatear peso/cantidad con unidad
  static String quantity(double value, String unit) {
    final formatted = number(value, decimals: value % 1 == 0 ? 0 : 2);
    return '$formatted $unit';
  }
  
  // Formatear fecha
  static String date(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'es').format(date);
  }
  
  // Formatear fecha y hora
  static String dateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm', 'es').format(dateTime);
  }
  
  // Formatear hora
  static String time(DateTime time) {
    return DateFormat('HH:mm', 'es').format(time);
  }
  
  // Formatear fecha relativa (hoy, ayer, etc.)
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return AppStrings.today;
    } else if (difference.inDays == 1) {
      return AppStrings.yesterday;
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días atrás';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? 'Hace 1 semana' : 'Hace $weeks semanas';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? 'Hace 1 mes' : 'Hace $months meses';
    } else {
      return Formatters.date(date);
    }
  }
  
  // Formatear duración (minutos a horas y minutos)
  static String duration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (remainingMinutes == 0) {
      return hours == 1 ? '1 hora' : '$hours horas';
    }
    
    return '${hours}h ${remainingMinutes}min';
  }
  
  // Capitalizar primera letra
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  // Capitalizar cada palabra
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  // Formatear número de teléfono
  static String phone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 10) return phone;
    
    return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
  }
  
  // Truncar texto
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }
  
  // Formatear tamaño de archivo
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

// Input Formatters para TextFields
class InputFormatters {
  InputFormatters._();
  
  // Solo números
  static List<TextInputFormatter> onlyNumbers({bool allowDecimal = false}) {
    return [
      FilteringTextInputFormatter.allow(
        allowDecimal ? RegExp(r'^\d*\.?\d*') : RegExp(r'^\d*'),
      ),
    ];
  }
  
  // Solo letras
  static List<TextInputFormatter> onlyLetters({bool allowSpaces = true}) {
    return [
      FilteringTextInputFormatter.allow(
        allowSpaces ? RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]') : RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ]'),
      ),
    ];
  }
  
  // Formato de moneda
  static List<TextInputFormatter> currency() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      CurrencyInputFormatter(),
    ];
  }
  
  // Formato de teléfono
  static List<TextInputFormatter> phone() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
      PhoneInputFormatter(),
    ];
  }
  
  // Formato de porcentaje
  static List<TextInputFormatter> percentage() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}\.?\d{0,2}')),
      PercentageInputFormatter(),
    ];
  }
}

// Formateador personalizado para moneda
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Remover todo excepto números y punto
    String newText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');
    
    // Asegurar solo un punto decimal
    final parts = newText.split('.');
    if (parts.length > 2) {
      newText = '${parts[0]}.${parts[1]}';
    }
    
    // Limitar decimales a 2
    if (parts.length == 2 && parts[1].length > 2) {
      newText = '${parts[0]}.${parts[1].substring(0, 2)}';
    }
    
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

// Formateador personalizado para teléfono
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    final buffer = StringBuffer();
    
    for (int i = 0; i < newText.length; i++) {
      if (i == 3 || i == 6) {
        buffer.write('-');
      }
      buffer.write(newText[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Formateador personalizado para porcentaje
class PercentageInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    final value = double.tryParse(newValue.text);
    if (value == null || value > 100) {
      return oldValue;
    }
    
    return newValue;
  }
}