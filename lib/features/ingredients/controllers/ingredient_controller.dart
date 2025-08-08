import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ingredient_model.dart';
import '../services/ingredient_service.dart';
import '../../../core/constants/app_strings.dart';

class IngredientController extends GetxController {
  
  final IngredientService _ingredientService = Get.find<IngredientService>();

  // Observables
  final RxList<IngredientModel> ingredients = <IngredientModel>[].obs;
  final RxList<IngredientModel> filteredIngredients = <IngredientModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Filtros y búsqueda
  final RxString selectedCategory = 'Todos'.obs;
  final RxString searchTerm = ''.obs;
  final RxString sortBy = 'name'.obs; // name, price, category, date
  final RxBool sortAscending = true.obs;
  
  // Estadísticas
  final RxMap<String, dynamic> stats = <String, dynamic>{}.obs;
  final RxBool isLoadingStats = false.obs;

  // Controladores de texto para formularios
  final TextEditingController searchController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    _initializeListeners();
    loadIngredients();
    loadStats();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Inicializar listeners
  void _initializeListeners() {
    // Listener para el stream de ingredientes
    ever(selectedCategory, (_) => _applyFilters());
    ever(searchTerm, (_) => _applyFilters());
    ever(sortBy, (_) => _sortIngredients());
    ever(sortAscending, (_) => _sortIngredients());
  }

  // Cargar ingredientes
  void loadIngredients() {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      _ingredientService.getIngredientsStream(
        category: selectedCategory.value == 'Todos' ? null : selectedCategory.value,
        searchTerm: searchTerm.value.isEmpty ? null : searchTerm.value,
      ).listen(
        (ingredientsList) {
          ingredients.value = ingredientsList;
          _applyFilters();
          isLoading.value = false;
        },
        onError: (error) {
          hasError.value = true;
          errorMessage.value = error.toString();
          isLoading.value = false;
        },
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  // Aplicar filtros
  void _applyFilters() {
    List<IngredientModel> filtered = List.from(ingredients);

    // Filtrar por categoría
    if (selectedCategory.value != 'Todos') {
      filtered = filtered
          .where((ingredient) => ingredient.category == selectedCategory.value)
          .toList();
    }

    // Filtrar por término de búsqueda
    if (searchTerm.value.isNotEmpty) {
      final term = searchTerm.value.toLowerCase();
      filtered = filtered.where((ingredient) =>
          ingredient.name.toLowerCase().contains(term) ||
          ingredient.code.toLowerCase().contains(term) ||
          ingredient.primarySupplier.toLowerCase().contains(term) ||
          ingredient.category.toLowerCase().contains(term)).toList();
    }

    filteredIngredients.value = filtered;
    _sortIngredients();
  }

  // Ordenar ingredientes
  void _sortIngredients() {
    filteredIngredients.sort((a, b) {
      int comparison = 0;
      
      switch (sortBy.value) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'price':
          comparison = a.purchasePrice.compareTo(b.purchasePrice);
          break;
        case 'realCost':
          comparison = a.realCostPerUsableUnit.compareTo(b.realCostPerUsableUnit);
          break;
        case 'category':
          comparison = a.category.compareTo(b.category);
          break;
        case 'date':
          comparison = a.updatedAt.compareTo(b.updatedAt);
          break;
        case 'supplier':
          comparison = a.primarySupplier.compareTo(b.primarySupplier);
          break;
      }
      
      return sortAscending.value ? comparison : -comparison;
    });
  }

  // Cambiar filtro de categoría
  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  // Actualizar término de búsqueda
  void updateSearchTerm(String term) {
    searchTerm.value = term;
  }

  // Cambiar ordenamiento
  void changeSorting(String newSortBy) {
    if (sortBy.value == newSortBy) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortBy.value = newSortBy;
      sortAscending.value = true;
    }
  }

  // Limpiar filtros
  void clearFilters() {
    selectedCategory.value = 'Todos';
    searchTerm.value = '';
    searchController.clear();
  }

