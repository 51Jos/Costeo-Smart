import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/ingredient_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/custom_text_field.dart';

class IngredientSearchBar extends StatelessWidget {
  final IngredientController controller;
  final Function(String)? onChanged;
  final VoidCallback? onClear;

  const IngredientSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: CustomTextField(
        controller: controller.searchController,
        hint: 'Buscar ingredientes...',
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.textSecondary,
          size: 20.sp,
        ),
        suffixIcon: Obx(() {
          return controller.searchTerm.value.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.searchController.clear();
                    controller.updateSearchTerm('');
                    onClear?.call();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                )
              : const SizedBox.shrink();
        }),
        onChanged: (value) {
          controller.updateSearchTerm(value);
          onChanged?.call(value);
        },
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
