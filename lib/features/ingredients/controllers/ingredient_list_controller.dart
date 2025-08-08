// lib/features/ingredients/controllers/ingredient_list_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ingredient_model.dart';
import '../services/ingredient_service.dart';
import '../../../core/utils/formatters.dart';

class IngredientListController extends GetxController {
  final IngredientService _service = Get.find<IngredientService>();
  
  // Controladores
  final searchController = TextEditingController();
  
  // Estados observables
  final RxList<IngredientModel> ingredients = <IngredientModel>[].obs;
  final RxList<IngredientModel> filteredIngredients = <IngredientModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Filtros y búsqueda
  final RxString searchTerm = ''.obs;
  final RxString selectedCategory = 'Todos'.obs;
  final RxString currentSort = 'name'.obs;
  final RxBool isAscending = true.obs;
  
  // Vista
  final RxBool isGridView = false.obs;
  
  // Categorías disponibles
  final RxList<String> categories = [
    'Todos',
    'Verduras',
    'Frutas',
    'Carnes',
    'Lácteos',
    'Granos',
    'Especias',
    'Aceites',
    'Bebidas',
    'Otros',
  ].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadIngredients();
    
    // Escuchar cambios en filtros
    ever(searchTerm, (_) => applyFilters());
    ever(selectedCategory, (_) => applyFilters());
    ever(currentSort, (_) => applySort());
    ever(isAscending, (_) => applySort());
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  // Cargar ingredientes (con datos mockeados por ahora)
  Future<void> loadIngredients() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // Datos mockeados
      ingredients.value = _getMockedIngredients();
      applyFilters();
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Aplicar filtros
  void applyFilters() {
    var filtered = ingredients.toList();
    
    // Filtro por búsqueda
    if (searchTerm.value.isNotEmpty) {
      final search = searchTerm.value.toLowerCase();
      filtered = filtered.where((ingredient) {
        return ingredient.name.toLowerCase().contains(search) ||
               ingredient.code.toLowerCase().contains(search) ||
               ingredient.category.toLowerCase().contains(search) ||
               ingredient.primarySupplier.toLowerCase().contains(search);
      }).toList();
    }
    
    // Filtro por categoría
    if (selectedCategory.value != 'Todos') {
      filtered = filtered.where((ingredient) {
        return ingredient.category == selectedCategory.value;
      }).toList();
    }
    
    filteredIngredients.value = filtered;
    applySort();
  }
  
  // Aplicar ordenamiento
  void applySort() {
    final sorted = List<IngredientModel>.from(filteredIngredients);
    
    switch (currentSort.value) {
      case 'name':
        sorted.sort((a, b) => isAscending.value 
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name));
        break;
      case 'price':
        sorted.sort((a, b) => isAscending.value
          ? a.purchasePrice.compareTo(b.purchasePrice)
          : b.purchasePrice.compareTo(a.purchasePrice));
        break;
      case 'category':
        sorted.sort((a, b) => isAscending.value
          ? a.category.compareTo(b.category)
          : b.category.compareTo(a.category));
        break;
      case 'updated':
        sorted.sort((a, b) => isAscending.value
          ? a.updatedAt.compareTo(b.updatedAt)
          : b.updatedAt.compareTo(a.updatedAt));
        break;
    }
    
