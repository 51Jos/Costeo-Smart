import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class BaseSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  
  const BaseSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}

// Clases de constantes
class IngredientCategories {
  static const List<String> categories = [
    'Verduras',
    'Frutas',
    'Carnes',
    'Lácteos',
    'Granos',
    'Especias',
    'Aceites',
    'Bebidas',
    'Otros',
  ];
}

class IngredientUnits {
  static const List<String> allUnits = [
    'kg',
    'g',
    'L',
    'ml',
    'und',
    'doc',
    'paq',
    'atado',
    'caja',
  ];
}

class CommonAllergens {
  static const List<String> allergens = [
    'Gluten',
    'Lácteos',
    'Huevos',
    'Pescado',
    'Mariscos',
    'Frutos secos',
    'Soja',
    'Apio',
    'Mostaza',
    'Sésamo',
    'Sulfitos',
    'Cacahuetes',
  ];
}