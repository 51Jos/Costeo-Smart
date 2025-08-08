import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/ingredient_controller.dart';
import '../models/ingredient_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_button.dart';

class IngredientCategoryFilter extends StatelessWidget {
  final IngredientController controller;
  final Function(String)? onCategoryChanged;

  const IngredientCategoryFilter({
    super.key,
    required this.controller,
    this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['Todos', ...IngredientCategories.categories];
    
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: AppDimensions.paddingS),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            return _buildCategoryChip(category, isSelected);
          });
        },
      ),
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (selected) {
        controller.changeCategory(category);
        onCategoryChanged?.call(category);
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.grey300,
          width: 1,
        ),
      ),
      elevation: 0,
      pressElevation: 2,
    );
  }
}

class IngredientSortMenu extends StatelessWidget {
  final IngredientController controller;
  final Function(String)? onSortChanged;

  const IngredientSortMenu({
    super.key,
    required this.controller,
    this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sort,
            size: 20.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: AppDimensions.paddingXXS),
          Obx(() => Text(
            _getSortLabel(controller.sortBy.value),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          )),
          Icon(
            Icons.arrow_drop_down,
            size: 16.sp,
            color: AppColors.textSecondary,
          ),
        ],
      ),
      onSelected: (value) {
        controller.changeSorting(value);
        onSortChanged?.call(value);
      },
      itemBuilder: (context) => [
        _buildSortMenuItem('name', 'Nombre', Icons.abc),
        _buildSortMenuItem('price', 'Precio compra', Icons.attach_money),
        _buildSortMenuItem('realCost', 'Costo real', Icons.trending_up),
        _buildSortMenuItem('category', 'Categoría', Icons.category),
        _buildSortMenuItem('date', 'Fecha actualización', Icons.schedule),
        _buildSortMenuItem('supplier', 'Proveedor', Icons.business),
      ],
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String value, String label, IconData icon) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: AppColors.textSecondary),
          SizedBox(width: AppDimensions.paddingS),
          Text(label),
          const Spacer(),
          // Mostrar indicador de orden actual
          Obx(() {
            if (controller.sortBy.value == value) {
              return Icon(
                controller.sortAscending.value 
                    ? Icons.arrow_upward 
                    : Icons.arrow_downward,
                size: 16.sp,
                color: AppColors.primary,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  String _getSortLabel(String sortBy) {
    switch (sortBy) {
      case 'name': return 'Nombre';
      case 'price': return 'Precio';
      case 'realCost': return 'Costo real';
      case 'category': return 'Categoría';
      case 'date': return 'Fecha';
      case 'supplier': return 'Proveedor';
      default: return 'Ordenar';
    }
  }
}

class IngredientFiltersBottomSheet extends StatelessWidget {
  final IngredientController controller;

  const IngredientFiltersBottomSheet({
    super.key,
    required this.controller,
  });

  static void show(BuildContext context, IngredientController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => IngredientFiltersBottomSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetRadius),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: AppDimensions.bottomSheetHandleWidth,
            height: AppDimensions.bottomSheetHandleHeight,
            margin: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: AppColors.grey400,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
          ),
          
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
            child: Row(
              children: [
                Text(
                  'Filtros',
                  style: AppTypography.headlineSmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    controller.clearFilters();
                  },
                  child: const Text('Limpiar todo'),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(),
                  SizedBox(height: AppDimensions.sectionSpacing),
                  _buildPriceRangeSection(),
                  SizedBox(height: AppDimensions.sectionSpacing),
                  _buildYieldRangeSection(),
                  SizedBox(height: AppDimensions.sectionSpacing),
                  _buildSupplierSection(),
                  SizedBox(height: AppDimensions.sectionSpacing),
                  _buildOtherFiltersSection(),
                ],
              ),
            ),
          ),
          
          // Footer con botones
          Container(
            padding: EdgeInsets.all(AppDimensions.screenPadding),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.grey200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancelar',
                    type: ButtonType.outline,
                    onPressed: () => Get.back(),
                  ),
                ),
                SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: CustomButton(
                    text: 'Aplicar filtros',
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorías',
          style: AppTypography.titleMedium,
        ),
        SizedBox(height: AppDimensions.paddingM),
        Wrap(
          spacing: AppDimensions.paddingS,
          runSpacing: AppDimensions.paddingS,
          children: IngredientCategories.categories.map((category) {
            return Obx(() {
              final isSelected = controller.selectedCategory.value == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  controller.changeCategory(selected ? category : 'Todos');
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rango de precio',
          style: AppTypography.titleMedium,
        ),
        SizedBox(height: AppDimensions.paddingM),
        // Aquí se implementaría un RangeSlider para filtrar por precio
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Text(
            'Filtro de rango de precios próximamente',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildYieldRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rendimiento mínimo',
          style: AppTypography.titleMedium,
        ),
        SizedBox(height: AppDimensions.paddingM),
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Text(
            'Filtro por rendimiento próximamente',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSupplierSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proveedor',
          style: AppTypography.titleMedium,
        ),
        SizedBox(height: AppDimensions.paddingM),
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Text(
            'Filtro por proveedor próximamente',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildOtherFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Otros filtros',
          style: AppTypography.titleMedium,
        ),
        SizedBox(height: AppDimensions.paddingM),
        CheckboxListTile(
          title: const Text('Solo precios desactualizados'),
          value: false, // Implementar estado
          onChanged: (value) {
            // Implementar filtro
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: const Text('Solo ingredientes con imagen'),
          value: false, // Implementar estado
          onChanged: (value) {
            // Implementar filtro
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: const Text('Rendimiento bajo (<75%)'),
          value: false, // Implementar estado
          onChanged: (value) {
            // Implementar filtro
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}

// Widget para mostrar estadísticas rápidas
class IngredientStatsBar extends StatelessWidget {
  final IngredientController controller;

  const IngredientStatsBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingStats.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        padding: EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Total',
                '${controller.totalIngredients}',
                Icons.inventory,
              ),
            ),
            _buildDivider(),
            Expanded(
              child: _buildStatItem(
                'Promedio',
                '\${controller.averagePrice.toStringAsFixed(1)}',
                Icons.attach_money,
              ),
            ),
            _buildDivider(),
            Expanded(
              child: _buildStatItem(
                'Desactualizado',
                '${controller.outdatedPricesCount}',
                Icons.warning,
                color: controller.outdatedPricesCount > 0 ? AppColors.warning : null,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(
          icon,
          color: color ?? AppColors.primary,
          size: 20.sp,
        ),
        SizedBox(height: AppDimensions.paddingXS),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: color ?? AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40.h,
      color: AppColors.primary.withOpacity(0.2),
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
    );
  }
}