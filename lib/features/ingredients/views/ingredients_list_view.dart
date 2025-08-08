import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ingredient_controller.dart';
import '../components/ingredient_card.dart';
import '../components/ingredient_search_bar.dart';
import '../components/ingredient_filter.dart';
import '../models/ingredient_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/routes/app_routes.dart';

class IngredientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IngredientController>(() => IngredientController());
  }
}


class IngredientsListView extends GetView<IngredientController> {
  const IngredientsListView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1200;
    
    return AppBar(
      title: Text(
        'Ingredientes',
        style: TextStyle(
          fontSize: isMobile ? 20 : (isTablet ? 22 : 24),
        ),
      ),
      elevation: 0,
      backgroundColor: AppColors.surface,
      actions: [
        Obx(() => IconButton(
          icon: Icon(
            controller.isGridView.value ? Icons.list : Icons.grid_view,
            color: AppColors.textPrimary,
          ),
          onPressed: controller.toggleViewMode,
        )),
        
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
          onPressed: () => IngredientFiltersBottomSheet.show(context, controller),
        ),
        
        if (!isMobile)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 12),
                    Text('Actualizar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 12),
                    Text('Exportar'),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1200;
    final isDesktop = width >= 1200;
    
    // Padding responsivo
    final horizontalPadding = isMobile ? 16.0 : (isTablet ? 24.0 : 32.0);
    final verticalSpacing = isMobile ? 12.0 : 16.0;
    
    return Column(
      children: [
        SizedBox(height: verticalSpacing),
        
        // Barra de búsqueda - TU COMPONENTE
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: IngredientSearchBar(
            controller: controller,
            onChanged: (value) => controller.updateSearchTerm(value),
            onClear: () => controller.clearSearch(),
          ),
        ),
        
        SizedBox(height: verticalSpacing),
        
        // Filtro de categorías - TU COMPONENTE
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: IngredientCategoryFilter(
            controller: controller,
            onCategoryChanged: (category) => controller.changeCategory(category),
          ),
        ),
        
        // Barra de estadísticas - TU COMPONENTE (solo desktop)
        if (isDesktop)
          Obx(() {
            if (controller.showStats.value) {
              return Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: IngredientStatsBar(controller: controller),
              );
            }
            return const SizedBox.shrink();
          }),
        
        // Barra de ordenamiento y resultados
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalSpacing,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.grey200),
            ),
          ),
          child: Row(
            children: [
              Obx(() {
                final count = controller.filteredIngredients.length;
                final total = controller.ingredients.length;
                return Text(
                  count == total 
                      ? '$count ingrediente${count != 1 ? 's' : ''}'
                      : '$count de $total',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    color: AppColors.textSecondary,
                  ),
                );
              }),
              
              const Spacer(),
              
              // TU COMPONENTE de ordenamiento
              IngredientSortMenu(
                controller: controller,
                onSortChanged: (sortBy) => controller.changeSorting(sortBy),
              ),
            ],
          ),
        ),
        
        // Lista de ingredientes
        Expanded(
          child: _buildIngredientsList(context),
        ),
      ],
    );
  }

  Widget _buildIngredientsList(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1200;
    final padding = isMobile ? 16.0 : (isTablet ? 24.0 : 32.0);
    
    return Obx(() {
      if (controller.isLoading.value && controller.ingredients.isEmpty) {
        return const ShimmerListLoading(itemCount: 6, itemHeight: 120);
      }

      if (controller.hasError.value) {
        return CustomErrorWidget(
          message: controller.errorMessage.value,
          onRetry: controller.loadIngredients,
          isFullScreen: false,
        );
      }

      if (controller.filteredIngredients.isEmpty) {
        return _buildEmptyState(context);
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.primary,
        child: controller.isGridView.value 
            ? _buildGridView(context, padding)
            : _buildListView(context, padding),
      );
    });
  }

  Widget _buildListView(BuildContext context, double padding) {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: padding,
        right: padding,
        top: padding / 2,
        bottom: 100,
      ),
      itemCount: controller.filteredIngredients.length,
      itemBuilder: (context, index) {
        final ingredient = controller.filteredIngredients[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: IngredientCard(  // TU COMPONENTE
            ingredient: ingredient,
            onTap: () => _onIngredientTap(ingredient),
            onEdit: () => _onEditIngredient(ingredient),
            onDelete: () => _onDeleteIngredient(ingredient),
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, double padding) {
    final width = MediaQuery.of(context).size.width;
    
    // Columnas responsivas
    int crossAxisCount;
    if (width >= 1400) {
      crossAxisCount = 5;
    } else if (width >= 1200) {
      crossAxisCount = 4;
    } else if (width >= 900) {
      crossAxisCount = 3;
    } else if (width >= 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }
    
    return GridView.builder(
      padding: EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: controller.filteredIngredients.length,
      itemBuilder: (context, index) {
        final ingredient = controller.filteredIngredients[index];
        return IngredientCard(  // TU COMPONENTE
          ingredient: ingredient,
          onTap: () => _onIngredientTap(ingredient),
          onEdit: () => _onEditIngredient(ingredient),
          onDelete: () => _onDeleteIngredient(ingredient),
          isCompact: true,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Obx(() {
      final hasFilters = controller.selectedCategory.value != 'Todos' ||
                       controller.searchTerm.value.isNotEmpty;
      
      if (hasFilters) {
        return EmptyStateWidget(
          title: 'No se encontraron ingredientes',
          message: 'Intenta ajustar los filtros de búsqueda',
          icon: Icons.search_off,
          actionText: 'Limpiar filtros',
          onAction: controller.clearFilters,
        );
      }
      
      return EmptyStateWidget(
        title: 'No tienes ingredientes',
        message: 'Comienza agregando tu primer ingrediente',
        icon: Icons.restaurant,
        actionText: 'Agregar ingrediente',
        onAction: () => Get.toNamed(AppRoutes.ingredientCreate),
      );
    });
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    
    return FloatingActionButton.extended(
      onPressed: () {
        Get.toNamed(AppRoutes.ingredientCreate); // Redirige a /ingredient/create
      },
      label: Text(isMobile ? 'Agregar' : 'Agregar Ingrediente'),
      icon: const Icon(Icons.add),
      backgroundColor: AppColors.primary,
    );
  }

  void _onIngredientTap(IngredientModel ingredient) {
    Get.toNamed(AppRoutes.ingredientDetail, arguments: ingredient.id);
  }

  void _onEditIngredient(IngredientModel ingredient) {
    Get.toNamed(AppRoutes.ingredientEdit, arguments: ingredient);
  }

  void _onDeleteIngredient(IngredientModel ingredient) {
    controller.deleteIngredient(ingredient.id, ingredient.name);
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'refresh':
        controller.refresh();
        break;
      case 'export':
        controller.exportIngredients();
        break;
      case 'stats':
        controller.toggleStats();
        break;
    }
  }
}

// Extensiones al controlador
extension IngredientControllerViewExtensions on IngredientController {
  RxBool get isGridView => false.obs;
  RxBool get showStats => true.obs;

  void toggleViewMode() {
    isGridView.value = !isGridView.value;
  }

  void toggleStats() {
    showStats.value = !showStats.value;
  }

  void clearSearch() {
    searchController.clear();
    updateSearchTerm('');
  }
}