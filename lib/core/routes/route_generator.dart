import 'package:costeosmart/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
// Importar las vistas cuando estén creadas
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/register_view.dart';
import '../../features/auth/views/forgot_password_view.dart';
// import '../../features/home/views/main_view.dart';
import '../../features/ingredients/views/ingredients_list_view.dart';
import '../../features/ingredients/views/ingredient_detail_view.dart';
import '../../features/ingredients/views/ingredient_create_view.dart';
import '../../features/ingredients/views/ingredient_edit_view.dart';
// import '../../features/bases_sauces/views/bases_sauces_list_view.dart';
// import '../../features/bases_sauces/views/base_sauce_detail_view.dart';
// import '../../features/bases_sauces/views/base_sauce_create_view.dart';
// import '../../features/recipes/views/recipes_list_view.dart';
// import '../../features/recipes/views/recipe_detail_view.dart';
// import '../../features/recipes/views/recipe_create_view.dart';
// import '../../features/operating_costs/views/operating_costs_view.dart';
// import '../../features/sales/views/sales_input_view.dart';
// import '../../features/sales/views/sales_history_view.dart';
// import '../../features/analytics/views/dashboard_view.dart';
// import '../../features/analytics/views/reports_view.dart';
// import '../../features/promotions/views/promotions_view.dart';
// import '../../features/profile/views/profile_view.dart';
// import '../../features/settings/views/settings_view.dart';
// import '../../features/notifications/views/notifications_view.dart';
// import '../../features/help/views/help_view.dart';
// import '../../features/about/views/about_view.dart';

class RouteGenerator {
  RouteGenerator._();
  
  static final List<GetPage> routes = [
    // Splash & Onboarding
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      transition: Transition.fade,
    ),
    
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      transition: Transition.rightToLeft,
    ),
    
    // Auth Routes
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      transition: Transition.downToUp,
    ),
    
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      transition: Transition.rightToLeft,
    ),
    
    // Main Navigation
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      transition: Transition.fade,
    ),
    
    // Ingredients Routes
    GetPage(
      name: AppRoutes.ingredientsList,
      page: () => const IngredientsListView(),
      binding: IngredientBinding(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.ingredientDetail,
      page: () => const IngredientDetailView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.ingredientCreate,
      page: () => const IngredientCreateView(),
      transition: Transition.downToUp,
    ),
    
    GetPage(
      name: AppRoutes.ingredientEdit,
      page: () => const IngredientEditView(),
      transition: Transition.rightToLeft,
    ),
    
    // Bases & Sauces Routes
    GetPage(
      name: AppRoutes.basesSaucesList,
      page: () => const BasesSaucesListView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.baseSauceDetail,
      page: () => const BaseSauceDetailView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.baseSauceCreate,
      page: () => const BaseSauceCreateView(),
      transition: Transition.downToUp,
    ),
    
    // Recipes Routes
    GetPage(
      name: AppRoutes.recipesList,
      page: () => const RecipesListView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.recipeDetail,
      page: () => const RecipeDetailView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.recipeCreate,
      page: () => const RecipeCreateView(),
      transition: Transition.downToUp,
    ),
    
    // Operating Costs Routes
    GetPage(
      name: AppRoutes.operatingCosts,
      page: () => const OperatingCostsView(),
      transition: Transition.rightToLeft,
    ),
    
    // Sales Routes
    GetPage(
      name: AppRoutes.salesInput,
      page: () => const SalesInputView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.salesHistory,
      page: () => const SalesHistoryView(),
      transition: Transition.rightToLeft,
    ),
    
    // Analytics Routes
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      transition: Transition.fade,
    ),
    
    GetPage(
      name: AppRoutes.reports,
      page: () => const ReportsView(),
      transition: Transition.rightToLeft,
    ),
    
    // Promotions Routes
    GetPage(
      name: AppRoutes.promotions,
      page: () => const PromotionsView(),
      transition: Transition.rightToLeft,
    ),
    
    // Settings & Profile
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      transition: Transition.rightToLeft,
    ),
    
    // Utility Routes
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpView(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutView(),
      transition: Transition.rightToLeft,
    ),
  ];
  
  // Middleware para autenticación
  static List<GetMiddleware> authMiddleware = [
    AuthMiddleware(),
  ];
  
  // Rutas que requieren autenticación
  static List<String> authRequiredRoutes = [
    AppRoutes.main,
    AppRoutes.home,
    AppRoutes.profile,
    AppRoutes.settings,
    AppRoutes.ingredientsList,
    AppRoutes.ingredientDetail,
    AppRoutes.ingredientCreate,
    AppRoutes.ingredientEdit,
    AppRoutes.basesSaucesList,
    AppRoutes.baseSauceDetail,
    AppRoutes.baseSauceCreate,
    AppRoutes.recipesList,
    AppRoutes.recipeDetail,
    AppRoutes.recipeCreate,
    AppRoutes.operatingCosts,
    AppRoutes.salesInput,
    AppRoutes.salesHistory,
    AppRoutes.dashboard,
    AppRoutes.reports,
    AppRoutes.promotions,
  ];
}

// Middleware de autenticación
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Aquí se implementará la lógica de autenticación
    // Por ahora retorna null para permitir navegación
    
    // Ejemplo de implementación:
    // final authController = Get.find<AuthController>();
    // if (!authController.isAuthenticated.value && 
    //     RouteGenerator.authRequiredRoutes.contains(route)) {
    //   return const RouteSettings(name: AppRoutes.login);
    // }
    
    return null;
  }
}

// ==============================================
// VISTAS TEMPORALES - ELIMINAR CUANDO SE CREEN LAS REALES
// ==============================================


class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Onboarding'),
      ),
    );
  }
}



class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Main - Bottom Navigation'),
            SizedBox(height: 20), // Espacio entre el texto y el botón
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.ingredientsList); // Redirige a /ingredients/list
              },
              child: const Text('Ir a Lista de Ingredientes'),
            ),
          ],
        ),
      ),
    );
  }
}

class BasesSaucesListView extends StatelessWidget {
  const BasesSaucesListView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bases & Sauces List'),
      ),
    );
  }
}

class BaseSauceDetailView extends StatelessWidget {
  const BaseSauceDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Base/Sauce Detail'),
      ),
    );
  }
}

class BaseSauceCreateView extends StatelessWidget {
  const BaseSauceCreateView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Create Base/Sauce'),
      ),
    );
  }
}

class RecipesListView extends StatelessWidget {
  const RecipesListView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Recipes List'),
      ),
    );
  }
}

class RecipeDetailView extends StatelessWidget {
  const RecipeDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Recipe Detail'),
      ),
    );
  }
}

class RecipeCreateView extends StatelessWidget {
  const RecipeCreateView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Create Recipe'),
      ),
    );
  }
}

class OperatingCostsView extends StatelessWidget {
  const OperatingCostsView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Operating Costs'),
      ),
    );
  }
}

class SalesInputView extends StatelessWidget {
  const SalesInputView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sales Input'),
      ),
    );
  }
}

class SalesHistoryView extends StatelessWidget {
  const SalesHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sales History'),
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Reports'),
      ),
    );
  }
}

class PromotionsView extends StatelessWidget {
  const PromotionsView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Promotions'),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Settings'),
      ),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Notifications'),
      ),
    );
  }
}

class HelpView extends StatelessWidget {
  const HelpView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Help'),
      ),
    );
  }
}

class AboutView extends StatelessWidget {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('About'),
      ),
    );
  }
}