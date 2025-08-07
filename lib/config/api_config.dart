import 'environment.dart';

class ApiConfig {
  ApiConfig._();
  
  // Base URL
  static String get baseUrl => EnvironmentConfig.apiUrl;
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-App-Version': '1.0.0',
    'X-Platform': 'flutter',
  };
}

// Endpoints
class Endpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String profile = '/auth/profile';
  static const String updateProfile = '/auth/profile/update';

  // Ingredients
  static const String ingredients = '/ingredients';
  static const String ingredientDetail = '/ingredients/{id}';
  static const String createIngredient = '/ingredients/create';
  static const String updateIngredient = '/ingredients/{id}/update';
  static const String deleteIngredient = '/ingredients/{id}/delete';
  static const String ingredientCategories = '/ingredients/categories';

  // Bases & Sauces
  static const String basesSauces = '/bases-sauces';
  static const String baseSauceDetail = '/bases-sauces/{id}';
  static const String createBaseSauce = '/bases-sauces/create';
  static const String updateBaseSauce = '/bases-sauces/{id}/update';
  static const String deleteBaseSauce = '/bases-sauces/{id}/delete';

  // Recipes
  static const String recipes = '/recipes';
  static const String recipeDetail = '/recipes/{id}';
  static const String createRecipe = '/recipes/create';
  static const String updateRecipe = '/recipes/{id}/update';
  static const String deleteRecipe = '/recipes/{id}/delete';
  static const String recipeCategories = '/recipes/categories';

  // Operating Costs
  static const String operatingCosts = '/operating-costs';
  static const String updateOperatingCosts = '/operating-costs/update';
  static const String operatingCostsHistory = '/operating-costs/history';

  // Sales
  static const String sales = '/sales';
  static const String createSale = '/sales/create';
  static const String dailySales = '/sales/daily';
  static const String salesHistory = '/sales/history';
  static const String salesReport = '/sales/report';

  // Analytics
  static const String dashboard = '/analytics/dashboard';
  static const String salesAnalytics = '/analytics/sales';
  static const String profitAnalytics = '/analytics/profit';
  static const String productAnalytics = '/analytics/products';
  static const String customerAnalytics = '/analytics/customers';

  // Promotions
  static const String promotions = '/promotions';
  static const String promotionDetail = '/promotions/{id}';
  static const String createPromotion = '/promotions/create';
  static const String updatePromotion = '/promotions/{id}/update';
  static const String deletePromotion = '/promotions/{id}/delete';
  static const String aiSuggestions = '/promotions/ai-suggestions';

  // Utils
  static const String uploadImage = '/upload/image';
  static const String notifications = '/notifications';
  static const String notificationSettings = '/notifications/settings';
}

// Firebase Collections
class Collections {
  static const String users = 'users';
  static const String ingredients = 'ingredients';
  static const String basesSauces = 'basesSauces';
  static const String recipes = 'recipes';
  static const String operatingCosts = 'operatingCosts';
  static const String sales = 'sales';
  static const String promotions = 'promotions';
  static const String analytics = 'analytics';
  static const String notifications = 'notifications';
  static const String categories = 'categories';
  static const String suppliers = 'suppliers';
}

// Storage Paths
class StoragePaths {
  static const String profileImages = 'users/{userId}/profile';
  static const String ingredientImages = 'ingredients/{ingredientId}';
  static const String recipeImages = 'recipes/{recipeId}';
  static const String promotionImages = 'promotions/{promotionId}';
}

// Error Codes
class ErrorCodes {
  static const String networkError = 'NETWORK_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String unauthorized = 'UNAUTHORIZED';
  static const String forbidden = 'FORBIDDEN';
  static const String notFound = 'NOT_FOUND';
  static const String badRequest = 'BAD_REQUEST';
  static const String timeout = 'TIMEOUT';
  static const String cancelled = 'CANCELLED';
  static const String unknown = 'UNKNOWN';
}