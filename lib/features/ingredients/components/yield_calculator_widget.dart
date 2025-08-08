import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/formatters.dart';

class YieldCalculatorController extends GetxController {
  // Controladores de entrada
  final grossWeightController = TextEditingController();
  final netWeightController = TextEditingController();
  final wasteWeightController = TextEditingController();
  final reusableWasteController = TextEditingController();
  final priceController = TextEditingController();
  final unitController = TextEditingController(text: 'kg');
  
  // Resultados calculados
  final RxDouble usablePercentage = 0.0.obs;
  final RxDouble wastePercentage = 0.0.obs;
  final RxDouble reusableWastePercentage = 0.0.obs;
  final RxDouble realCostPerUnit = 0.0.obs;
  final RxDouble totalWastePercentage = 0.0.obs;
  
  // Estado de la calculadora
  final RxString calculationMethod = 'weight'.obs; // 'weight' o 'percentage'
  final RxBool hasValidCalculation = false.obs;
  final RxString selectedIngredientType = 'Verdura'.obs;
  
  // Datos de ejemplo por tipo de ingrediente
  final Map<String, Map<String, double>> exampleYields = {
    'Verdura': {'usable': 85, 'reusable': 10, 'waste': 5},
    'Fruta': {'usable': 75, 'reusable': 20, 'waste': 5},
    'Carne': {'usable': 70, 'reusable': 25, 'waste': 5},
    'Pescado': {'usable': 60, 'reusable': 30, 'waste': 10},
    'Ave': {'usable': 75, 'reusable': 20, 'waste': 5},
  };
  
  @override
  void onInit() {
    super.onInit();
    _setupListeners();
  }
  
  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }
  
  void _disposeControllers() {
    grossWeightController.dispose();
    netWeightController.dispose();
    wasteWeightController.dispose();
    reusableWasteController.dispose();
    priceController.dispose();
    unitController.dispose();
  }
  
  void _setupListeners() {
    // Escuchar cambios en los campos de peso
    grossWeightController.addListener(_calculateFromWeights);
    netWeightController.addListener(_calculateFromWeights);
    wasteWeightController.addListener(_calculateFromWeights);
    reusableWasteController.addListener(_calculateFromWeights);
    priceController.addListener(_calculateRealCost);
  }
  
  void _calculateFromWeights() {
    if (calculationMethod.value != 'weight') return;
    
    final grossWeight = double.tryParse(grossWeightController.text) ?? 0;
    final netWeight = double.tryParse(netWeightController.text) ?? 0;
    final wasteWeight = double.tryParse(wasteWeightController.text) ?? 0;
    final reusableWaste = double.tryParse(reusableWasteController.text) ?? 0;
    
    if (grossWeight <= 0) {
      _resetCalculations();
      return;
    }
    
    // Calcular porcentajes
    usablePercentage.value = (netWeight / grossWeight) * 100;
    wastePercentage.value = (wasteWeight / grossWeight) * 100;
    reusableWastePercentage.value = (reusableWaste / grossWeight) * 100;
    totalWastePercentage.value = wastePercentage.value + reusableWastePercentage.value;
    
    // Validar que los pesos coincidan
    final totalCalculated = netWeight + wasteWeight + reusableWaste;
    final tolerance = grossWeight * 0.02; // 2% de tolerancia
    
    hasValidCalculation.value = (totalCalculated - grossWeight).abs() <= tolerance;
    
    _calculateRealCost();
  }
  
  void _calculateRealCost() {
    final price = double.tryParse(priceController.text) ?? 0;
    
    if (price <= 0 || usablePercentage.value <= 0) {
      realCostPerUnit.value = 0;
      return;
    }
    
    realCostPerUnit.value = price / (usablePercentage.value / 100);
  }
  
  void _resetCalculations() {
    usablePercentage.value = 0;
    wastePercentage.value = 0;
    reusableWastePercentage.value = 0;
    totalWastePercentage.value = 0;
    realCostPerUnit.value = 0;
    hasValidCalculation.value = false;
  }
  
  void switchCalculationMethod(String method) {
    calculationMethod.value = method;
    _resetCalculations();
    
    if (method == 'weight') {
      _calculateFromWeights();
    }
  }
  
  void loadExampleData() {
    final example = exampleYields[selectedIngredientType.value]!;
    
    // Simular pesos basados en 1kg de peso bruto
    final grossWeight = 1000.0; // gramos
    final netWeight = grossWeight * (example['usable']! / 100);
    final reusableWaste = grossWeight * (example['reusable']! / 100);
    final waste = grossWeight * (example['waste']! / 100);
    
    grossWeightController.text = grossWeight.toString();
    netWeightController.text = netWeight.toStringAsFixed(0);
    reusableWasteController.text = reusableWaste.toStringAsFixed(0);
    wasteWeightController.text = waste.toStringAsFixed(0);
    
    _calculateFromWeights();
  }
  
  void clearAll() {
    grossWeightController.clear();
    netWeightController.clear();
    wasteWeightController.clear();
    reusableWasteController.clear();
    priceController.clear();
    _resetCalculations();
  }
  
  Map<String, dynamic> getCalculationResults() {
    return {
      'usablePercentage': usablePercentage.value,
      'reusableWastePercentage': reusableWastePercentage.value,
      'totalWastePercentage': wastePercentage.value,
      'realCostPerUnit': realCostPerUnit.value,
    };
  }
}

