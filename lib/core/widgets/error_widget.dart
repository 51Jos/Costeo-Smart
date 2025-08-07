import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import '../constants/app_strings.dart';
import 'custom_button.dart';

enum ErrorType { network, server, notFound, permission, generic }

class CustomErrorWidget extends StatelessWidget {
  final String? message;
  final ErrorType errorType;
  final VoidCallback? onRetry;
  final bool isFullScreen;
  final String? retryText;
  final IconData? customIcon;
  final double? iconSize;

  const CustomErrorWidget({
    super.key,
    this.message,
    this.errorType = ErrorType.generic,
    this.onRetry,
    this.isFullScreen = true,
    this.retryText,
    this.customIcon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIcon(),
            size: iconSize ?? 80.sp,
            color: AppColors.error,
          ),
          SizedBox(height: AppDimensions.paddingL),
          Text(
            _getTitle(),
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            message ?? _getDefaultMessage(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: AppDimensions.paddingXL),
            CustomButton(
              text: retryText ?? AppStrings.tryAgain,
              onPressed: onRetry,
              type: ButtonType.primary,
              icon: Icons.refresh,
            ),
          ],
        ],
      ),
    );

    if (isFullScreen) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: content),
      );
    }

    return Center(child: content);
  }

  IconData _getIcon() {
    if (customIcon != null) return customIcon!;
    
    switch (errorType) {
      case ErrorType.network:
        return Icons.wifi_off_rounded;
      case ErrorType.server:
        return Icons.cloud_off_rounded;
      case ErrorType.notFound:
        return Icons.search_off_rounded;
      case ErrorType.permission:
        return Icons.lock_outline_rounded;
      case ErrorType.generic:
        return Icons.error_outline_rounded;
    }
  }

  String _getTitle() {
    switch (errorType) {
      case ErrorType.network:
        return 'Sin conexión';
      case ErrorType.server:
        return 'Error del servidor';
      case ErrorType.notFound:
        return 'No encontrado';
      case ErrorType.permission:
        return 'Sin permisos';
      case ErrorType.generic:
        return '¡Ups! Algo salió mal';
    }
  }

  String _getDefaultMessage() {
    switch (errorType) {
      case ErrorType.network:
        return 'Por favor, verifica tu conexión a internet e intenta nuevamente.';
      case ErrorType.server:
        return 'Estamos teniendo problemas con nuestros servidores. Por favor, intenta más tarde.';
      case ErrorType.notFound:
        return 'No pudimos encontrar lo que buscas.';
      case ErrorType.permission:
        return 'No tienes permisos para acceder a este recurso.';
      case ErrorType.generic:
        return 'Algo salió mal. Por favor, intenta nuevamente.';
    }
  }
}

// Widget de estado vacío
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final double? iconSize;
  final VoidCallback? onAction;
  final String? actionText;
  final Widget? customAction;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.iconSize,
    this.onAction,
    this.actionText,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize ?? 80.sp,
                color: AppColors.grey400,
              ),
            SizedBox(height: AppDimensions.paddingL),
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: AppDimensions.paddingM),
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (customAction != null) ...[
              SizedBox(height: AppDimensions.paddingXL),
              customAction!,
            ] else if (onAction != null && actionText != null) ...[
              SizedBox(height: AppDimensions.paddingXL),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
                type: ButtonType.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}