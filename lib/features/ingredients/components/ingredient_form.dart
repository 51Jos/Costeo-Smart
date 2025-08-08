// lib/features/ingredients/components/ingredient_form.dart
import 'package:costeosmart/features/ingredients/controllers/ingredient_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sections/basic_info_section.dart';
import 'sections/price_section.dart';
import 'sections/yield_section.dart';
import 'sections/suppliers_section.dart';
import 'sections/additional_info_section.dart';
import 'sections/allergens_section.dart';

// Helper para determinar el tipo de pantalla
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1200;
  
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < mobile;
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }
  
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= tablet;
  
  static double getPadding(BuildContext context) {
    if (isMobile(context)) return 16;
    if (isTablet(context)) return 24;
    return 32;
  }
  
  static double getMaxWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 800;
    return 1400;
  }
}

class IngredientForm extends GetView<IngredientFormController> {
  const IngredientForm({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveBreakpoints.getPadding(context)),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveBreakpoints.getMaxWidth(context),
                ),
                child: _buildResponsiveLayout(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    if (ResponsiveBreakpoints.isDesktop(context)) {
      return _DesktopLayout();
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return _TabletLayout();
    } else {
      return _MobileLayout();
    }
  }
}

// Layout para Desktop
class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const spacing = 24.0;
    
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  BasicInfoSection(isMobile: false),
                  const SizedBox(height: spacing),
                  PriceSection(isMobile: false),
                ],
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: Column(
                children: [
                  const YieldSection(),
                  const SizedBox(height: spacing),
                  AdditionalInfoSection(isMobile: false),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SuppliersSection(isMobile: false)),
            const SizedBox(width: spacing),
            const Expanded(child: AllergensSection()),
          ],
        ),
        const SizedBox(height: 100), // Espacio para botones flotantes
      ],
    );
  }
}

// Layout para Tablet
class _TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;
    
    return Column(
      children: [
        BasicInfoSection(isMobile: false),
        const SizedBox(height: spacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: PriceSection(isMobile: false)),
            const SizedBox(width: spacing),
            Expanded(child: AdditionalInfoSection(isMobile: false)),
          ],
        ),
        const SizedBox(height: spacing),
        const YieldSection(),
        const SizedBox(height: spacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SuppliersSection(isMobile: false)),
            const SizedBox(width: spacing),
            const Expanded(child: AllergensSection()),
          ],
        ),
        const SizedBox(height: 100), // Espacio para botones flotantes
      ],
    );
  }
}

// Layout para Mobile
class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const spacing = 16.0;
    
    return Column(
      children: [
        BasicInfoSection(isMobile: true),
        const SizedBox(height: spacing),
        PriceSection(isMobile: true),
        const SizedBox(height: spacing),
        const YieldSection(),
        const SizedBox(height: spacing),
        SuppliersSection(isMobile: true),
        const SizedBox(height: spacing),
        AdditionalInfoSection(isMobile: true),
        const SizedBox(height: spacing),
        const AllergensSection(),
        const SizedBox(height: 100), // Espacio para botones flotantes
      ],
    );
  }
}