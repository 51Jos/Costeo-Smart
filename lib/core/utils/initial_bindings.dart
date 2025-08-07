import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Importar servicios y controladores cuando estén creados
import '../../features/auth/services/auth_service.dart';
import '../../features/auth/controllers/auth_controller.dart';
// import '../../data/providers/api_provider.dart';
// import '../../data/providers/database_provider.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() async {
    // Shared Preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put(sharedPreferences, permanent: true);
    
    // Providers
    Get.put(ApiProvider(), permanent: true);
    Get.put(DatabaseProvider(), permanent: true);
    
    // Services
    Get.put(AuthService(), permanent: true);
    Get.put(IngredientService(), permanent: true);
    Get.put(RecipeService(), permanent: true);
    Get.put(SalesService(), permanent: true);
    Get.put(AnalyticsService(), permanent: true);
    
    // Controllers globales
    Get.put(AuthController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
  }
}

// Placeholder para los servicios y controladores (eliminar cuando se implementen)
class ApiProvider extends GetxService {
  Future<ApiProvider> init() async {
    // Inicializar API
    return this;
  }
}

class DatabaseProvider extends GetxService {
  Future<DatabaseProvider> init() async {
    // Inicializar base de datos
    return this;
  }
}


class IngredientService extends GetxService {
  Future<IngredientService> init() async {
    // Inicializar servicio de ingredientes
    return this;
  }
}

class RecipeService extends GetxService {
  Future<RecipeService> init() async {
    // Inicializar servicio de recetas
    return this;
  }
}

class SalesService extends GetxService {
  Future<SalesService> init() async {
    // Inicializar servicio de ventas
    return this;
  }
}

class AnalyticsService extends GetxService {
  Future<AnalyticsService> init() async {
    // Inicializar servicio de análisis
    return this;
  }
}


class ThemeController extends GetxController {
  final isDarkMode = false.obs;
  
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}

class NotificationController extends GetxController {
}