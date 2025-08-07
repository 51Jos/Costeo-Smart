enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment _environment = Environment.development;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  static Environment get environment => _environment;
  
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;
  
  static String get environmentName {
    switch (_environment) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }
  
  // API URLs según el entorno
  static String get apiUrl {
    switch (_environment) {
      case Environment.development:
        return 'https://dev-api.turestaurante.com';
      case Environment.staging:
        return 'https://staging-api.turestaurante.com';
      case Environment.production:
        return 'https://api.turestaurante.com';
    }
  }
  
  // Configuración de Firebase según el entorno
  static String get firebaseProjectId {
    switch (_environment) {
      case Environment.development:
        return 'restaurant-dev';
      case Environment.staging:
        return 'restaurant-staging';
      case Environment.production:
        return 'restaurant-prod';
    }
  }
  
  // Otras configuraciones
  static bool get enableLogging => _environment != Environment.production;
  static bool get enableCrashlytics => _environment == Environment.production;
  static bool get enableAnalytics => _environment == Environment.production;
}