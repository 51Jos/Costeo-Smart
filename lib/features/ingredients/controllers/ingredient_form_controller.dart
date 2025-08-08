// lib/features/ingredients/components/ingredient_form_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ingredient_model.dart';
import '../controllers/ingredient_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';

class IngredientFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controladores de texto
  late final TextEditingController nameController;
  late final TextEditingController codeController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController primarySupplierController;
  late final TextEditingController shelfLifeController;
  late final TextEditingController wasteDescriptionController;

  // Estados reactivos
  final RxString selectedCategory = 'Verduras'.obs;
  final RxString selectedUnit = 'kg'.obs;
  final RxString selectedSeason = ''.obs;
  final RxList<String> selectedAllergens = <String>[].obs;
  final RxList<String> alternativeSuppliers = <String>[].obs;

  // Rendimientos
  final RxDouble usablePercentage = 100.0.obs;
  final RxDouble reusableWastePercentage = 0.0.obs;
  final RxDouble totalWastePercentage = 0.0.obs;

  // Estados del formulario
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxString imageUrl = ''.obs;

  IngredientModel? originalIngredient;

  @override
  void onInit() {
    super.onInit();
    _initControllers();
    _checkForEditMode();
  }

  void _initControllers() {
    nameController = TextEditingController();
    codeController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    primarySupplierController = TextEditingController();
    shelfLifeController = TextEditingController();
    wasteDescriptionController = TextEditingController();
  }

  void _checkForEditMode() {
    final ingredient = Get.arguments as IngredientModel?;
    if (ingredient != null) {
      _loadIngredientForEdit(ingredient);
    }
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _loadIngredientForEdit(IngredientModel ingredient) {
    originalIngredient = ingredient;
    isEditing.value = true;

    // Cargar datos básicos
    nameController.text = ingredient.name;
    codeController.text = ingredient.code;
    descriptionController.text = ingredient.description ?? '';
    priceController.text = ingredient.purchasePrice.toString();
    primarySupplierController.text = ingredient.primarySupplier;
    shelfLifeController.text = ingredient.shelfLifeDays.toString();
    wasteDescriptionController.text = ingredient.wasteDescription ?? '';

    // Cargar estados reactivos
    selectedCategory.value = ingredient.category;
    selectedUnit.value = ingredient.baseUnit;
    selectedSeason.value = ingredient.season ?? '';
    selectedAllergens.value = List.from(ingredient.allergens);
    alternativeSuppliers.value = List.from(ingredient.alternativeSuppliers);
    imageUrl.value = ingredient.imageUrl ?? '';

    // Cargar rendimientos
    usablePercentage.value = ingredient.usablePercentage;
    reusableWastePercentage.value = ingredient.reusableWastePercentage;
    totalWastePercentage.value = ingredient.totalWastePercentage;
  }

  void _disposeControllers() {
    nameController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    primarySupplierController.dispose();
    shelfLifeController.dispose();
    wasteDescriptionController.dispose();
  }

  // Validadores
  String? validateName(String? value) {
    return Validators.required(value, 'Nombre');
  }

  String? validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Código SKU es obligatorio';
    }
    if (value.length < 3) {
      return 'Código debe tener al menos 3 caracteres';
    }
    return null;
  }

  String? validatePrice(String? value) {
    return Validators.positiveNumber(value);
  }

  String? validateShelfLife(String? value) {
    return Validators.number(value, min: 1, max: 365, allowDecimals: false);
  }

  // Getters calculados
  double get totalPercentage =>
      usablePercentage.value +
      reusableWastePercentage.value +
      totalWastePercentage.value;
      
  bool get isYieldValid => totalPercentage <= 100.01; // Pequeño margen para errores de redondeo
  
  double get realCostPerUnit {
    if (priceController.text.isEmpty || usablePercentage.value <= 0) {
      return 0.0;
    }
    final price = double.tryParse(priceController.text) ?? 0.0;
    return price / (usablePercentage.value / 100);
  }

  // Métodos de manipulación de datos
  void addAlternativeSupplier(String supplier) {
    if (supplier.isNotEmpty && !alternativeSuppliers.contains(supplier)) {
      alternativeSuppliers.add(supplier);
    }
  }

  void removeAlternativeSupplier(String supplier) {
    alternativeSuppliers.remove(supplier);
  }

  void toggleAllergen(String allergen) {
    if (selectedAllergens.contains(allergen)) {
      selectedAllergens.remove(allergen);
    } else {
      selectedAllergens.add(allergen);
    }
  }

  void updateYieldPercentage(String type, double value) {
    switch (type) {
      case 'usable':
        usablePercentage.value = value;
        break;
      case 'reusable':
        reusableWastePercentage.value = value;
        break;
      case 'waste':
        totalWastePercentage.value = value;
        break;
    }

    // Auto-ajustar si se excede el 100%
    if (totalPercentage > 100) {
      final excess = totalPercentage - 100;
      switch (type) {
        case 'usable':
          if (reusableWastePercentage.value > excess) {
            reusableWastePercentage.value -= excess;
          } else if (totalWastePercentage.value > excess) {
            totalWastePercentage.value -= excess;
          }
          break;
        case 'reusable':
          if (totalWastePercentage.value > excess) {
            totalWastePercentage.value -= excess;
          } else if (usablePercentage.value > excess) {
            usablePercentage.value -= excess;
          }
          break;
        case 'waste':
          if (reusableWastePercentage.value > excess) {
            reusableWastePercentage.value -= excess;
          } else if (usablePercentage.value > excess) {
            usablePercentage.value -= excess;
          }
          break;
      }
    }
  }

  // Método principal para guardar
  Future<void> saveIngredient() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      
      final ingredient = _buildIngredientModel();
      final success = await _saveToDatabase(ingredient);
      
      if (success) {
        _showSuccessMessage();
        Get.back(result: true);
      }
    } catch (e) {
      _showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        AppStrings.error,
        'Por favor corrige los errores en el formulario',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    if (!isYieldValid) {
      Get.snackbar(
        AppStrings.error,
        'La suma de los porcentajes no puede exceder 100%',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    return true;
  }

  IngredientModel _buildIngredientModel() {
    return IngredientModel(
      id: originalIngredient?.id ?? '',
      name: nameController.text.trim(),
      code: codeController.text.trim().toUpperCase(),
      category: selectedCategory.value,
      primarySupplier: primarySupplierController.text.trim(),
      alternativeSuppliers: alternativeSuppliers.toList(),
      purchasePrice: double.parse(priceController.text),
      baseUnit: selectedUnit.value,
      lastPriceUpdate: DateTime.now(),
      imageUrl: imageUrl.value.isEmpty ? null : imageUrl.value,
      usablePercentage: usablePercentage.value,
      reusableWastePercentage: reusableWastePercentage.value,
      totalWastePercentage: totalWastePercentage.value,
      wasteDescription: wasteDescriptionController.text.trim().isEmpty
          ? null
          : wasteDescriptionController.text.trim(),
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      allergens: selectedAllergens.toList(),
      season: selectedSeason.value.isEmpty ? null : selectedSeason.value,
      shelfLifeDays: int.parse(shelfLifeController.text),
      createdAt: originalIngredient?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: originalIngredient?.createdBy ?? 'current_user_id', // TODO: Obtener del AuthService
      updatedBy: 'current_user_id', // TODO: Obtener del AuthService
    );
  }

  Future<bool> _saveToDatabase(IngredientModel ingredient) async {
    final controller = Get.find<IngredientController>();
    
    if (isEditing.value) {
      return await controller.updateIngredient(ingredient);
    } else {
      return await controller.createIngredient(ingredient);
    }
  }

  void _showSuccessMessage() {
    Get.snackbar(
      '¡Éxito!',
      isEditing.value 
          ? 'Ingrediente actualizado correctamente'
          : 'Ingrediente creado correctamente',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  void _showErrorMessage(String error) {
    Get.snackbar(
      AppStrings.error,
      'Error al guardar: $error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error, color: Colors.red),
    );
  }

  // Método para verificar cambios sin guardar
  bool hasUnsavedChanges() {
    if (!isEditing.value) {
      // Para nuevo ingrediente, verificar si hay algún dato ingresado
      return nameController.text.isNotEmpty ||
             codeController.text.isNotEmpty ||
             priceController.text.isNotEmpty ||
             primarySupplierController.text.isNotEmpty ||
             descriptionController.text.isNotEmpty ||
             alternativeSuppliers.isNotEmpty ||
             selectedAllergens.isNotEmpty;
    } else {
      // Para edición, comparar con el original
      // TODO: Implementar comparación detallada con el modelo original
      return true;
    }
  }
}