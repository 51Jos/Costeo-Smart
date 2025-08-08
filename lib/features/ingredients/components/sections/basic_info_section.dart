import 'package:costeosmart/features/ingredients/components/sections/base_section.dart';
import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_text_field.dart';

class BasicInfoSection extends GetView<IngredientFormController> {
  final bool isMobile;
  
  const BasicInfoSection({
    super.key, 
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      title: 'Información Básica',
      icon: Icons.info,
      children: [
        CustomTextField(
          controller: controller.nameController,
          label: 'Nombre del ingrediente *',
          hint: 'Ej: Tomate rojo',
          validator: controller.validateName,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        if (isMobile) ...[
          CustomTextField(
            controller: controller.codeController,
            label: 'Código SKU *',
            hint: 'Ej: TOM001',
            validator: controller.validateCode,
            textCapitalization: TextCapitalization.characters,
            maxLength: 20,
          ),
          const SizedBox(height: 16),
          _CategoryDropdown(),
          const SizedBox(height: 16),
          _UnitDropdown(),
        ] else ...[
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomTextField(
                  controller: controller.codeController,
                  label: 'Código SKU *',
                  hint: 'Ej: TOM001',
                  validator: controller.validateCode,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: _UnitDropdown()),
            ],
          ),
          const SizedBox(height: 16),
          _CategoryDropdown(),
        ],
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.descriptionController,
          label: 'Descripción',
          hint: 'Descripción opcional del ingrediente',
          maxLines: 2,
          maxLength: 200,
        ),
      ],
    );
  }
}

class _CategoryDropdown extends GetView<IngredientFormController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedCategory.value,
      decoration: const InputDecoration(
        labelText: 'Categoría *',
        prefixIcon: Icon(Icons.category, size: 20),
      ),
      items: IngredientCategories.categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) controller.selectedCategory.value = value;
      },
      validator: (value) => value == null ? 'Selecciona una categoría' : null,
    ));
  }
}

class _UnitDropdown extends GetView<IngredientFormController> {
  const _UnitDropdown();
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedUnit.value,
      decoration: const InputDecoration(
        labelText: 'Unidad *',
        prefixIcon: Icon(Icons.straighten, size: 20),
      ),
      items: IngredientUnits.allUnits.map((unit) {
        return DropdownMenuItem(
          value: unit,
          child: Text(unit),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) controller.selectedUnit.value = value;
      },
      validator: (value) => value == null ? 'Selecciona una unidad' : null,
    ));
  }
}