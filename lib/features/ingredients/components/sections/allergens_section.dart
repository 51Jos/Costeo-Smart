import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import 'base_section.dart';

class AllergensSection extends GetView<IngredientFormController> {
  const AllergensSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      title: 'Alérgenos',
      icon: Icons.warning,
      children: [
        Text(
          'Selecciona los alérgenos presentes en este ingrediente:',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: CommonAllergens.allergens.map((allergen) {
            return Obx(() {
              final isSelected = controller.selectedAllergens.contains(allergen);
              return FilterChip(
                label: Text(allergen),
                selected: isSelected,
                onSelected: (_) => controller.toggleAllergen(allergen),
                selectedColor: AppColors.error.withOpacity(0.2),
                checkmarkColor: AppColors.error,
                labelStyle: AppTypography.labelMedium.copyWith(
                  color: isSelected ? AppColors.error : AppColors.textSecondary,
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}