  // Obtener ingrediente por ID
  Future<IngredientModel?> getIngredientById(String id) async {
    try {
      return await _ingredientService.getIngredientById(id);
    } catch (e) {
      _showError('Error al obtener el ingrediente: $e');
      return null;
    }
  }

  // Crear nuevo ingrediente
  Future<bool> createIngredient(IngredientModel ingredient) async {
    try {
      isLoading.value = true;
      await _ingredientService.createIngredient(ingredient);
      
      Get.snackbar(
        AppStrings.success,
        'Ingrediente creado exitosamente',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
      
      return true;
    } catch (e) {
      _showError('Error al crear el ingrediente: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Actualizar ingrediente
  Future<bool> updateIngredient(IngredientModel ingredient) async {
    try {
      isLoading.value = true;
      await _ingredientService.updateIngredient(ingredient);
      
      Get.snackbar(
        AppStrings.success,
        'Ingrediente actualizado exitosamente',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
      
      return true;
    } catch (e) {
      _showError('Error al actualizar el ingrediente: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Eliminar ingrediente
  Future<bool> deleteIngredient(String id, String name) async {
    try {
      // Confirmar eliminación
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de eliminar el ingrediente "$name"?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );

      if (confirmed != true) return false;

      isLoading.value = true;
      await _ingredientService.deleteIngredient(id);
      
      Get.snackbar(
        AppStrings.success,
        'Ingrediente eliminado exitosamente',
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
        icon: const Icon(Icons.info, color: Colors.orange),
      );
      
      return true;
    } catch (e) {
      _showError('Error al eliminar el ingrediente: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Cargar estadísticas
  Future<void> loadStats() async {
    try {
      isLoadingStats.value = true;
      final statsData = await _ingredientService.getIngredientsStats();
      stats.value = statsData;
    } catch (e) {
      print('Error al cargar estadísticas: $e');
    } finally {
      isLoadingStats.value = false;
    }
  }

  // Obtener sugerencias para autocompletado
  Future<List<IngredientModel>> getSuggestions(String term) async {
    try {
      return await _ingredientService.getSuggestions(term);
    } catch (e) {
      return [];
    }
  }

  // Buscar por código de barras
  Future<IngredientModel?> searchByBarcode(String barcode) async {
    try {
      isLoading.value = true;
      return await _ingredientService.searchByBarcode(barcode);
    } catch (e) {
      _showError('Error en búsqueda por código: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Validar código único
  Future<bool> isCodeUnique(String code, {String? excludeId}) async {
    try {
      final existingIngredient = ingredients.firstWhereOrNull(
        (ingredient) => 
          ingredient.code == code && 
          ingredient.id != excludeId &&
          ingredient.isActive,
      );
      return existingIngredient == null;
    } catch (e) {
      return true;
    }
  }

  // Calcular costo real por unidad utilizable
  double calculateRealCost(double purchasePrice, double usablePercentage) {
    if (usablePercentage <= 0) return purchasePrice;
    return purchasePrice / (usablePercentage / 100);
  }

  // Calcular rendimiento neto
  double calculateNetYield(double usablePercentage, double wastePercentage) {
    return usablePercentage - wastePercentage;
  }

  // Validar porcentajes de rendimiento
  bool validateYieldPercentages({
    required double usablePercentage,
    required double reusableWastePercentage,
    required double totalWastePercentage,
  }) {
    final total = usablePercentage + reusableWastePercentage + totalWastePercentage;
    return total <= 100;
  }

  // Obtener ingredientes por categoría
  List<IngredientModel> getIngredientsByCategory(String category) {
    return filteredIngredients
        .where((ingredient) => ingredient.category == category)
        .toList();
  }

  // Obtener ingredientes con precios desactualizados
  List<IngredientModel> getIngredientsWithOutdatedPrices() {
    return filteredIngredients
        .where((ingredient) => ingredient.isPriceOutdated)
        .toList();
  }

  // Obtener top ingredientes más caros
  List<IngredientModel> getTopExpensiveIngredients({int limit = 10}) {
    final sorted = List<IngredientModel>.from(filteredIngredients);
    sorted.sort((a, b) => b.realCostPerUsableUnit.compareTo(a.realCostPerUsableUnit));
    return sorted.take(limit).toList();
  }

  // Obtener categorías con conteos
  Map<String, int> getCategoriesWithCount() {
    final categoriesCount = <String, int>{};
    for (final ingredient in filteredIngredients) {
      categoriesCount[ingredient.category] = 
          (categoriesCount[ingredient.category] ?? 0) + 1;
    }
    return categoriesCount;
  }

  // Refrescar datos
  Future<void> refresh() async {
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 500)), // Para mostrar el indicador
      loadStats(),
    ]);
    loadIngredients();
  }

  // Exportar datos (preparación para funcionalidad futura)
  Future<void> exportIngredients() async {
    try {
      // Implementar exportación a CSV/Excel
      Get.snackbar(
        AppStrings.info,
        'Funcionalidad de exportación próximamente',
        backgroundColor: Colors.blue[100],
        colorText: Colors.blue[800],
        icon: const Icon(Icons.info, color: Colors.blue),
      );
    } catch (e) {
      _showError('Error al exportar: $e');
    }
  }

  // Mostrar error con snackbar
  void _showError(String message) {
    Get.snackbar(
      AppStrings.error,
      message,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
      icon: const Icon(Icons.error, color: Colors.red),
      duration: const Duration(seconds: 4),
    );
  }

  // Getters para estadísticas computadas
  int get totalIngredients => filteredIngredients.length;
  
  double get averagePrice {
    if (filteredIngredients.isEmpty) return 0;
    return filteredIngredients.fold<double>(
      0, (sum, ingredient) => sum + ingredient.purchasePrice) / filteredIngredients.length;
  }
  
  double get averageRealCost {
    if (filteredIngredients.isEmpty) return 0;
    return filteredIngredients.fold<double>(
      0, (sum, ingredient) => sum + ingredient.realCostPerUsableUnit) / filteredIngredients.length;
  }
  
  int get outdatedPricesCount {
    return filteredIngredients.where((ingredient) => ingredient.isPriceOutdated).length;
  }

  // Helpers para UI
  String getSortIconFor(String field) {
    if (sortBy.value != field) return '↕️';
    return sortAscending.value ? '↑' : '↓';
  }

  Color getCategoryColor(String category) {
    // Colores consistentes para categorías
    const categoryColors = {
      'Verduras': Colors.green,
      'Frutas': Colors.orange,
      'Carnes Rojas': Colors.red,
      'Carnes Blancas': Colors.pink,
      'Pescados y Mariscos': Colors.blue,
      'Lácteos': Colors.yellow,
      'Granos y Cereales': Colors.brown,
      'Especias y Condimentos': Colors.purple,
      'Aceites y Grasas': Colors.amber,
      'Bebidas': Colors.cyan,
      'Endulzantes': Colors.pink,
      'Harinas': Colors.grey,
      'Conservas': Colors.teal,
      'Congelados': Colors.lightBlue,
      'Otros': Colors.blueGrey,
    };
    
    return categoryColors[category] ?? Colors.grey;
  }

  // Debug helpers
  void debugPrintStats() {
    print('=== Ingredient Controller Stats ===');
    print('Total ingredients: $totalIngredients');
    print('Filtered ingredients: ${filteredIngredients.length}');
    print('Selected category: ${selectedCategory.value}');
    print('Search term: "${searchTerm.value}"');
    print('Sort by: ${sortBy.value} (${sortAscending.value ? 'ASC' : 'DESC'})');
    print('Loading: ${isLoading.value}');
    print('Has error: ${hasError.value}');
    if (hasError.value) print('Error: ${errorMessage.value}');
    print('================================');
  }
}