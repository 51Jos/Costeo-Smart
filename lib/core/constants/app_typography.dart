import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();
  
  // Font Family
  static String get primaryFont => GoogleFonts.inter().fontFamily!;
  static String get secondaryFont => GoogleFonts.poppins().fontFamily!;
  
  // Display Styles
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 57.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: AppColors.textPrimary,
  );
  
  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 45.sp,
    fontWeight: FontWeight.w400,
    height: 1.16,
    color: AppColors.textPrimary,
  );
  
  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
    height: 1.22,
    color: AppColors.textPrimary,
  );
  
  // Headline Styles
  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.textPrimary,
  );
  
  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    height: 1.29,
    color: AppColors.textPrimary,
  );
  
  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.33,
    color: AppColors.textPrimary,
  );
  
  // Title Styles
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
    height: 1.27,
    color: AppColors.textPrimary,
  );
  
  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textPrimary,
  );
  
  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );
  
  // Body Styles
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: AppColors.textPrimary,
  );
  
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textPrimary,
  );
  
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );
  
  // Label Styles
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );
  
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.textPrimary,
  );
  
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.textSecondary,
  );
  
  // Estilos personalizados para la app
  static TextStyle price = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.primary,
  );
  
  static TextStyle priceSmall = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.primary,
  );
  
  static TextStyle button = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.75,
    height: 1.43,
    color: AppColors.white,
  );
  
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
    color: AppColors.textTertiary,
  );
  
  static TextStyle overline = GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.4,
    color: AppColors.textSecondary,
  );
  
  // Método helper para aplicar color a cualquier estilo
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  // Método helper para aplicar peso a cualquier estilo
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
}