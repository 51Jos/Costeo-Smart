import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import 'base_section.dart';

class PriceSection extends GetView<IngredientFormController> {
  final bool isMobile;
  
  const PriceSection({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      title: 'Información de Precio',
      icon: Icons.attach_money,
      children: [
        if (isMobile) ...[
          CustomTextField(
            controller: controller.priceController,
            label: 'Precio de compra *',
            hint: '0.00',
            validator: controller.validatePrice,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: InputFormatters.currency(),
            prefixIcon: const Icon(Icons.attach_money, size: 20),
            onChanged: (value) => controller.update(),
          ),
          const SizedBox(height: 16),
          const _RealCostCard(),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: controller.priceController,
                  label: 'Precio de compra *',
                  hint: '0.00',
                  validator: controller.validatePrice,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: InputFormatters.currency(),
                  prefixIcon: const Icon(Icons.attach_money, size: 20),
                  onChanged: (value) => controller.update(),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: _RealCostCard()),
            ],
          ),
        ],
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.primarySupplierController,
          label: 'Proveedor principal *',
          hint: 'Nombre del proveedor',
          textCapitalization: TextCapitalization.words,
          validator: (value) => Validators.required(value, 'Proveedor principal'),
        ),
      ],
    );
  }
}

class _RealCostCard extends GetView<IngredientFormController> {
  const _RealCostCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final realCost = controller.realCostPerUnit;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Costo real',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${Formatters.currency(realCost)}/${controller.selectedUnit.value} útil',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }
}