    filteredIngredients.value = sorted;
  }
  
  // Actualizar término de búsqueda
  void updateSearchTerm(String term) {
    searchTerm.value = term;
  }
  
  // Limpiar búsqueda
  void clearSearch() {
    searchController.clear();
    searchTerm.value = '';
  }
  
  // Seleccionar categoría
  void selectCategory(String category) {
    selectedCategory.value = category;
  }
  
  // Cambiar ordenamiento
  void changeSorting(String sortBy) {
    if (currentSort.value == sortBy) {
      isAscending.value = !isAscending.value;
    } else {
      currentSort.value = sortBy;
      isAscending.value = true;
    }
  }
  
  // Toggle vista grid/lista
  void toggleViewMode() {
    isGridView.value = !isGridView.value;
  }
  
  // Refrescar lista
  Future<void> refresh() async {
    await loadIngredients();
  }
  
  // Eliminar ingrediente
  Future<void> deleteIngredient(String id) async {
    try {
      // Aquí iría la llamada al servicio
      ingredients.removeWhere((i) => i.id == id);
      applyFilters();
      
      Get.snackbar(
        '¡Éxito!',
        'Ingrediente eliminado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo eliminar el ingrediente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        margin: const EdgeInsets.all(16),
      );
    }
  }
  
  // Exportar ingredientes
  Future<void> exportIngredients() async {
    Get.snackbar(
      'Exportar',
      'Función de exportación en desarrollo',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
  
  // Limpiar todos los filtros
  void clearAllFilters() {
    clearSearch();
    selectedCategory.value = 'Todos';
    currentSort.value = 'name';
    isAscending.value = true;
  }
  
  // Getters calculados
  bool get hasActiveFilters => 
    searchTerm.value.isNotEmpty || selectedCategory.value != 'Todos';
  
  String get currentSortLabel {
    switch (currentSort.value) {
      case 'name': return 'Nombre';
      case 'price': return 'Precio';
      case 'category': return 'Categoría';
      case 'updated': return 'Actualización';
      default: return 'Ordenar';
    }
  }
  
  String get totalValue {
    final total = ingredients.fold<double>(
      0, 
      (sum, item) => sum + item.purchasePrice
    );
    return Formatters.currency(total);
  }
  
  int get lowStockCount => 3; // Mockeado
  int get outOfStockCount => 1; // Mockeado
  
  // Datos mockeados para desarrollo
  List<IngredientModel> _getMockedIngredients() {
    return [
      IngredientModel(
        id: '1',
        name: 'Tomate Rojo',
        code: 'TOM001',
        category: 'Verduras',
        primarySupplier: 'Mercado Central',
        alternativeSuppliers: ['Supermercado La Colonia', 'Verduras Express'],
        purchasePrice: 2.50,
        baseUnit: 'kg',
        lastPriceUpdate: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: null,
        usablePercentage: 85.0,
        reusableWastePercentage: 10.0,
        totalWastePercentage: 5.0,
        wasteDescription: 'Cáscaras para compost, tallos para caldo',
        description: 'Tomate rojo maduro de primera calidad',
        allergens: [],
        season: 'Todo el año',
        shelfLifeDays: 7,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
      IngredientModel(
        id: '2',
        name: 'Cebolla Blanca',
        code: 'CEB001',
        category: 'Verduras',
        primarySupplier: 'Verduras Express',
        alternativeSuppliers: ['Mercado Central'],
        purchasePrice: 1.80,
        baseUnit: 'kg',
        lastPriceUpdate: DateTime.now().subtract(const Duration(days: 1)),
        imageUrl: null,
        usablePercentage: 90.0,
        reusableWastePercentage: 8.0,
        totalWastePercentage: 2.0,
        wasteDescription: 'Cáscaras para caldo',
        description: 'Cebolla blanca fresca',
        allergens: [],
        season: 'Todo el año',
        shelfLifeDays: 14,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
      IngredientModel(
        id: '3',
        name: 'Pechuga de Pollo',
        code: 'POL001',
        category: 'Carnes',
        primarySupplier: 'Carnicería Don José',
        alternativeSuppliers: ['Pollos San Fernando', 'Carnes Premium'],
        purchasePrice: 8.50,
        baseUnit: 'kg',
        lastPriceUpdate: DateTime.now(),
        imageUrl: null,
        usablePercentage: 95.0,
        reusableWastePercentage: 3.0,
        totalWastePercentage: 2.0,
        wasteDescription: 'Huesos para caldo',
        description: 'Pechuga de pollo sin piel, primera calidad',
        allergens: [],
        season: null,
        shelfLifeDays: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
      IngredientModel(
        id: '4',
        name: 'Aceite de Oliva Extra Virgen',
        code: 'ACE001',
        category: 'Aceites',
        primarySupplier: 'Importadora Mediterránea',
        alternativeSuppliers: ['Supermercado Gourmet'],
        purchasePrice: 12.00,
        baseUnit: 'L',
        lastPriceUpdate: DateTime.now().subtract(const Duration(days: 5)),
        imageUrl: null,
        usablePercentage: 100.0,
        reusableWastePercentage: 0.0,
        totalWastePercentage: 0.0,
        wasteDescription: null,
        description: 'Aceite de oliva extra virgen importado',
        allergens: [],
        season: null,
        shelfLifeDays: 365,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
      IngredientModel(
        id: '5',
        name: 'Queso Mozzarella',
        code: 'QUE001',
        category: 'Lácteos',
        primarySupplier: 'Lácteos La Vaquita',
        alternativeSuppliers: ['Quesos Artesanales', 'Supermercado La Colonia'],
        purchasePrice: 15.00,
        baseUnit: 'kg',
        lastPriceUpdate: DateTime.now().subtract(const Duration(days: 3)),
        imageUrl: null,
        usablePercentage: 98.0,
        reusableWastePercentage: 0.0,
        totalWastePercentage: 2.0,
        wasteDescription: null,
        description: 'Queso mozzarella fresco',
        allergens: ['Lácteos'],
        season: null,
        shelfLifeDays: 10,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
      IngredientModel(
        id: '6',
        name: 'Harina de Trigo',
        code: 'HAR001',
        category: 'Granos',
        primarySupplier: 'Molinos del Norte',
        alternativeSuppliers: ['Supermercado La Colonia'],
        purchasePrice: 1.20,
        baseUnit: 'kg',
        lastPriceUpdate: DateTime.now().subtract(const Duration(days: 7)),
        imageUrl: null,
        usablePercentage: 100.0,
        reusableWastePercentage: 0.0,
        totalWastePercentage: 0.0,
        wasteDescription: null,
        description: 'Harina de trigo todo uso',
        allergens: ['Gluten'],
        season: null,
        shelfLifeDays: 180,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
      IngredientModel(
        id: '7',
        name: 'Ajo',
        code: 'AJO001',
        category: 'Verduras',
        primarySupplier: 'Mercado Central',
        alternativeSuppliers: ['Verduras Express'],
        purchasePrice: 4.00,
        baseUnit: 'kg',
        lastPriceUpdate: DateTime.now().subtract(const Duration(days: 4)),
        imageUrl: null,
        usablePercentage: 88.0,
        reusableWastePercentage: 10.0,
        totalWastePercentage: 2.0,
        wasteDescription: 'Cáscaras para compost',
        description: 'Ajo fresco nacional',
        allergens: [],
        season: 'Todo el año',
        shelfLifeDays: 30,
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
      IngredientModel(
        id: '8',
        name: 'Limón',
        code: 'LIM001',
        category: 'Frutas',
        primarySupplier: 'Frutas Tropicales',
        alternativeSuppliers: ['Mercado Central'],
        purchasePrice: 3.50,
        baseUnit: 'kg',
        lastPriceUpdate: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: null,
        usablePercentage: 45.0,
        reusableWastePercentage: 50.0,
        totalWastePercentage: 5.0,
        wasteDescription: 'Cáscaras para rallar, semillas para plantar',
        description: 'Limón verde fresco',
        allergens: [],
        season: 'Todo el año',
        shelfLifeDays: 14,
        createdAt: DateTime.now().subtract(const Duration(days: 22)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
      IngredientModel(
        id: '9',
        name: 'Sal Marina',
        code: 'SAL001',
        category: 'Especias',
        primarySupplier: 'Especias del Mundo',
        alternativeSuppliers: [],
        purchasePrice: 0.80,
        baseUnit: 'kg',
        lastPriceUpdate: DateTime.now().subtract(const Duration(days: 30)),
        imageUrl: null,
        usablePercentage: 100.0,
        reusableWastePercentage: 0.0,
        totalWastePercentage: 0.0,
        wasteDescription: null,
        description: 'Sal marina gruesa',
        allergens: [],
        season: null,
        shelfLifeDays: 999,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
      IngredientModel(
        id: '10',
        name: 'Leche Entera',
        code: 'LEC001',
        category: 'Lácteos',
        primarySupplier: 'Lácteos La Vaquita',
        alternativeSuppliers: ['Supermercado La Colonia'],
        purchasePrice: 1.50,
        baseUnit: 'L',
        lastPriceUpdate: DateTime.now().subtract(const Duration(days: 1)),
        imageUrl: null,
        usablePercentage: 100.0,
        reusableWastePercentage: 0.0,
        totalWastePercentage: 0.0,
        wasteDescription: null,
        description: 'Leche entera pasteurizada',
        allergens: ['Lácteos'],
        season: null,
        shelfLifeDays: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        createdBy: 'user1',
        updatedBy: 'user1',
      ),
    ];
  }
}

// Componente del filtro (simplificado)
class IngredientFilterSheet extends StatelessWidget {
  final IngredientListController controller;
  
  const IngredientFilterSheet({
    super.key,
    required this.controller,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  controller.clearAllFilters();
                  Get.back();
                },
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Aquí irían más opciones de filtrado
          const Text('Más opciones de filtrado próximamente...'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Aplicar'),
            ),
          ),
        ],
      ),
    );
  }
}