import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum ButtonType { primary, secondary, outline, text, danger }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final Color? customColor;
  final Color? customTextColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.customColor,
    this.customTextColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: _getHeight(context),
      child: _buildButton(context, isDisabled),
    );
  }

  Widget _buildButton(BuildContext context, bool isDisabled) {
    final content = _buildContent(context);
    
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _getPrimaryStyle(context),
          child: content,
        );
        
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _getSecondaryStyle(context),
          child: content,
        );
        
      case ButtonType.outline:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _getOutlineStyle(context),
          child: content,
        );
        
      case ButtonType.text:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: _getTextButtonStyle(context),
          child: content,
        );
        
      case ButtonType.danger:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _getDangerStyle(context),
          child: content,
        );
    }
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.outline || type == ButtonType.text
                ? customColor ?? AppColors.primary
                : AppColors.white,
          ),
        ),
      );
    }

    final textWidget = Text(
      text,
      style: _getTextStyle(context).copyWith(
        color: customTextColor ?? _getDefaultTextColor(),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: _getIconSize(context),
            color: customTextColor ?? _getDefaultTextColor(),
          ),
          const SizedBox(width: 8),
          Flexible(child: textWidget),
        ],
      );
    }

    return textWidget;
  }

  Color _getDefaultTextColor() {
    switch (type) {
      case ButtonType.outline:
      case ButtonType.text:
        return customColor ?? AppColors.primary;
      default:
        return AppColors.white;
    }
  }

  double _getHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    switch (size) {
      case ButtonSize.small:
        if (width < 600) return 36;
        return 38;
      case ButtonSize.medium:
        if (width < 600) return 44;
        return 48;
      case ButtonSize.large:
        if (width < 600) return 52;
        return 56;
    }
  }

  double _getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    switch (size) {
      case ButtonSize.small:
        return width < 600 ? 16 : 18;
      case ButtonSize.medium:
        return width < 600 ? 18 : 20;
      case ButtonSize.large:
        return width < 600 ? 20 : 22;
    }
  }

  EdgeInsetsGeometry _getPadding(BuildContext context) {
    if (padding != null) return padding!;
    
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600;
    
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: isCompact ? 12 : 16,
          vertical: isCompact ? 4 : 6,
        );
      case ButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: isCompact ? 16 : 24,
          vertical: isCompact ? 8 : 10,
        );
      case ButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: isCompact ? 20 : 32,
          vertical: isCompact ? 12 : 14,
        );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double fontSize;
    
    switch (size) {
      case ButtonSize.small:
        fontSize = width < 600 ? 13 : 14;
        break;
      case ButtonSize.medium:
        fontSize = width < 600 ? 14 : 16;
        break;
      case ButtonSize.large:
        fontSize = width < 600 ? 16 : 18;
        break;
    }
    
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  double _getBorderRadius(BuildContext context) {
    // Valor fijo de border radius para consistencia
    return 12.0;
  }

  ButtonStyle _getPrimaryStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: customColor ?? AppColors.primary,
      foregroundColor: customTextColor ?? AppColors.white,
      disabledBackgroundColor: AppColors.grey300,
      disabledForegroundColor: AppColors.grey500,
      elevation: 0,
      padding: _getPadding(context),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius(context)),
      ),
      textStyle: _getTextStyle(context),
    );
  }

  ButtonStyle _getSecondaryStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: customColor ?? AppColors.secondary,
      foregroundColor: customTextColor ?? AppColors.white,
      disabledBackgroundColor: AppColors.grey300,
      disabledForegroundColor: AppColors.grey500,
      elevation: 0,
      padding: _getPadding(context),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius(context)),
      ),
      textStyle: _getTextStyle(context),
    );
  }

  ButtonStyle _getOutlineStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: customColor ?? AppColors.primary,
      disabledForegroundColor: AppColors.grey400,
      side: BorderSide(
        color: customColor ?? AppColors.primary,
        width: 1.5,
      ),
      padding: _getPadding(context),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius(context)),
      ),
      textStyle: _getTextStyle(context),
    );
  }

  ButtonStyle _getTextButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: customColor ?? AppColors.primary,
      disabledForegroundColor: AppColors.grey400,
      padding: _getPadding(context),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius(context)),
      ),
      textStyle: _getTextStyle(context),
    );
  }

  ButtonStyle _getDangerStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: customColor ?? AppColors.error,
      foregroundColor: customTextColor ?? AppColors.white,
      disabledBackgroundColor: AppColors.grey300,
      disabledForegroundColor: AppColors.grey500,
      elevation: 0,
      padding: _getPadding(context),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius(context)),
      ),
      textStyle: _getTextStyle(context),
    );
  }
}

// Clase helper para obtener dimensiones de botones si la necesitas en otros lugares
class ButtonDimensions {
  static double getHeight(BuildContext context, ButtonSize size) {
    final width = MediaQuery.of(context).size.width;
    
    switch (size) {
      case ButtonSize.small:
        return width < 600 ? 36 : 38;
      case ButtonSize.medium:
        return width < 600 ? 44 : 48;
      case ButtonSize.large:
        return width < 600 ? 52 : 56;
    }
  }
  
  static double getFontSize(BuildContext context, ButtonSize size) {
    final width = MediaQuery.of(context).size.width;
    
    switch (size) {
      case ButtonSize.small:
        return width < 600 ? 13 : 14;
      case ButtonSize.medium:
        return width < 600 ? 14 : 16;
      case ButtonSize.large:
        return width < 600 ? 16 : 18;
    }
  }
}