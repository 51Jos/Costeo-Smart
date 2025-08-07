import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
  AppDimensions._();
  
  // Padding & Margin
  static final double paddingXXS = 4.w;
  static final double paddingXS = 8.w;
  static final double paddingS = 12.w;
  static final double paddingM = 16.w;
  static final double paddingL = 20.w;
  static final double paddingXL = 24.w;
  static final double paddingXXL = 32.w;
  static final double paddingXXXL = 40.w;
  
  // Spacing específico para layouts
  static final double screenPadding = 16.w;
  static final double cardPadding = 16.w;
  static final double listItemSpacing = 12.h;
  static final double sectionSpacing = 24.h;
  
  // Border Radius
  static final double radiusXS = 4.r;
  static final double radiusS = 8.r;
  static final double radiusM = 12.r;
  static final double radiusL = 16.r;
  static final double radiusXL = 20.r;
  static final double radiusXXL = 24.r;
  static final double radiusCircular = 999.r;
  
  // Heights
  static final double buttonHeightS = 36.h;
  static final double buttonHeightM = 44.h;
  static final double buttonHeightL = 52.h;
  static final double textFieldHeight = 56.h;
  static final double appBarHeight = 56.h;
  static final double bottomNavHeight = 60.h;
  
  // Widths
  static final double buttonMinWidth = 120.w;
  static final double cardMinHeight = 80.h;
  static final double iconButtonSize = 40.w;
  
  // Icon Sizes
  static final double iconXS = 16.sp;
  static final double iconS = 20.sp;
  static final double iconM = 24.sp;
  static final double iconL = 28.sp;
  static final double iconXL = 32.sp;
  static final double iconXXL = 40.sp;
  
  // Specific Component Dimensions
  static final double avatarS = 32.w;
  static final double avatarM = 40.w;
  static final double avatarL = 56.w;
  static final double avatarXL = 72.w;
  
  // Card Dimensions
  static final double cardElevation = 2;
  static final double cardElevationHigh = 8;
  
  // List Tile
  static final double listTileMinHeight = 64.h;
  static final double listTileImageSize = 48.w;
  
  // Loading & Progress
  static final double loadingIndicatorSize = 24.w;
  static final double progressBarHeight = 4.h;
  
  // Charts
  static final double chartHeight = 200.h;
  static final double miniChartHeight = 120.h;
  
  // Dividers
  static final double dividerThickness = 1.h;
  static final double dividerIndent = 16.w;
  
  // Bottom Sheet
  static final double bottomSheetRadius = 20.r;
  static final double bottomSheetHandleWidth = 40.w;
  static final double bottomSheetHandleHeight = 4.h;
  
  // Animations
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  
  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Safe Area
  static final double safeAreaTop = 44.h; // iOS notch
  static final double safeAreaBottom = 34.h; // iOS home indicator
}