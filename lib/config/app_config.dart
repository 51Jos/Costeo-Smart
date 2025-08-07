class AppConfig {
  AppConfig._();
  
  // App Info
  static const String appName = 'Costeo Smart';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String bundleId = 'com.tucompania.restaurantmanagement';
  
  // Company Info
  static const String companyName = 'Tu Compañía';
  static const String companyEmail = 'soporte@tucompania.com';
  static const String companyPhone = '+1234567890';
  static const String companyWebsite = 'https://tucompania.com';
  
  // Support
  static const String supportEmail = 'soporte@tucompania.com';
  static const String privacyPolicyUrl = 'https://tucompania.com/privacy';
  static const String termsOfServiceUrl = 'https://tucompania.com/terms';
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/tucompania';
  static const String instagramUrl = 'https://instagram.com/tucompania';
  static const String twitterUrl = 'https://twitter.com/tucompania';
  
  // Features Flags
  static const bool enableOnboarding = true;
  static const bool enableBiometrics = true;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  static const bool enableDarkMode = true;
  static const bool enableMultiLanguage = false;
  static const bool enableOfflineMode = true;
  static const bool enableAISuggestions = true;
  
  // Cache Configuration
  static const int cacheMaxAge = 7; // días
  static const int cacheMaxSize = 50; // MB
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Image Configuration
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const int imageQuality = 80;
  static const int thumbnailSize = 200;
  
  // Session Configuration
  static const int sessionTimeout = 30; // minutos
  static const bool rememberMe = true;
  
  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int maxInstructionsLength = 2000;
  
  // Business Rules
  static const double maxDiscountPercentage = 50.0;
  static const double minProductPrice = 0.01;
  static const double maxProductPrice = 99999.99;
  static const int maxIngredientsPerRecipe = 50;
  static const int maxPromotionsActive = 10;
  
  // Default Values
  static const String defaultCurrency = 'USD';
  static const String defaultLanguage = 'es';
  static const String defaultCountry = 'US';
  static const double defaultTaxRate = 0.16; // 16%
  static const double defaultProfitMargin = 0.30; // 30%
  
  // Units of Measurement
  static const List<String> weightUnits = ['g', 'kg', 'oz', 'lb'];
  static const List<String> volumeUnits = ['ml', 'L', 'cup', 'tsp', 'tbsp'];
  static const List<String> countUnits = ['und', 'doc', 'paq'];
  
  // Categories
  static const List<String> ingredientCategories = [
    'Verduras',
    'Frutas',
    'Carnes',
    'Lácteos',
    'Granos',
    'Especias',
    'Bebidas',
    'Otros',
  ];
  
  static const List<String> recipeCategories = [
    'Entradas',
    'Platos principales',
    'Postres',
    'Bebidas',
    'Salsas',
    'Guarniciones',
  ];
  
  // Analytics Events
  static const String eventLogin = 'login';
  static const String eventSignup = 'signup';
  static const String eventAddIngredient = 'add_ingredient';
  static const String eventAddRecipe = 'add_recipe';
  static const String eventAddSale = 'add_sale';
  static const String eventViewAnalytics = 'view_analytics';
  static const String eventCreatePromotion = 'create_promotion';
  
  // Notification Channels
  static const String channelGeneral = 'general';
  static const String channelSales = 'sales';
  static const String channelInventory = 'inventory';
  static const String channelPromotions = 'promotions';
  static const String channelReports = 'reports';
}