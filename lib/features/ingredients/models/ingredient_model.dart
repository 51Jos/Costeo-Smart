import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientModel {
  final String id;
  final String name;
  final String code; // SKU único
  final String category;
  final String primarySupplier;
  final List<String> alternativeSuppliers;
  final double purchasePrice; // Precio por unidad base
  final String baseUnit; // kg, L, und, etc.
  final DateTime lastPriceUpdate;
  final String? imageUrl;
  
  // Rendimientos
  final double usablePercentage; // % aprovechable
  final double reusableWastePercentage; // % merma reutilizable
  final double totalWastePercentage; // % desperdicio total
  final String? wasteDescription; // Descripción de uso de mermas
  
  // Información adicional
  final String? description;
  final List<String> allergens;
  final String? season; // Temporada del producto
  final int shelfLifeDays; // Vida útil en días
  final Map<String, dynamic>? nutritionalInfo;
  
  // Datos de control
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  final bool isActive;
  
  // Historial de precios (se guardará en subcolección)
  final List<PriceHistory>? priceHistory;

  IngredientModel({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.primarySupplier,
    this.alternativeSuppliers = const [],
    required this.purchasePrice,
    required this.baseUnit,
    required this.lastPriceUpdate,
    this.imageUrl,
    required this.usablePercentage,
    this.reusableWastePercentage = 0.0,
    this.totalWastePercentage = 0.0,
    this.wasteDescription,
    this.description,
    this.allergens = const [],
    this.season,
    this.shelfLifeDays = 7,
    this.nutritionalInfo,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    this.isActive = true,
    this.priceHistory,
  });

  // Cálculos automáticos
  double get realCostPerUsableUnit {
    if (usablePercentage <= 0) return purchasePrice;
    return purchasePrice / (usablePercentage / 100);
  }

  double get wasteAmount {
    return totalWastePercentage + reusableWastePercentage;
  }

  double get netYieldPercentage {
    return 100 - wasteAmount;
  }

  bool get isPriceOutdated {
    return DateTime.now().difference(lastPriceUpdate).inDays > 30;
  }

  // Conversión a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'category': category,
      'primarySupplier': primarySupplier,
      'alternativeSuppliers': alternativeSuppliers,
      'purchasePrice': purchasePrice,
      'baseUnit': baseUnit,
      'lastPriceUpdate': Timestamp.fromDate(lastPriceUpdate),
      'imageUrl': imageUrl,
      'usablePercentage': usablePercentage,
      'reusableWastePercentage': reusableWastePercentage,
      'totalWastePercentage': totalWastePercentage,
      'wasteDescription': wasteDescription,
      'description': description,
      'allergens': allergens,
      'season': season,
      'shelfLifeDays': shelfLifeDays,
      'nutritionalInfo': nutritionalInfo,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'isActive': isActive,
    };
  }

  // Crear desde Map de Firebase
  factory IngredientModel.fromMap(Map<String, dynamic> map, String documentId) {
    return IngredientModel(
      id: documentId,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      category: map['category'] ?? '',
      primarySupplier: map['primarySupplier'] ?? '',
      alternativeSuppliers: List<String>.from(map['alternativeSuppliers'] ?? []),
      purchasePrice: (map['purchasePrice'] ?? 0.0).toDouble(),
      baseUnit: map['baseUnit'] ?? '',
      lastPriceUpdate: (map['lastPriceUpdate'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
      usablePercentage: (map['usablePercentage'] ?? 100.0).toDouble(),
      reusableWastePercentage: (map['reusableWastePercentage'] ?? 0.0).toDouble(),
      totalWastePercentage: (map['totalWastePercentage'] ?? 0.0).toDouble(),
      wasteDescription: map['wasteDescription'],
      description: map['description'],
      allergens: List<String>.from(map['allergens'] ?? []),
      season: map['season'],
      shelfLifeDays: map['shelfLifeDays'] ?? 7,
      nutritionalInfo: map['nutritionalInfo'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] ?? '',
      updatedBy: map['updatedBy'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }

  // Crear copia con cambios
  IngredientModel copyWith({
    String? id,
    String? name,
    String? code,
    String? category,
    String? primarySupplier,
    List<String>? alternativeSuppliers,
    double? purchasePrice,
    String? baseUnit,
    DateTime? lastPriceUpdate,
    String? imageUrl,
    double? usablePercentage,
    double? reusableWastePercentage,
    double? totalWastePercentage,
    String? wasteDescription,
    String? description,
    List<String>? allergens,
    String? season,
    int? shelfLifeDays,
    Map<String, dynamic>? nutritionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    bool? isActive,
    List<PriceHistory>? priceHistory,
  }) {
    return IngredientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      category: category ?? this.category,
      primarySupplier: primarySupplier ?? this.primarySupplier,
      alternativeSuppliers: alternativeSuppliers ?? this.alternativeSuppliers,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      baseUnit: baseUnit ?? this.baseUnit,
      lastPriceUpdate: lastPriceUpdate ?? this.lastPriceUpdate,
      imageUrl: imageUrl ?? this.imageUrl,
      usablePercentage: usablePercentage ?? this.usablePercentage,
      reusableWastePercentage: reusableWastePercentage ?? this.reusableWastePercentage,
      totalWastePercentage: totalWastePercentage ?? this.totalWastePercentage,
      wasteDescription: wasteDescription ?? this.wasteDescription,
      description: description ?? this.description,
      allergens: allergens ?? this.allergens,
      season: season ?? this.season,
      shelfLifeDays: shelfLifeDays ?? this.shelfLifeDays,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      isActive: isActive ?? this.isActive,
      priceHistory: priceHistory ?? this.priceHistory,
    );
  }

  @override
  String toString() {
    return 'IngredientModel(id: $id, name: $name, code: $code, purchasePrice: $purchasePrice, realCost: $realCostPerUsableUnit)';
  }
}

// Modelo para el historial de precios
class PriceHistory {
  final DateTime date;
  final double price;
  final String supplier;
  final String? notes;
  final String updatedBy;

  PriceHistory({
    required this.date,
    required this.price,
    required this.supplier,
    this.notes,
    required this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'price': price,
      'supplier': supplier,
      'notes': notes,
      'updatedBy': updatedBy,
    };
  }

  factory PriceHistory.fromMap(Map<String, dynamic> map) {
    return PriceHistory(
      date: (map['date'] as Timestamp).toDate(),
      price: (map['price'] ?? 0.0).toDouble(),
      supplier: map['supplier'] ?? '',
      notes: map['notes'],
      updatedBy: map['updatedBy'] ?? '',
    );
  }
}

// Enums y constantes para categorías y unidades
class IngredientCategories {
  static const List<String> categories = [
    'Verduras',
    'Frutas', 
    'Carnes Rojas',
    'Carnes Blancas',
    'Pescados y Mariscos',
    'Lácteos',
    'Granos y Cereales',
    'Especias y Condimentos',
    'Aceites y Grasas',
    'Bebidas',
    'Endulzantes',
    'Harinas',
    'Conservas',
    'Congelados',
    'Otros',
  ];
}

class IngredientUnits {
  static const List<String> weightUnits = ['g', 'kg'];
  static const List<String> volumeUnits = ['ml', 'L'];
  static const List<String> countUnits = ['und', 'doc', 'paq', 'caja'];
  
  static List<String> get allUnits => [...weightUnits, ...volumeUnits, ...countUnits];
}

class CommonAllergens {
  static const List<String> allergens = [
    'Gluten',
    'Lácteos',
    'Huevos',
    'Frutos secos',
    'Maní',
    'Soja',
    'Pescado',
    'Mariscos',
    'Sésamo',
    'Sulfitos',
  ];
}