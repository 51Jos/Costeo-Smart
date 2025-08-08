import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../components/ingredient_form.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_widget.dart';

class IngredientCreateView extends StatelessWidget {
  const IngredientCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    // Asegurar que el controlador del formulario esté disponible
    Get.lazyPut(() => IngredientFormController());
    final formController = Get.find<IngredientFormController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(formController),
      body: _buildBody(formController),
      bottomNavigationBar: _buildBottomBar(formController),
    );
  }

  PreferredSizeWidget _buildAppBar(IngredientFormController controller) {
    return AppBar(
      title: Obx(() => Text(
        controller.isEditing.value ? 'Editar Ingrediente' : 'Nuevo Ingrediente',
      )),
      elevation: 0,
      backgroundColor: AppColors.surface,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _onBackPressed(controller),
      ),
      actions: [
        // Botón de ayuda
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: _showHelp,
          tooltip: 'Ayuda',
        ),
        
        // Botón de guardar rápido (solo si es válido)
        Obx(() {
          if (controller.formKey.currentState?.validate() == true && 
              controller.isYieldValid) {
            return TextButton(
              onPressed: controller.isLoading.value ? null : controller.saveIngredient,
              child: const Text('Guardar'),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildBody(IngredientFormController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return LoadingOverlay(
          isLoading: true,
          child: const IngredientForm(),
        );
      }
      
      return const IngredientForm();
    });
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador de progreso de formulario
            _buildProgressIndicator(controller),
            SizedBox(height: AppDimensions.paddingM),
            
            // Botones de acción
            Row(
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
                    text: controller.isEditing.value ? 'Actualizar' : 'Crear Ingrediente',
                    onPressed: controller.isLoading.value ? null : controller.saveIngredient,
                    isLoading: controller.isLoading.value,
                    icon: controller.isEditing.value ? Icons.update : Icons.add,
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(IngredientFormController controller) {
    return Obx(() {
      // Calcular progreso del formulario
      int completedFields = 0;
      int totalFields = 5; // Campos obligatorios básicos
      
      if (controller.nameController.text.isNotEmpty) completedFields++;
      if (controller.codeController.text.isNotEmpty) completedFields++;
      if (controller.priceController.text.isNotEmpty) completedFields++;
      if (controller.primarySupplierController.text.isNotEmpty) completedFields++;
      if (controller.isYieldValid) completedFields++;
      
      final progress = completedFields / totalFields;
      final isComplete = completedFields == totalFields;
      
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isComplete 
              ? AppColors.success.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Row(
          children: [
            Icon(
              isComplete ? Icons.check_circle : Icons.info,
              color: isComplete ? AppColors.success : AppColors.primary,
              size: 20.sp,
            ),
            SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isComplete 
                        ? 'Formulario completado' 
                        : 'Progreso: $completedFields/$totalFields campos',
                    style: AppTypography.labelMedium.copyWith(
                      color: isComplete ? AppColors.success : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingXXS),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isComplete ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

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
    // Si estamos editando, comparar con valores originales
    if (controller.isEditing.value && controller.originalIngredient != null) {
      final original = controller.originalIngredient!;
      return controller.nameController.text != original.name ||
             controller.codeController.text != original.code ||
             controller.priceController.text != original.purchasePrice.toString() ||
             controller.primarySupplierController.text != original.primarySupplier ||
             controller.selectedCategory.value != original.category ||
             controller.usablePercentage.value != original.usablePercentage;
    }
    
    // Si es nuevo, verificar si hay algún campo con contenido
    return controller.nameController.text.isNotEmpty ||
           controller.codeController.text.isNotEmpty ||
           controller.priceController.text.isNotEmpty ||
           controller.primarySupplierController.text.isNotEmpty ||
           controller.descriptionController.text.isNotEmpty;
  }

  void _showHelp() {
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
                    Icons.help,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: AppDimensions.paddingS),
                  Text(
                    'Ayuda - Ingredientes',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.primary,
                    ),
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
                    _buildHelpSection(
                      'Información Básica',
                      [
                        'Nombre: Usa nombres descriptivos (ej: "Tomate cherry rojo")',
                        'Código SKU: Crea códigos únicos fáciles de recordar (ej: "TOM-CHE-001")',
                        'Categoría: Selecciona la categoría más específica posible',
                      ],
                    ),
                    
                    _buildHelpSection(
                      'Calculadora de Rendimiento',
                      [
                        'Parte aprovechable: % que realmente usarás en tus recetas',
                        'Merma reutilizable: % que puedes usar para otros propósitos (ej: cáscaras para caldo)',
                        'Desperdicio: % que no tiene ningún uso',
                        'El total debe sumar exactamente 100%',
                      ],
                    ),
                    
                    _buildHelpSection(
                      'Precios',
                      [
                        'Precio de compra: Lo que pagas al proveedor por la unidad completa',
                        'Costo real: Se calcula automáticamente basado en el rendimiento',
                        'Ejemplo: Si un kilo cuesta \$5 y solo aprovechas 80%, el costo real es \$6.25/kg útil',
                      ],
                    ),
                    
                    _buildHelpSection(
                      'Consejos',
                      [
                        'Actualiza los precios regularmente para mantener exactitud',
                        'Usa la descripción para notas importantes sobre el ingrediente',
                        'Los proveedores alternativos te ayudan a comparar precios',
                        'Marca todos los alérgenos presentes para evitar problemas',
                      ],
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

  Widget _buildHelpSection(String title, List<String> tips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: AppDimensions.paddingS),
        ...tips.map((tip) => Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.paddingS),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.warning,
                size: 16.sp,
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: Text(
                  tip,
                  style: AppTypography.bodyMedium,
                ),
              ),
            ],
          ),
        )),
        SizedBox(height: AppDimensions.paddingL),
      ],
    );
  }
}