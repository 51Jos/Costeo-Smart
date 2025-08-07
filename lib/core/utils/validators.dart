import '../constants/app_strings.dart';

class Validators {
  Validators._();
  
  // Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    // Expresión regular para validar email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    
    return null;
  }
  
  // Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    
    // Opcional: validar que contenga al menos una mayúscula, un número, etc.
    // final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    // final hasDigits = value.contains(RegExp(r'[0-9]'));
    // final hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return null;
  }
  
  // Confirm password validator
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    if (value != password) {
      return AppStrings.passwordsDontMatch;
    }
    
    return null;
  }
  
  // Required field validator
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
        ? '$fieldName es obligatorio' 
        : AppStrings.fieldRequired;
    }
    return null;
  }
  
  // Phone number validator
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    // Remover espacios y guiones
    final cleanedPhone = value.replaceAll(RegExp(r'[\s-]'), '');
    
    // Validar longitud y que solo contenga números
    if (cleanedPhone.length < 10 || !RegExp(r'^\d+$').hasMatch(cleanedPhone)) {
      return AppStrings.invalidPhone;
    }
    
    return null;
  }
  
  // Number validator
  static String? number(String? value, {
    double? min,
    double? max,
    bool allowDecimals = true,
    bool isRequired = true,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.fieldRequired : null;
    }
    
    final number = allowDecimals ? double.tryParse(value) : int.tryParse(value);
    
    if (number == null) {
      return AppStrings.invalidNumber;
    }
    
    if (min != null && number < min) {
      return 'El valor mínimo es $min';
    }
    
    if (max != null && number > max) {
      return 'El valor máximo es $max';
    }
    
    return null;
  }
  
  // Positive number validator
  static String? positiveNumber(String? value, {bool allowZero = false}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    final number = double.tryParse(value);
    
    if (number == null) {
      return AppStrings.invalidNumber;
    }
    
    if (allowZero ? number < 0 : number <= 0) {
      return AppStrings.numberMustBePositive;
    }
    
    return null;
  }
  
  // Percentage validator (0-100)
  static String? percentage(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    final number = double.tryParse(value);
    
    if (number == null) {
      return AppStrings.invalidNumber;
    }
    
    if (number < 0 || number > 100) {
      return 'El porcentaje debe estar entre 0 y 100';
    }
    
    return null;
  }
  
  // URL validator
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL es opcional
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'URL inválida';
    }
    
    return null;
  }
  
  // Min length validator
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    if (value.length < minLength) {
      return fieldName != null
        ? '$fieldName debe tener al menos $minLength caracteres'
        : 'Mínimo $minLength caracteres';
    }
    
    return null;
  }
  
  // Max length validator
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    if (value.length > maxLength) {
      return fieldName != null
        ? '$fieldName debe tener máximo $maxLength caracteres'
        : 'Máximo $maxLength caracteres';
    }
    
    return null;
  }
  
  // Date validator
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Fecha inválida';
    }
  }
  
  // Future date validator
  static String? futureDate(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    try {
      final date = DateTime.parse(value);
      if (date.isBefore(DateTime.now())) {
        return 'La fecha debe ser futura';
      }
      return null;
    } catch (e) {
      return 'Fecha inválida';
    }
  }
  
  // List validator
  static String? list<T>(List<T>? value, {int? minItems, int? maxItems}) {
    if (value == null || value.isEmpty) {
      return AppStrings.selectAtLeastOne;
    }
    
    if (minItems != null && value.length < minItems) {
      return 'Selecciona al menos $minItems elementos';
    }
    
    if (maxItems != null && value.length > maxItems) {
      return 'Selecciona máximo $maxItems elementos';
    }
    
    return null;
  }
  
  // Custom validator combiner
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}