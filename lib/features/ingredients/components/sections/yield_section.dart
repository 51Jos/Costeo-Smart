import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import 'base_section.dart';

class YieldSection extends GetView<IngredientFormController> {
  const YieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      title: 'Calculadora de Rendimiento',
      icon: Icons.pie_chart,
      children: [
        Text(
          'Distribuye el 100% del ingrediente en las siguientes categorías:',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        _YieldSlider(
          label: 'Parte aprovechable',
          type: 'usable',
          value: controller.usablePercentage,
          color: AppColors.success,
        ),
        const SizedBox(height: 16),
        _YieldSlider(
          label: 'Merma reutilizable',
          type: 'reusable',
          value: controller.reusableWastePercentage,
          color: AppColors.warning,
        ),
        const SizedBox(height: 16),
        _YieldSlider(
          label: 'Desperdicio total',
          type: 'waste',
          value: controller.totalWastePercentage,
          color: AppColors.error,
        ),
        const SizedBox(height: 16),
        const _YieldTotalIndicator(),
        Obx(() {
          if (controller.reusableWastePercentage.value > 0 ||
              controller.totalWastePercentage.value > 0) {
            return Column(
              children: [
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.wasteDescriptionController,
                  label: 'Descripción del uso de mermas',
                  hint: 'Ej: Cáscaras para caldo, hojas para compost',
                  maxLines: 2,
                  maxLength: 200,
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}

class _YieldSlider extends GetView<IngredientFormController> {
  final String label;
  final String type;
  final RxDouble value;
  final Color color;

  const _YieldSlider({
    required this.label,
    required this.type,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Obx(() => Text(
              '${value.value.toStringAsFixed(1)}%',
              style: AppTypography.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            )),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            inactiveTrackColor: color.withOpacity(0.3),
            overlayColor: color.withOpacity(0.2),
          ),
          child: Slider(
            value: value.value,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (newValue) {
              controller.updateYieldPercentage(type, newValue);
            },
          ),
        )),
      ],
    );
  }
}

class _YieldTotalIndicator extends GetView<IngredientFormController> {
  const _YieldTotalIndicator();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = controller.totalPercentage;
      final isValid = controller.isYieldValid;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isValid
              ? AppColors.success.withOpacity(0.1)
              : AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isValid ? AppColors.success : AppColors.error,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total distribuido:',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${total.toStringAsFixed(1)}%',
              style: AppTypography.titleMedium.copyWith(
                color: isValid ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }
}