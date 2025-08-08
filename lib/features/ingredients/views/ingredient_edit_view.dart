import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../components/ingredient_form.dart';
import '../components/yield_calculator_widget.dart';
import '../models/ingredient_model.dart';
import '../controllers/ingredient_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/utils/formatters.dart';

class IngredientEditView extends StatelessWidget {
  const IngredientEditView({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ingrediente a editar
    final ingredient = Get.arguments as IngredientModel;
    
    // Asegurar que el controlador del formulario esté disponible
    Get.lazyPut(() => IngredientFormController());
    final formController = Get.find<IngredientFormController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(formController, ingredient),
      body: _buildBody(formController, ingredient),
      bottomNavigationBar: _buildBottomBar(formController),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(IngredientFormController controller, IngredientModel ingredient) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Editar Ingrediente'),
          Text(
            ingredient.name,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: AppColors.surface,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _onBackPressed(controller),
      ),
      actions: [
        // Botón de historial de precios
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => _showPriceHistory(ingredient),
          tooltip: 'Historial de precios',
        ),
        
        // Botón de calculadora
        IconButton(
          icon: const Icon(Icons.calculate),
          onPressed: () => YieldCalculatorDialog.show(Get.context!),
          tooltip: 'Calculadora de rendimiento',
        ),
        
        // Menú de opciones adicionales
        PopupMenuButton<String>(
          onSelected: (value) => _onMenuSelected(value, ingredient, controller),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(Icons.copy, size: 18.sp),
                  SizedBox(width: AppDimensions.paddingS),
                  const Text('Duplicar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'compare',
              child: Row(
                children: [
                  Icon(Icons.compare_arrows, size: 18.sp),
                  SizedBox(width: AppDimensions.paddingS),
                  const Text('Comparar precios'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18.sp, color: Colors.red),
                  SizedBox(width: AppDimensions.paddingS),
                  Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(IngredientFormController controller, IngredientModel ingredient) {
    return Column(
      children: [
        // Header con información clave del ingrediente actual
        _buildIngredientHeader(ingredient),
        
        // Formulario de edición
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return LoadingOverlay(
                isLoading: true,
                child: const IngredientForm(),
              );
            }
            
            return const IngredientForm();
          }),
        ),
      ],
    );
  }

  Widget _buildIngredientHeader(IngredientModel ingredient) {
    return Container(
      margin: EdgeInsets.all(AppDimensions.screenPadding),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primaryLight.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Ícono de categoría
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: _getCategoryColor(ingredient.category).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Icon(
                  _getCategoryIcon(ingredient.category),
                  color: _getCategoryColor(ingredient.category),
                  size: 24.sp,
                ),
              ),
              
              SizedBox(width: AppDimensions.paddingM),
              
              // Información básica
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ingredient.name,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingS,
                            vertical: AppDimensions.paddingXXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                          ),
                          child: Text(
                            ingredient.code,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.info,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      '${ingredient.category} • ${ingredient.primarySupplier}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppDimensions.paddingM),
          
          // Métricas actuales responsivas
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 500) {
                // Layout horizontal para pantallas grandes
                return Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'Precio Actual',
                        '${ingredient.purchasePrice.toStringAsFixed(2)}',
                        '/${ingredient.baseUnit}',
                        AppColors.primary,
                        Icons.attach_money,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingS),
                    Expanded(
                      child: _buildMetricCard(
                        'Costo Real',
                        '${ingredient.realCostPerUsableUnit.toStringAsFixed(2)}',
                        '/${ingredient.baseUnit} útil',
                        AppColors.secondary,
                        Icons.trending_up,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingS),
                    Expanded(
                      child: _buildMetricCard(
                        'Rendimiento',
                        '${ingredient.usablePercentage.toStringAsFixed(0)}%',
                        'aprovechable',
                        _getYieldColor(ingredient.usablePercentage),
                        Icons.pie_chart,
                      ),
                    ),
                  ],
                );
              } else {
                // Layout vertical para pantallas pequeñas
                return Column(
                  children: [
                    _buildMetricCard(
                      'Precio Actual',
                      '${ingredient.purchasePrice.toStringAsFixed(2)}',
                      '/${ingredient.baseUnit}',
                      AppColors.primary,
                      Icons.attach_money,
                    ),
                    SizedBox(height: AppDimensions.paddingS),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Costo Real',
                            '${ingredient.realCostPerUsableUnit.toStringAsFixed(2)}',
                            '/${ingredient.baseUnit} útil',
                            AppColors.secondary,
                            Icons.trending_up,
                          ),
                        ),
                        SizedBox(width: AppDimensions.paddingS),
                        Expanded(
                          child: _buildMetricCard(
                            'Rendimiento',
                            '${ingredient.usablePercentage.toStringAsFixed(0)}%',
                            'aprovechable',
                            _getYieldColor(ingredient.usablePercentage),
                            Icons.pie_chart,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String unit, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 16.sp,
          ),
          SizedBox(height: AppDimensions.paddingXXS),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTypography.titleSmall.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: unit,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            label,
            style: AppTypography.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(IngredientFormController controller) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Cancelar',
                type: ButtonType.outline,
                onPressed: () => _onBackPressed(controller),
              ),
            ),
            SizedBox(width: AppDimensions.paddingM),
            Expanded(
              flex: 2,
              child: Obx(() => CustomButton(
                text: 'Guardar Cambios',
                onPressed: controller.isLoading.value ? null : controller.saveIngredient,
                isLoading: controller.isLoading.value,
                icon: Icons.save,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => YieldCalculatorDialog.show(Get.context!),
      backgroundColor: AppColors.secondary,
      child: const Icon(Icons.calculate),
      tooltip: 'Calculadora de rendimiento',
    );
  }

  // Métodos auxiliares para colores e iconos
  Color _getCategoryColor(String category) {
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
    
    return categoryColors[category] ?? AppColors.grey500;
  }

  IconData _getCategoryIcon(String category) {
    const categoryIcons = {
      'Verduras': Icons.eco,
      'Frutas': Icons.apple,
      'Carnes Rojas': Icons.restaurant,
      'Carnes Blancas': Icons.restaurant_menu,
      'Pescados y Mariscos': Icons.set_meal,
      'Lácteos': Icons.local_drink,
      'Granos y Cereales': Icons.grain,
      'Especias y Condimentos': Icons.local_pharmacy,
      'Aceites y Grasas': Icons.opacity,
      'Bebidas': Icons.local_bar,
      'Endulzantes': Icons.cake,
      'Harinas': Icons.bakery_dining,
      'Conservas': Icons.inventory,
      'Congelados': Icons.ac_unit,
      'Otros': Icons.category,
    };
    
    return categoryIcons[category] ?? Icons.restaurant;
  }

  Color _getYieldColor(double yield) {
    if (yield >= 90) return AppColors.success;
    if (yield >= 75) return AppColors.warning;
    return AppColors.error;
  }

  // Métodos de interacción
  void _onBackPressed(IngredientFormController controller) {
    // Verificar si hay cambios sin guardar
    bool hasChanges = _hasUnsavedChanges(controller);
    
    if (!hasChanges) {
      Get.back();
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('¿Descartar cambios?'),
        content: const Text(
          'Tienes cambios sin guardar. ¿Estás seguro de que quieres salir?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Cerrar diálogo
              Get.back(); // Cerrar formulario
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }

  bool _hasUnsavedChanges(IngredientFormController controller) {
    if (controller.originalIngredient == null) return false;
    
    final original = controller.originalIngredient!;
    return controller.nameController.text != original.name ||
           controller.codeController.text != original.code ||
           controller.priceController.text != original.purchasePrice.toString() ||
           controller.primarySupplierController.text != original.primarySupplier ||
           controller.selectedCategory.value != original.category ||
           controller.usablePercentage.value != original.usablePercentage ||
           controller.reusableWastePercentage.value != original.reusableWastePercentage ||
           controller.totalWastePercentage.value != original.totalWastePercentage;
  }

  void _onMenuSelected(String value, IngredientModel ingredient, IngredientFormController controller) {
    switch (value) {
      case 'duplicate':
        _duplicateIngredient(ingredient);
        break;
      case 'compare':
        _showPriceComparison(ingredient);
        break;
      case 'delete':
        _deleteIngredient(ingredient);
        break;
    }
  }

  void _duplicateIngredient(IngredientModel ingredient) {
    Get.dialog(
      AlertDialog(
        title: const Text('Duplicar Ingrediente'),
        content: const Text(
          '¿Quieres crear un nuevo ingrediente basado en este? '
          'Se copiará toda la información excepto el código SKU.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Navegar al formulario de creación con datos pre-cargados
              final duplicatedIngredient = ingredient.copyWith(
                id: '',
                code: '${ingredient.code}_COPY',
                name: '${ingredient.name} (Copia)',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              
              Get.toNamed('/ingredient/create', arguments: duplicatedIngredient);
            },
            child: const Text('Duplicar'),
          ),
        ],
      ),
    );
  }

  void _showPriceHistory(IngredientModel ingredient) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: Text(
                      'Historial de Precios',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Contenido de historial (próximamente)
            Expanded(
              child: _buildPriceHistoryContent(ingredient),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildPriceHistoryContent(IngredientModel ingredient) {
    // Simular algunos datos de historial para mostrar la UI
    final mockHistory = [
      {
        'date': DateTime.now(),
        'price': ingredient.purchasePrice,
        'supplier': ingredient.primarySupplier,
        'notes': 'Precio actual',
        'isCurrent': true,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'price': ingredient.purchasePrice * 0.95,
        'supplier': ingredient.primarySupplier,
        'notes': 'Precio anterior',
        'isCurrent': false,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 60)),
        'price': ingredient.purchasePrice * 1.05,
        'supplier': ingredient.primarySupplier,
        'notes': 'Aumento estacional',
        'isCurrent': false,
      },
    ];

    if (mockHistory.isEmpty) {
      return Container(
        padding: EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 64.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: AppDimensions.paddingL),
            Text(
              'Sin historial de precios',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            Text(
              'Los cambios de precio aparecerán aquí',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.screenPadding),
      itemCount: mockHistory.length,
      itemBuilder: (context, index) {
        final historyItem = mockHistory[index];
        return _buildPriceHistoryItem(historyItem, index == 0);
      },
    );
  }

  Widget _buildPriceHistoryItem(Map<String, dynamic> historyItem, bool isLatest) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: isLatest ? AppColors.primary : AppColors.grey400,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.currency(historyItem['price']),
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isLatest ? AppColors.primary : null,
                          ),
                        ),
                        if (isLatest)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingS,
                              vertical: AppDimensions.paddingXXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                            ),
                            child: Text(
                              'Actual',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      '${historyItem['supplier']} • ${Formatters.dateTime(historyItem['date'])}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (historyItem['notes'] != null) ...[
                      SizedBox(height: AppDimensions.paddingXS),
                      Text(
                        historyItem['notes'],
                        style: AppTypography.bodySmall.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPriceComparison(IngredientModel ingredient) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
              child: Row(
                children: [
                  Icon(
                    Icons.compare_arrows,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: Text(
                      'Comparar Precios',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Contenido de comparación
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ingrediente actual
                    _buildComparisonCard(
                      'Precio Actual',
                      ingredient.primarySupplier,
                      ingredient.purchasePrice,
                      ingredient.baseUnit,
                      ingredient.realCostPerUsableUnit,
                      AppColors.primary,
                      isCurrent: true,
                    ),
                    
                    SizedBox(height: AppDimensions.paddingL),
                    
                    Text(
                      'Proveedores Alternativos',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingM),
                    
                    // Simulación de precios alternativos
                    ...ingredient.alternativeSuppliers.map((supplier) {
                      final simulatedPrice = ingredient.purchasePrice * (0.9 + (supplier.hashCode % 30) / 100);
                      final simulatedRealCost = simulatedPrice / (ingredient.usablePercentage / 100);
                      
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppDimensions.paddingM),
                        child: _buildComparisonCard(
                          'Precio Estimado',
                          supplier,
                          simulatedPrice,
                          ingredient.baseUnit,
                          simulatedRealCost,
                          AppColors.secondary,
                        ),
                      );
                    }),
                    
                    if (ingredient.alternativeSuppliers.isEmpty)
                      Container(
                        padding: EdgeInsets.all(AppDimensions.paddingL),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.store,
                              size: 48.sp,
                              color: AppColors.grey500,
                            ),
                            SizedBox(height: AppDimensions.paddingM),
                            Text(
                              'No hay proveedores alternativos',
                              style: AppTypography.titleSmall.copyWith(
                                color: AppColors.grey600,
                              ),
                            ),
                            SizedBox(height: AppDimensions.paddingS),
                            Text(
                              'Agrega proveedores alternativos para comparar precios',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.grey500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildComparisonCard(
    String label,
    String supplier,
    double price,
    String unit,
    double realCost,
    Color color, {
    bool isCurrent = false,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: color,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isCurrent)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: AppDimensions.paddingXXS,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    'ACTUAL',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isCurrent) SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: Text(
                  supplier,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingM),
          
          // Precio y costo real - Layout responsivo
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 300) {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precio de compra',
                            style: AppTypography.labelMedium,
                          ),
                          Text(
                            '\${price.toStringAsFixed(2)}/$unit',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: AppColors.grey300,
                      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Costo real',
                            style: AppTypography.labelMedium,
                          ),
                          Text(
                            '\${realCost.toStringAsFixed(2)}/$unit útil',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Precio de compra',
                          style: AppTypography.labelMedium,
                        ),
                        Text(
                          '\${price.toStringAsFixed(2)}/$unit',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.paddingM),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Costo real',
                          style: AppTypography.labelMedium,
                        ),
                        Text(
                          '\${realCost.toStringAsFixed(2)}/$unit útil',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _deleteIngredient(IngredientModel ingredient) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: AppColors.error,
              size: 24.sp,
            ),
            SizedBox(width: AppDimensions.paddingS),
            const Text('Eliminar Ingrediente'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro de eliminar "${ingredient.name}"?',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: AppColors.warning,
                    size: 20.sp,
                  ),
                  SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: Text(
                      'Esta acción no se puede deshacer. El ingrediente se marcará como inactivo.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Mostrar información de impacto
            SizedBox(height: AppDimensions.paddingM),
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingS),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información del ingrediente:',
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    '• Código: ${ingredient.code}',
                    style: AppTypography.bodySmall,
                  ),
                  Text(
                    '• Categoría: ${ingredient.category}',
                    style: AppTypography.bodySmall,
                  ),
                  Text(
                    '• Precio actual: ${Formatters.currency(ingredient.purchasePrice)}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Cerrar diálogo
              
              // Mostrar indicador de carga
              Get.dialog(
                const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Eliminando ingrediente...'),
                    ],
                  ),
                ),
                barrierDismissible: false,
              );
              
              // Eliminar ingrediente
              final controller = Get.find<IngredientController>();
              final success = await controller.deleteIngredient(ingredient.id, ingredient.name);
              
              Get.back(); // Cerrar indicador de carga
              
              if (success) {
                // Mostrar confirmación y regresar
                Get.snackbar(
                  'Ingrediente eliminado',
                  '${ingredient.name} ha sido eliminado exitosamente',
                  backgroundColor: AppColors.success.withOpacity(0.1),
                  colorText: AppColors.success,
                  icon: const Icon(Icons.check, color: AppColors.success),
                );
                Get.back(); // Regresar a la lista
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}