import 'package:flutter/material.dart';

class AppColors {
  // Constructor privado para evitar instanciación
  AppColors._();
  
  // Colores principales
  static const Color primary = Color.fromARGB(255, 180, 209, 17); // Verde elegante
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);
  
  // Colores secundarios
  static const Color secondary = Color(0xFFFF6F00); // Naranja vibrante
  static const Color secondaryLight = Color(0xFFFFBF00);
  static const Color secondaryDark = Color(0xFFC43E00);
  
  // Colores de acento
  static const Color accent = Color(0xFF00BCD4); // Cyan
  static const Color accentLight = Color(0xFF5DDEF4);
  static const Color accentDark = Color(0xFF008BA3);
  
  // Colores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Escala de grises
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey900 = Color(0xFF212121);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey50 = Color(0xFFFAFAFA);
  
  // Colores de fondo
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  
  // Colores para gráficos
  static const Color chartBlue = Color(0xFF3B82F6);
  static const Color chartGreen = Color(0xFF10B981);
  static const Color chartYellow = Color(0xFFF59E0B);
  static const Color chartRed = Color(0xFFEF4444);
  static const Color chartPurple = Color(0xFF8B5CF6);
  static const Color chartPink = Color(0xFFEC4899);
  
  // Colores para categorías
  static const Color categoryFood = Color(0xFF8BC34A);
  static const Color categoryBeverage = Color(0xFF03A9F4);
  static const Color categoryDessert = Color(0xFFE91E63);
  static const Color categorySauce = Color(0xFFFFC107);
  
  // Sombras
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.04),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
    BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.02),
      offset: const Offset(0, 4),
      blurRadius: 8,
    ),
  ];
  
  static final List<BoxShadow> elevatedShadow = [
    BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.08),
      offset: const Offset(0, 4),
      blurRadius: 12,
    ),
    BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.04),
      offset: const Offset(0, 2),
      blurRadius: 6,
    ),
  ];
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF81C784)],
  );
}