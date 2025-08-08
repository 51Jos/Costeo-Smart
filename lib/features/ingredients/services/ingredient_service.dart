import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/ingredient_model.dart';
import '../../../config/api_config.dart';
import '../../auth/controllers/auth_controller.dart';

class IngredientService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();

  // Referencia a la colección de ingredientes
  CollectionReference get _ingredientsCollection => 
      _firestore.collection(Collections.ingredients);

  // Stream para obtener ingredientes en tiempo real
  Stream<List<IngredientModel>> getIngredientsStream({
    String? category,
    String? searchTerm,
    bool activeOnly = true,
  }) {
    final currentUser = _authController.currentUser;
    if (currentUser == null) {
      throw Exception('Usuario no autenticado');
    }
    Query query = _ingredientsCollection
        .where('createdBy', isEqualTo: currentUser.id);

    if (activeOnly) {
      query = query.where('isActive', isEqualTo: true);
    }

    if (category != null && category.isNotEmpty && category != 'Todos') {
      query = query.where('category', isEqualTo: category);
    }

    return query
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      List<IngredientModel> ingredients = snapshot.docs
          .map((doc) => IngredientModel.fromMap(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Filtrar por término de búsqueda localmente
      if (searchTerm != null && searchTerm.isNotEmpty) {
        final term = searchTerm.toLowerCase();
        ingredients = ingredients.where((ingredient) =>
            ingredient.name.toLowerCase().contains(term) ||
            ingredient.code.toLowerCase().contains(term) ||
            ingredient.primarySupplier.toLowerCase().contains(term)).toList();
      }

      return ingredients;
    });
  }

  // Obtener ingrediente por ID
  Future<IngredientModel?> getIngredientById(String id) async {
    try {
      final doc = await _ingredientsCollection.doc(id).get();
      if (doc.exists) {
        return IngredientModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener el ingrediente: $e');
    }
  }

  // Crear nuevo ingrediente
  Future<String> createIngredient(IngredientModel ingredient) async {
    try {
      // Verificar que el código no esté duplicado
      if (await _isCodeDuplicated(ingredient.code)) {
        throw Exception('El código SKU ya existe');
      }

      final currentUser = _authController.currentUser;
      if (currentUser == null) {
        throw Exception('Usuario no autenticado');
      }

      final now = DateTime.now();
      final ingredientData = ingredient.copyWith(
        createdAt: now,
        updatedAt: now,
        createdBy: currentUser.id,
        updatedBy: currentUser.id,
      );

      final docRef = await _ingredientsCollection.add(ingredientData.toMap());
      
      // Crear entrada en historial de precios
      await _addPriceHistory(docRef.id, PriceHistory(
        date: now,
        price: ingredient.purchasePrice,
        supplier: ingredient.primarySupplier,
        notes: 'Precio inicial',
        updatedBy: currentUser.id,
      ));

      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear el ingrediente: $e');
    }
  }

  // Actualizar ingrediente existente
  Future<void> updateIngredient(IngredientModel ingredient) async {
    try {
      final currentUser = _authController.currentUser;
      if (currentUser == null) {
        throw Exception('Usuario no autenticado');
      }

      // Verificar que el código no esté duplicado en otro ingrediente
      if (await _isCodeDuplicated(ingredient.code, excludeId: ingredient.id)) {
        throw Exception('El código SKU ya existe en otro ingrediente');
      }

      // Obtener el ingrediente actual para comparar precios
      final currentIngredient = await getIngredientById(ingredient.id);
      
      final updatedData = ingredient.copyWith(
        updatedAt: DateTime.now(),
        updatedBy: currentUser.id,
      );

      await _ingredientsCollection.doc(ingredient.id).update(updatedData.toMap());

      // Si el precio cambió, agregar al historial
      if (currentIngredient != null && 
          currentIngredient.purchasePrice != ingredient.purchasePrice) {
        await _addPriceHistory(ingredient.id, PriceHistory(
          date: DateTime.now(),
          price: ingredient.purchasePrice,
          supplier: ingredient.primarySupplier,
          notes: 'Actualización de precio',
          updatedBy: currentUser.id,
        ));
      }
    } catch (e) {
      throw Exception('Error al actualizar el ingrediente: $e');
    }
  }

  // Eliminar ingrediente (soft delete)
  Future<void> deleteIngredient(String id) async {
    try {
      final currentUser = _authController.currentUser;
      if (currentUser == null) {
        throw Exception('Usuario no autenticado');
      }

      // Verificar si el ingrediente está siendo usado en recetas
      if (await _isIngredientUsedInRecipes(id)) {
        throw Exception(
          'No se puede eliminar. El ingrediente está siendo usado en recetas.');
      }

      await _ingredientsCollection.doc(id).update({
        'isActive': false,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'updatedBy': currentUser.id,
      });
    } catch (e) {
      throw Exception('Error al eliminar el ingrediente: $e');
    }
  }

  // Obtener historial de precios
  Stream<List<PriceHistory>> getPriceHistoryStream(String ingredientId) {
    return _ingredientsCollection
        .doc(ingredientId)
        .collection('priceHistory')
        .orderBy('date', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PriceHistory.fromMap(doc.data()))
            .toList());
  }

  // Obtener estadísticas generales
  Future<Map<String, dynamic>> getIngredientsStats() async {
    try {
      final currentUser = _authController.currentUser;
      if (currentUser == null) return {};

      final querySnapshot = await _ingredientsCollection
          .where('createdBy', isEqualTo: currentUser.id)
          .where('isActive', isEqualTo: true)
          .get();

      final ingredients = querySnapshot.docs
          .map((doc) => IngredientModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Calcular estadísticas
      final totalIngredients = ingredients.length;
      final totalValue = ingredients.fold<double>(
          0, (sum, ingredient) => sum + ingredient.purchasePrice);
      
      final outdatedPrices = ingredients
          .where((ingredient) => ingredient.isPriceOutdated)
          .length;

      final categoriesCount = <String, int>{};
      for (final ingredient in ingredients) {
        categoriesCount[ingredient.category] = 
            (categoriesCount[ingredient.category] ?? 0) + 1;
      }

      return {
        'totalIngredients': totalIngredients,
        'totalValue': totalValue,
        'averagePrice': totalIngredients > 0 ? totalValue / totalIngredients : 0,
        'outdatedPrices': outdatedPrices,
        'categoriesCount': categoriesCount,
        'lastUpdated': DateTime.now(),
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  // Buscar ingredientes por código de barras (futuro)
  Future<IngredientModel?> searchByBarcode(String barcode) async {
    try {
      final querySnapshot = await _ingredientsCollection
          .where('code', isEqualTo: barcode)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return IngredientModel.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error en búsqueda por código: $e');
    }
  }

  // Verificar si un código está duplicado
  Future<bool> _isCodeDuplicated(String code, {String? excludeId}) async {
    try {
      Query query = _ingredientsCollection
          .where('code', isEqualTo: code)
          .where('isActive', isEqualTo: true);

      final querySnapshot = await query.get();
      
      if (excludeId != null) {
        return querySnapshot.docs.any((doc) => doc.id != excludeId);
      }
      
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Verificar si el ingrediente está siendo usado en recetas
  Future<bool> _isIngredientUsedInRecipes(String ingredientId) async {
    try {
      // Esta funcionalidad se implementará cuando tengamos el módulo de recetas
      // Por ahora retorna false
      return false;
      
      /* Implementación futura:
      final querySnapshot = await _firestore
          .collection('recipes')
          .where('ingredients', arrayContains: ingredientId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();
      
      return querySnapshot.docs.isNotEmpty;
      */
    } catch (e) {
      return false;
    }
  }

  // Agregar entrada al historial de precios
  Future<void> _addPriceHistory(String ingredientId, PriceHistory priceHistory) async {
    try {
      await _ingredientsCollection
          .doc(ingredientId)
          .collection('priceHistory')
          .add(priceHistory.toMap());
    } catch (e) {
      // Log el error pero no fallar la operación principal
      print('Error al agregar historial de precios: $e');
    }
  }

  // Método para obtener sugerencias de ingredientes (autocompletado)
  Future<List<IngredientModel>> getSuggestions(String term) async {
    try {
      if (term.length < 2) return [];

      final currentUser = _authController.currentUser;
      if (currentUser == null) return [];

      final querySnapshot = await _ingredientsCollection
          .where('createdBy', isEqualTo: currentUser.id)
          .where('isActive', isEqualTo: true)
          .limit(10)
          .get();

      final ingredients = querySnapshot.docs
          .map((doc) => IngredientModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Filtrar localmente por el término de búsqueda
      final termLower = term.toLowerCase();
      return ingredients
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(termLower) ||
              ingredient.code.toLowerCase().contains(termLower))
          .take(5)
          .toList();
    } catch (e) {
      return [];
    }
  }
}