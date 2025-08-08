import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import 'base_section.dart';

class SuppliersSection extends GetView<IngredientFormController> {
  final bool isMobile;
  
  const SuppliersSection({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      title: 'Proveedores Alternativos',
      icon: Icons.business,
      children: [
        Text(
          'Proveedores adicionales para este ingrediente:',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        const _SuppliersChips(),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Agregar proveedor',
          type: ButtonType.outline,
          icon: Icons.add,
          onPressed: () => _showAddSupplierDialog(context),
          isFullWidth: isMobile,
        ),
      ],
    );
  }

  void _showAddSupplierDialog(BuildContext context) {
    final supplierController = TextEditingController();
    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width < 600 ? width * 0.9 : 400.0;

    Get.dialog(
      Dialog(
        child: Container(
          width: dialogWidth,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agregar Proveedor',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: supplierController,
                label: 'Nombre del proveedor',
                hint: 'Ej: Mercado Central',
                textCapitalization: TextCapitalization.words,
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final supplier = supplierController.text.trim();
                      if (supplier.isNotEmpty) {
                        controller.addAlternativeSupplier(supplier);
                        Get.back();
                      }
                    },
                    child: const Text('Agregar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuppliersChips extends GetView<IngredientFormController> {
  const _SuppliersChips();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.alternativeSuppliers.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'No hay proveedores alternativos agregados',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        );
      }

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.alternativeSuppliers.map((supplier) {
          return Chip(
            label: Text(supplier),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () => controller.removeAlternativeSupplier(supplier),
            backgroundColor: AppColors.info.withOpacity(0.1),
            deleteIconColor: AppColors.info,
          );
        }).toList(),
      );
    });
  }
}