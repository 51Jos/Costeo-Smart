import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
  AppDimensions._();
  
  // Método helper para limitar dimensiones
  static double _limitDimension(double value, double maxValue) {
    return value > maxValue ? maxValue : value;
  }

  // Padding & Margin (con límites)
  static double get paddingXXS => _limitDimension(4.w, 8.0);
  static double get paddingXS => _limitDimension(8.w, 12.0);
  static double get paddingS => _limitDimension(12.w, 16.0);
  static double get paddingM => _limitDimension(16.w, 20.0);
  static double get paddingL => _limitDimension(20.w, 24.0);
  static double get paddingXL => _limitDimension(24.w, 28.0);
  static double get paddingXXL => _limitDimension(32.w, 32.0); // Límite máximo
  static double get paddingXXXL => _limitDimension(40.w, 40.0);

  // Spacing específico para layouts
  static double get screenPadding => _limitDimension(16.w, 24.0);
  static double get cardPadding => _limitDimension(16.w, 20.0);
  static double get listItemSpacing => _limitDimension(12.h, 16.0);
  static double get sectionSpacing => _limitDimension(24.h, 32.0);

  // Border Radius (con límites)
  static double get radiusXS => _limitDimension(4.r, 6.0);
  static double get radiusS => _limitDimension(8.r, 10.0);
  static double get radiusM => _limitDimension(12.r, 14.0);
  static double get radiusL => _limitDimension(16.r, 18.0);
  static double get radiusXL => _limitDimension(20.r, 22.0);
  static double get radiusXXL => _limitDimension(24.r, 26.0);
  static double get radiusCircular => 999.r; // Sin límite, pero revisa uso

  // Heights (con límites)
  static double get buttonHeightS => _limitDimension(36.h, 40.0);
  static double get buttonHeightM => _limitDimension(44.h, 48.0);
  static double get buttonHeightL => _limitDimension(52.h, 56.0);
  static double get textFieldHeight => _limitDimension(56.h, 60.0);
  static double get appBarHeight => _limitDimension(56.h, 60.0);
  static double get bottomNavHeight => _limitDimension(60.h, 64.0);

  // Widths (con límites)
  static double get buttonMinWidth => _limitDimension(120.w, 140.0);
  static double get cardMinHeight => _limitDimension(80.h, 100.0);
  static double get iconButtonSize => _limitDimension(40.w, 48.0);

  // Icon Sizes (con límites)
  static double get iconXS => _limitDimension(16.sp, 18.0);
  static double get iconS => _limitDimension(20.sp, 22.0);
  static double get iconM => _limitDimension(24.sp, 26.0);
  static double get iconL => _limitDimension(28.sp, 30.0);
  static double get iconXL => _limitDimension(32.sp, 34.0);
  static double get iconXXL => _limitDimension(40.sp, 42.0);

  // Specific Component Dimensions (con límites)
  static double get avatarS => _limitDimension(32.w, 36.0);
  static double get avatarM => _limitDimension(40.w, 44.0);
  static double get avatarL => _limitDimension(56.w, 60.0);
  static double get avatarXL => _limitDimension(72.w, 76.0);

  // Card Dimensions
  static const double cardElevation = 2;
  static const double cardElevationHigh = 8;

  // List Tile
  static double get listTileMinHeight => _limitDimension(64.h, 68.0);
  static double get listTileImageSize => _limitDimension(48.w, 52.0);

  // Loading & Progress
  static double get loadingIndicatorSize => _limitDimension(24.w, 28.0);
  static double get progressBarHeight => _limitDimension(4.h, 6.0);

  // Charts
  static double get chartHeight => _limitDimension(200.h, 250.0);
  static double get miniChartHeight => _limitDimension(120.h, 150.0);

  // Dividers
  static double get dividerThickness => _limitDimension(1.h, 2.0);
  static double get dividerIndent => _limitDimension(16.w, 20.0);

  // Bottom Sheet
  static double get bottomSheetRadius => _limitDimension(20.r, 22.0);
  static double get bottomSheetHandleWidth => _limitDimension(40.w, 44.0);
  static double get bottomSheetHandleHeight => _limitDimension(4.h, 6.0);

  // Animations
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Safe Area
  static double get safeAreaTop => _limitDimension(44.h, 48.0);
  static double get safeAreaBottom => _limitDimension(34.h, 38.0);
}