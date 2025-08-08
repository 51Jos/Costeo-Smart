import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/ingredient_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';

class IngredientCard extends StatelessWidget {
  final IngredientModel ingredient;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final bool isCompact;

  const IngredientCard({
    super.key,
    required this.ingredient,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.paddingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          child: isCompact ? _buildCompactLayout() : _buildFullLayout(),
        ),
      ),
    );
  }

  Widget _buildFullLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con imagen y título
        Row(
          children: [
            _buildIngredientImage(),
            SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIngredientHeader(),
                  SizedBox(height: AppDimensions.paddingXS),
                  _buildIngredientSubtitle(),
                ],
              ),
            ),
            if (showActions) _buildActionsMenu(),
          ],
        ),
        
        SizedBox(height: AppDimensions.paddingM),
        
        // Información de precios
        _buildPriceInfo(),
        
        SizedBox(height: AppDimensions.paddingM),
        
        // Información de rendimiento
        _buildYieldInfo(),
        
        SizedBox(height: AppDimensions.paddingS),
        
        // Footer con metadatos
        _buildFooter(),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Row(
      children: [
        _buildIngredientImage(size: 48),
        SizedBox(width: AppDimensions.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIngredientHeader(),
              SizedBox(height: AppDimensions.paddingXXS),
              _buildCompactPriceInfo(),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildYieldBadge(),
            if (showActions) ...[
              SizedBox(height: AppDimensions.paddingXS),
              _buildActionsMenu(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildIngredientImage({double? size}) {
    final imageSize = size ?? 64.0;
    
    return Container(
      width: imageSize.w,
      height: imageSize.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        color: AppColors.grey100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: ingredient.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: ingredient.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildImagePlaceholder(imageSize),
                errorWidget: (context, url, error) => _buildImagePlaceholder(imageSize),
              )
            : _buildImagePlaceholder(imageSize),
      ),
    );
  }

  Widget _buildImagePlaceholder(double size) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Icon(
        Icons.restaurant,
        color: AppColors.grey500,
        size: (size * 0.4).sp,
      ),
    );
  }

  Widget _buildIngredientHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            ingredient.name,
            style: AppTypography.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: AppDimensions.paddingXS),
        _buildCategoryChip(),
      ],
    );
  }

  Widget _buildIngredientSubtitle() {
    return Text(
      'SKU: ${ingredient.code} • ${ingredient.primarySupplier}',
      style: AppTypography.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXS,
        vertical: AppDimensions.paddingXXS,
      ),
      decoration: BoxDecoration(
        color: _getCategoryColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Text(
        ingredient.category,
        style: AppTypography.labelSmall.copyWith(
          color: _getCategoryColor(),
        ),
      ),
    );
  }

  Widget _buildPriceInfo() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPriceItem(
              'Precio Compra',
              Formatters.currency(ingredient.purchasePrice),
              '${ingredient.baseUnit}',
            ),
          ),
          Container(
            width: 1,
            height: 40.h,
            color: AppColors.grey300,
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
          ),
          Expanded(
            child: _buildPriceItem(
              'Costo Real',
              Formatters.currency(ingredient.realCostPerUsableUnit),
              '${ingredient.baseUnit} útil',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactPriceInfo() {
    return Row(
      children: [
        Text(
          Formatters.currency(ingredient.purchasePrice),
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text(
          '/${ingredient.baseUnit}',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        if (ingredient.realCostPerUsableUnit != ingredient.purchasePrice) ...[
          Text(
            'Real: ${Formatters.currency(ingredient.realCostPerUsableUnit)}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.warning,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceItem(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.paddingXXS),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          unit,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildYieldInfo() {
    return Row(
      children: [
        Expanded(
          child: _buildYieldIndicator(
            'Aprovechable',
            ingredient.usablePercentage,
            AppColors.success,
          ),
        ),
        SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: _buildYieldIndicator(
            'Merma',
            ingredient.reusableWastePercentage,
            AppColors.warning,
          ),
        ),
        SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: _buildYieldIndicator(
            'Desperdicio',
            ingredient.totalWastePercentage,
            AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildYieldIndicator(String label, double percentage, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppDimensions.paddingXXS),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.paddingXXS),
        Text(
          label,
          style: AppTypography.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildYieldBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXS,
        vertical: AppDimensions.paddingXXS,
      ),
      decoration: BoxDecoration(
        color: _getYieldColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: _getYieldColor(),
          width: 1,
        ),
      ),
      child: Text(
        '${ingredient.usablePercentage.toStringAsFixed(0)}% útil',
        style: AppTypography.labelSmall.copyWith(
          color: _getYieldColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14.sp,
          color: AppColors.textTertiary,
        ),
        SizedBox(width: AppDimensions.paddingXXS),
        Text(
          'Actualizado ${Formatters.relativeDate(ingredient.updatedAt)}',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const Spacer(),
        if (ingredient.isPriceOutdated) ...[
          Icon(
            Icons.warning,
            size: 14.sp,
            color: AppColors.warning,
          ),
          SizedBox(width: AppDimensions.paddingXXS),
          Text(
            'Precio desactualizado',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.warning,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionsMenu() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppColors.textSecondary,
        size: 20.sp,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18.sp, color: AppColors.textSecondary),
              SizedBox(width: AppDimensions.paddingS),
              const Text('Editar'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18.sp, color: AppColors.error),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                'Eliminar',
                style: TextStyle(color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor() {
    const categoryColors = {
      'Verduras': AppColors.success,
      'Frutas': AppColors.warning,
      'Carnes Rojas': AppColors.error,
      'Carnes Blancas': AppColors.secondary,
      'Pescados y Mariscos': AppColors.info,
      'Lácteos': AppColors.accent,
      'Granos y Cereales': AppColors.grey700,
      'Especias y Condimentos': AppColors.chartPurple,
      'Aceites y Grasas': AppColors.chartYellow,
      'Bebidas': AppColors.chartBlue,
      'Endulzantes': AppColors.chartPink,
      'Harinas': AppColors.grey600,
      'Conservas': AppColors.chartGreen,
      'Congelados': AppColors.info,
      'Otros': AppColors.grey500,
    };
    
    return categoryColors[ingredient.category] ?? AppColors.grey500;
  }

  Color _getYieldColor() {
    if (ingredient.usablePercentage >= 90) return AppColors.success;
    if (ingredient.usablePercentage >= 75) return AppColors.warning;
    return AppColors.error;
  }
}

// Widget especializado para listas de ingredientes
class IngredientListTile extends StatelessWidget {
  final IngredientModel ingredient;
  final VoidCallback? onTap;
  final bool selected;

  const IngredientListTile({
    super.key,
    required this.ingredient,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryLight.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.grey200,
          child: ingredient.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: ingredient.imageUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Icon(
                    Icons.restaurant,
                    color: AppColors.grey500,
                    size: 16.sp,
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.restaurant,
                    color: AppColors.grey500,
                    size: 16.sp,
                  ),
                )
              : Icon(
                  Icons.restaurant,
                  color: AppColors.grey500,
                  size: 16.sp,
                ),
        ),
        title: Text(
          ingredient.name,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${ingredient.code} • ${ingredient.category}',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Formatters.currency(ingredient.purchasePrice),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${ingredient.baseUnit}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}