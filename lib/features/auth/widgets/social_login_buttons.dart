import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool showDivider;
  final String dividerText;
  final bool isLoading;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.showDivider = true,
    this.dividerText = 'O continúa con',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDivider) ...[
          _buildDivider(),
          SizedBox(height: AppDimensions.paddingL),
        ],
        
        // Google button
        if (onGooglePressed != null) ...[
          _SocialButton(
            onPressed: isLoading ? null : onGooglePressed,
            icon: PhosphorIcons.google_logo,
            text: 'Continuar con Google',
            backgroundColor: AppColors.white,
            textColor: AppColors.textPrimary,
            iconColor: null, // Google logo mantiene sus colores
            borderColor: AppColors.grey300,
          ),
          SizedBox(height: AppDimensions.paddingM),
        ],
        
        // Apple button (solo iOS)
        if (GetPlatform.isIOS && onApplePressed != null) ...[
          _SocialButton(
            onPressed: isLoading ? null : onApplePressed,
            icon: PhosphorIcons.apple_logo,
            text: 'Continuar con Apple',
            backgroundColor: AppColors.black,
            textColor: AppColors.white,
            iconColor: AppColors.white,
          ),
          SizedBox(height: AppDimensions.paddingM),
        ],
        
        // Facebook button
        if (onFacebookPressed != null) ...[
          _SocialButton(
            onPressed: isLoading ? null : onFacebookPressed,
            icon: PhosphorIcons.facebook_logo,
            text: 'Continuar con Facebook',
            backgroundColor: const Color(0xFF1877F2),
            textColor: AppColors.white,
            iconColor: AppColors.white,
          ),
        ],
      ],
    );
  }
  
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.grey300,
            thickness: 1.h,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          child: Text(
            dividerText,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.grey300,
            thickness: 1.h,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? iconColor;
  final Color? borderColor;

  const _SocialButton({
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isGoogle = icon == PhosphorIcons.google_logo;
    
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          decoration: BoxDecoration(
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1.5)
                : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isGoogle) ...[
                // Google logo con colores originales
                _GoogleLogo(size: AppDimensions.iconM),
              ] else ...[
                Icon(
                  icon,
                  size: AppDimensions.iconM,
                  color: iconColor,
                ),
              ],
              SizedBox(width: AppDimensions.paddingS),
              Text(
                text,
                style: AppTypography.button.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget personalizado para el logo de Google con colores
class _GoogleLogo extends StatelessWidget {
  final double size;
  
  const _GoogleLogo({required this.size});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Colores de Google
    final blue = Paint()..color = const Color(0xFF4285F4);
    final red = Paint()..color = const Color(0xFFEA4335);
    final yellow = Paint()..color = const Color(0xFFFBBC04);
    final green = Paint()..color = const Color(0xFF34A853);
    
    // Dibujar el logo simplificado de Google
    // Parte azul
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.9),
      -45 * 3.14159 / 180,
      -90 * 3.14159 / 180,
      true,
      blue,
    );
    
    // Parte roja
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.9),
      45 * 3.14159 / 180,
      90 * 3.14159 / 180,
      true,
      red,
    );
    
    // Parte amarilla
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.9),
      135 * 3.14159 / 180,
      90 * 3.14159 / 180,
      true,
      yellow,
    );
    
    // Parte verde
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.9),
      225 * 3.14159 / 180,
      90 * 3.14159 / 180,
      true,
      green,
    );
    
    // Centro blanco
    canvas.drawCircle(
      center,
      radius * 0.4,
      Paint()..color = Colors.white,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}