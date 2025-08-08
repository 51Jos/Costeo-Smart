import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/formatters.dart';
import 'base_section.dart';

class AdditionalInfoSection extends GetView<IngredientFormController> {
  final bool isMobile;
  
  const AdditionalInfoSection({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      title: 'Información Adicional',
      icon: Icons.more_horiz,
      children: [
        if (isMobile) ...[
          CustomTextField(
            controller: controller.shelfLifeController,
            label: 'Vida útil (días) *',
            hint: '7',
            validator: controller.validateShelfLife,
            keyboardType: TextInputType.number,
            inputFormatters: InputFormatters.onlyNumbers(),
          ),
          const SizedBox(height: 16),
          const _SeasonDropdown(),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: controller.shelfLifeController,
                  label: 'Vida útil (días) *',
                  hint: '7',
                  validator: controller.validateShelfLife,
                  keyboardType: TextInputType.number,
                  inputFormatters: InputFormatters.onlyNumbers(),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: _SeasonDropdown()),
            ],
          ),
        ],
      ],
    );
  }
}

class _SeasonDropdown extends GetView<IngredientFormController> {
  const _SeasonDropdown();

  @override
  Widget build(BuildContext context) {
    final seasons = ['', 'Primavera', 'Verano', 'Otoño', 'Invierno', 'Todo el año'];

    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedSeason.value,
      decoration: const InputDecoration(
        labelText: 'Temporada',
        prefixIcon: Icon(Icons.wb_sunny, size: 20),
      ),
      items: seasons.map((season) {
        return DropdownMenuItem(
          value: season,
          child: Text(season.isEmpty ? 'No especificar' : season),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) controller.selectedSeason.value = value;
      },
    ));
  }
}