class YieldCalculatorWidget extends GetView<YieldCalculatorController> {
  const YieldCalculatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Asegurar que el controlador esté disponible
    Get.lazyPut(() => YieldCalculatorController());
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppDimensions.paddingL),
            _buildMethodSelector(),
            SizedBox(height: AppDimensions.paddingL),
            _buildCalculatorContent(),
            SizedBox(height: AppDimensions.paddingL),
            _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.calculate,
          color: AppColors.primary,
          size: 24.sp,
        ),
        SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: Text(
            'Calculadora de Rendimiento',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, size: 20.sp),
          onSelected: _onMenuSelected,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'example',
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 18.sp),
                  SizedBox(width: AppDimensions.paddingS),
                  const Text('Cargar ejemplo'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.clear_all, size: 18.sp),
                  SizedBox(width: AppDimensions.paddingS),
                  const Text('Limpiar todo'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help_outline, size: 18.sp),
                  SizedBox(width: AppDimensions.paddingS),
                  const Text('Ayuda'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: _buildMethodButton(
              'Pesar ingredientes',
              'weight',
              Icons.scale,
              controller.calculationMethod.value == 'weight',
            ),
          ),
          Expanded(
            child: _buildMethodButton(
              'Usar porcentajes',
              'percentage',
              Icons.percent,
              controller.calculationMethod.value == 'percentage',
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildMethodButton(String text, String method, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.switchCalculationMethod(method),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.paddingM,
          horizontal: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              size: 18.sp,
            ),
            SizedBox(width: AppDimensions.paddingXS),
            Flexible(
              child: Text(
                text,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorContent() {
    return Obx(() {
      if (controller.calculationMethod.value == 'weight') {
        return _buildWeightCalculator();
      } else {
        return _buildPercentageCalculator();
      }
    });
  }

  Widget _buildWeightCalculator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingresa los pesos después de procesar el ingrediente:',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppDimensions.paddingM),
        
        // Peso bruto
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                controller: controller.grossWeightController,
                label: 'Peso bruto inicial *',
                hint: '1000',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  child: Text(
                    'g',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 20.sp,
                    ),
                    SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      'Peso completo sin procesar',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.info,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.paddingM),
        
        // Grid de pesos procesados
        _buildWeightInputsGrid(),
        SizedBox(height: AppDimensions.paddingM),
        
        // Validación de pesos
        _buildWeightValidation(),
        
        SizedBox(height: AppDimensions.paddingM),
        
        // Campo de precio para cálculo de costo real
        CustomTextField(
          controller: controller.priceController,
          label: 'Precio pagado por el peso bruto',
          hint: '5.50',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixIcon: Icon(Icons.attach_money, size: 20.sp),
        ),
      ],
    );
  }

  Widget _buildWeightInputsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        
        if (isWide) {
          // Layout horizontal para pantallas grandes
          return Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: controller.netWeightController,
                  label: 'Peso neto útil',
                  hint: '800',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  suffixIcon: _buildUnitSuffix(),
                ),
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: CustomTextField(
                  controller: controller.reusableWasteController,
                  label: 'Merma reutilizable',
                  hint: '150',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  suffixIcon: _buildUnitSuffix(),
                ),
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: CustomTextField(
                  controller: controller.wasteWeightController,
                  label: 'Desperdicio',
                  hint: '50',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  suffixIcon: _buildUnitSuffix(),
                ),
              ),
            ],
          );
        } else {
          // Layout vertical para pantallas pequeñas
          return Column(
            children: [
              CustomTextField(
                controller: controller.netWeightController,
                label: 'Peso neto útil',
                hint: '800',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                suffixIcon: _buildUnitSuffix(),
              ),
              SizedBox(height: AppDimensions.paddingM),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.reusableWasteController,
                      label: 'Merma reutilizable',
                      hint: '150',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      suffixIcon: _buildUnitSuffix(),
                    ),
                  ),
                  SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: CustomTextField(
                      controller: controller.wasteWeightController,
                      label: 'Desperdicio',
                      hint: '50',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      suffixIcon: _buildUnitSuffix(),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildUnitSuffix() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      child: Text(
        'g',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildWeightValidation() {
    return Obx(() {
      final gross = double.tryParse(controller.grossWeightController.text) ?? 0;
      final net = double.tryParse(controller.netWeightController.text) ?? 0;
      final reusable = double.tryParse(controller.reusableWasteController.text) ?? 0;
      final waste = double.tryParse(controller.wasteWeightController.text) ?? 0;
      final total = net + reusable + waste;
      
      if (gross > 0 && total > 0) {
        final difference = (total - gross).abs();
        final isValid = difference <= (gross * 0.02); // 2% tolerancia
        
        return Container(
          padding: EdgeInsets.all(AppDimensions.paddingS),
          decoration: BoxDecoration(
            color: isValid 
                ? AppColors.success.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Row(
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.warning,
                color: isValid ? AppColors.success : AppColors.warning,
                size: 16.sp,
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: Text(
                  isValid 
                      ? 'Los pesos coinciden correctamente'
                      : 'Diferencia: ${difference.toStringAsFixed(1)}g (${((difference / gross) * 100).toStringAsFixed(1)}%)',
                  style: AppTypography.bodySmall.copyWith(
                    color: isValid ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      
      return const SizedBox.shrink();
    });
  }

  Widget _buildPercentageCalculator() {
    return Column(
      children: [
        Text(
          'Próximamente: Calculadora por porcentajes',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppDimensions.paddingL),
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Column(
            children: [
              Icon(
                Icons.construction,
                size: 48.sp,
                color: AppColors.grey500,
              ),
              SizedBox(height: AppDimensions.paddingM),
              Text(
                'Esta funcionalidad estará disponible en la próxima actualización',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Obx(() {
      if (!controller.hasValidCalculation.value) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.primaryLight.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: AppDimensions.paddingS),
                Text(
                  'Resultados del Análisis',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingM),
            
            // Grid de resultados responsivo
            _buildResultsGrid(),
            
            if (controller.realCostPerUnit.value > 0) ...[
              SizedBox(height: AppDimensions.paddingM),
              _buildCostSummary(),
            ],
            
            SizedBox(height: AppDimensions.paddingM),
            
            // Botones de acción
            _buildActionButtons(),
          ],
        ),
      );
    });
  }

  Widget _buildResultsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 400;
        
        if (isWide) {
          return Row(
            children: [
              Expanded(
                child: _buildResultCard(
                  'Aprovechable',
                  '${controller.usablePercentage.value.toStringAsFixed(1)}%',
                  AppColors.success,
                  Icons.check_circle,
                ),
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: _buildResultCard(
                  'Merma útil',
                  '${controller.reusableWastePercentage.value.toStringAsFixed(1)}%',
                  AppColors.warning,
                  Icons.recycling,
                ),
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: _buildResultCard(
                  'Desperdicio',
                  '${controller.wastePercentage.value.toStringAsFixed(1)}%',
                  AppColors.error,
                  Icons.delete,
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildResultCard(
                'Aprovechable',
                '${controller.usablePercentage.value.toStringAsFixed(1)}%',
                AppColors.success,
                Icons.check_circle,
              ),
              SizedBox(height: AppDimensions.paddingS),
              Row(
                children: [
                  Expanded(
                    child: _buildResultCard(
                      'Merma útil',
                      '${controller.reusableWastePercentage.value.toStringAsFixed(1)}%',
                      AppColors.warning,
                      Icons.recycling,
                    ),
                  ),
                  SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: _buildResultCard(
                      'Desperdicio',
                      '${controller.wastePercentage.value.toStringAsFixed(1)}%',
                      AppColors.error,
                      Icons.delete,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildResultCard(String label, String value, Color color, IconData icon) {
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
          SizedBox(height: AppDimensions.paddingXS),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
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

  Widget _buildCostSummary() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Costo real por ${controller.unitController.text} útil:',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            Formatters.currency(controller.realCostPerUnit.value),
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 300;
        
        if (isWide) {
          return Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Usar en formulario',
                  type: ButtonType.primary,
                  icon: Icons.check,
                  onPressed: _useInForm,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              CustomButton(
                text: 'Compartir',
                type: ButtonType.outline,
                icon: Icons.share,
                onPressed: _shareResults,
              ),
            ],
          );
        } else {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Usar en formulario',
                  type: ButtonType.primary,
                  icon: Icons.check,
                  onPressed: _useInForm,
                ),
              ),
              SizedBox(height: AppDimensions.paddingS),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Compartir resultados',
                  type: ButtonType.outline,
                  icon: Icons.share,
                  onPressed: _shareResults,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'example':
        _showExampleDialog();
        break;
      case 'clear':
        controller.clearAll();
        break;
      case 'help':
        _showHelpDialog();
        break;
    }
  }

  void _showExampleDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Cargar Ejemplo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecciona el tipo de ingrediente para cargar datos de ejemplo:'),
            SizedBox(height: AppDimensions.paddingM),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedIngredientType.value,
              decoration: const InputDecoration(
                labelText: 'Tipo de ingrediente',
              ),
              items: controller.exampleYields.keys.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedIngredientType.value = value;
                }
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.loadExampleData();
              Get.back();
            },
            child: const Text('Cargar'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: AppColors.primary,
              size: 24.sp,
            ),
            SizedBox(width: AppDimensions.paddingS),
            const Text('Ayuda - Calculadora'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                'Cómo usar la calculadora:',
                [
                  '1. Pesa tu ingrediente antes de procesarlo (peso bruto)',
                  '2. Procesa el ingrediente (lava, pela, corta, etc.)',
                  '3. Separa y pesa cada parte:',
                  '   • Peso neto útil: lo que usarás en recetas',
                  '   • Merma reutilizable: cáscaras, huesos para caldo',
                  '   • Desperdicio: lo que va a la basura',
                  '4. Ingresa el precio que pagaste',
                  '5. La calculadora te dará los porcentajes y costo real',
                ],
              ),
              SizedBox(height: AppDimensions.paddingM),
              _buildHelpSection(
                'Ejemplo práctico - Pollo entero:',
                [
                  'Peso bruto: 2000g (pollo completo)',
                  'Peso neto: 1400g (carne limpia)',
                  'Merma útil: 500g (huesos para caldo)',
                  'Desperdicio: 100g (piel, grasa no deseada)',
                  'Precio pagado: \$12.00',
                  '',
                  'Resultado:',
                  '• 70% aprovechable (\$17.14/kg útil)',
                  '• 25% merma reutilizable',
                  '• 5% desperdicio',
                ],
              ),
              SizedBox(height: AppDimensions.paddingM),
              _buildHelpSection(
                'Tips importantes:',
                [
                  '• La calculadora acepta hasta 2% de diferencia en pesos',
                  '• Usa gramos para mayor precisión',
                  '• Incluye el precio del ingrediente completo',
                  '• Separa bien la merma útil del desperdicio real',
                  '• Los resultados se pueden aplicar directamente al formulario',
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: AppDimensions.paddingS),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.paddingXS),
          child: Text(
            item,
            style: AppTypography.bodySmall,
          ),
        )),
      ],
    );
  }

  void _useInForm() {
    final results = controller.getCalculationResults();
    
    // Si hay un IngredientFormController disponible, aplicar los resultados
    try {
      final formController = Get.find<IngredientFormController>();
      formController.usablePercentage.value = results['usablePercentage'];
      formController.reusableWastePercentage.value = results['reusableWastePercentage'];
      formController.totalWastePercentage.value = results['totalWastePercentage'];
      
      Get.snackbar(
        'Éxito',
        'Resultados aplicados al formulario',
        backgroundColor: AppColors.success.withOpacity(0.1),
        colorText: AppColors.success,
        icon: const Icon(Icons.check, color: AppColors.success),
      );
      
      Get.back(); // Cerrar la calculadora
    } catch (e) {
      Get.snackbar(
        'Información',
        'Los resultados están listos para usar',
        backgroundColor: AppColors.info.withOpacity(0.1),
        colorText: AppColors.info,
        icon: const Icon(Icons.info, color: AppColors.info),
      );
    }
  }

  void _shareResults() {
    final results = controller.getCalculationResults();
    final grossWeight = controller.grossWeightController.text;
    

    Get.snackbar(
      'Compartir',
      'Funcionalidad de compartir próximamente',
      backgroundColor: AppColors.info.withOpacity(0.1),
      colorText: AppColors.info,
      icon: const Icon(Icons.share, color: AppColors.info),
    );
    
    // TODO: Implementar share real
    // Share.share(shareText);
  }
}

// Widget standalone para usar la calculadora en un dialog/bottom sheet
class YieldCalculatorDialog extends StatelessWidget {
  const YieldCalculatorDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
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
            
            // Header con título
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
              child: Row(
                children: [
                  Icon(
                    Icons.calculate,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: Text(
                      'Calculadora de Rendimiento',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Cerrar',
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.screenPadding),
                child: const YieldCalculatorWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

// Widget compacto para integrar en formularios
class YieldCalculatorCompact extends GetView<YieldCalculatorController> {
  const YieldCalculatorCompact({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => YieldCalculatorController());
    
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                'Calculadora Rápida',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => YieldCalculatorDialog.show(context),
                child: const Text('Abrir completa'),
              ),
            ],
          ),
          
          SizedBox(height: AppDimensions.paddingM),
          
          // Campos básicos en layout compacto
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: controller.grossWeightController,
                  label: 'Peso bruto (g)',
                  hint: '1000',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  dense: true,
                ),
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: CustomTextField(
                  controller: controller.netWeightController,
                  label: 'Peso útil (g)',
                  hint: '800',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  dense: true,
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppDimensions.paddingS),
          
          // Resultado compacto
          Obx(() {
            if (controller.hasValidCalculation.value) {
              return Container(
                padding: EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCompactResult(
                      'Rendimiento',
                      '${controller.usablePercentage.value.toStringAsFixed(1)}%',
                      AppColors.success,
                    ),
                    Container(width: 1, height: 20.h, color: AppColors.grey300),
                    _buildCompactResult(
                      'Costo real',
                      controller.realCostPerUnit.value > 0 
                          ? Formatters.currency(controller.realCostPerUnit.value)
                          : '--',
                      AppColors.primary,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildCompactResult(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
                