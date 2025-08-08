import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/ingredient_controller.dart';
import '../models/ingredient_model.dart';
import '../services/ingredient_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/routes/app_routes.dart';

class IngredientDetailView extends StatefulWidget {
  const IngredientDetailView({super.key});

  @override
  State<IngredientDetailView> createState() => _IngredientDetailViewState();
}

class _IngredientDetailViewState extends State<IngredientDetailView>
    with SingleTickerProviderStateMixin {
  
  final IngredientService _ingredientService = Get.find<IngredientService>();
  final IngredientController _controller = Get.find<IngredientController>();
  
  late TabController _tabController;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<IngredientModel?> ingredient = Rx<IngredientModel?>(null);
  final RxList<PriceHistory> priceHistory = <PriceHistory>[].obs;

  String? ingredientId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ingredientId = Get.arguments as String?;
    if (ingredientId != null) {
      _loadIngredientDetail();
      _loadPriceHistory();
    } else {
      hasError.value = true;
      errorMessage.value = 'ID de ingrediente no válido';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadIngredientDetail() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final result = await _ingredientService.getIngredientById(ingredientId!);
      if (result != null) {
        ingredient.value = result;
      } else {
        hasError.value = true;
        errorMessage.value = 'Ingrediente no encontrado';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadPriceHistory() {
    _ingredientService.getPriceHistoryStream(ingredientId!).listen(
      (history) => priceHistory.value = history,
      onError: (error) => print('Error cargando historial: $error'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (isLoading.value) {
          return const LoadingWidget(message: 'Cargando ingrediente...');
        }

        if (hasError.value) {
          return CustomErrorWidget(
            message: errorMessage.value,
            onRetry: _loadIngredientDetail,
          );
        }

        if (ingredient.value == null) {
          return const CustomErrorWidget(
            message: 'Ingrediente no encontrado',
          );
        }

        return _buildDetailContent();
      }),
    );
  }

  Widget _buildDetailContent() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        _buildSliverAppBar(),
      ],
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildTabBarView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      backgroundColor: AppColors.surface,
      actions: [
        IconButton(
          onPressed: () => _onEditPressed(),
          icon: const Icon(Icons.edit),
          tooltip: 'Editar',
        ),
        PopupMenuButton<String>(
          onSelected: _onMenuSelected,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20),
                  SizedBox(width: 12),
                  Text('Compartir'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(Icons.copy, size: 20),
                  SizedBox(width: 12),
                  Text('Duplicar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Eliminar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeader(),
      ),
    );
  }

  Widget _buildHeader() {
    final ing = ingredient.value!;
    
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        AppDimensions.safeAreaTop + kToolbarHeight,
        AppDimensions.screenPadding,
        AppDimensions.paddingL,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surface,
            AppColors.surface.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          // Imagen del ingrediente
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: AppColors.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              child: ing.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: ing.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildImagePlaceholder(),
                      errorWidget: (context, url, error) => _buildImagePlaceholder(),
                    )
                  : _buildImagePlaceholder(),
            ),
          ),
          
          SizedBox(height: AppDimensions.paddingL),
          
          // Información básica
          Text(
            ing.name,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: AppDimensions.paddingXS),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(ing.category, _getCategoryColor(ing.category)),
              SizedBox(width: AppDimensions.paddingS),
              _buildInfoChip('SKU: ${ing.code}', AppColors.grey600),
            ],
          ),
          
          SizedBox(height: AppDimensions.paddingM),
          
          // Precios destacados
          Row(
            children: [
              Expanded(
                child: _buildPriceCard(
                  'Precio Compra',
                  Formatters.currency(ing.purchasePrice),
                  '/${ing.baseUnit}',
                  AppColors.primary,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: _buildPriceCard(
                  'Costo Real',
                  Formatters.currency(ing.realCostPerUsableUnit),
                  '/${ing.baseUnit} útil',
                  AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Icon(
        Icons.restaurant,
        size: 60.sp,
        color: AppColors.grey500,
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: AppTypography.labelMedium.copyWith(color: color),
      ),
    );
  }

  Widget _buildPriceCard(String label, String value, String unit, Color color) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingXS),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTypography.titleLarge.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: unit,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        tabs: const [
          Tab(text: 'Información'),
          Tab(text: 'Rendimiento'),
          Tab(text: 'Historial'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildInformationTab(),
        _buildYieldTab(),
        _buildHistoryTab(),
      ],
    );
  }

  Widget _buildInformationTab() {
    final ing = ingredient.value!;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            'Información General',
            [
              _buildInfoRow('Nombre', ing.name),
              _buildInfoRow('Código SKU', ing.code),
              _buildInfoRow('Categoría', ing.category),
              _buildInfoRow('Unidad base', ing.baseUnit),
              if (ing.description != null) _buildInfoRow('Descripción', ing.description!),
            ],
          ),
          
          SizedBox(height: AppDimensions.paddingL),
          
          _buildSectionCard(
            'Proveedores',
            [
              _buildInfoRow('Principal', ing.primarySupplier),
              if (ing.alternativeSuppliers.isNotEmpty)
                _buildInfoRow(
                  'Alternativos',
                  ing.alternativeSuppliers.join(', '),
                ),
            ],
          ),
          
          SizedBox(height: AppDimensions.paddingL),
          
          _buildSectionCard(
            'Información Adicional',
            [
              _buildInfoRow('Vida útil', '${ing.shelfLifeDays} días'),
              if (ing.season != null) _buildInfoRow('Temporada', ing.season!),
              if (ing.allergens.isNotEmpty)
                _buildInfoRow('Alérgenos', ing.allergens.join(', ')),
              _buildInfoRow(
                'Última actualización',
                Formatters.dateTime(ing.updatedAt),
              ),
              _buildInfoRow(
                'Creado',
                Formatters.dateTime(ing.createdAt),
              ),
            ],
          ),
          
          if (ing.nutritionalInfo != null) ...[
            SizedBox(height: AppDimensions.paddingL),
            _buildNutritionalInfoCard(ing.nutritionalInfo!),
          ],
        ],
      ),
    );
  }

  Widget _buildYieldTab() {
    final ing = ingredient.value!;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gráfico de rendimiento
          _buildYieldChart(ing),
          
          SizedBox(height: AppDimensions.paddingL),
          
          // Calculadora de rendimiento
          _buildYieldCalculator(ing),
          
          SizedBox(height: AppDimensions.paddingL),
          
          // Detalles de rendimiento
          _buildSectionCard(
            'Detalles de Rendimiento',
            [
              _buildInfoRow(
                'Porcentaje aprovechable',
                '${ing.usablePercentage.toStringAsFixed(1)}%',
              ),
              _buildInfoRow(
                'Merma reutilizable',
                '${ing.reusableWastePercentage.toStringAsFixed(1)}%',
              ),
              _buildInfoRow(
                'Desperdicio total',
                '${ing.totalWastePercentage.toStringAsFixed(1)}%',
              ),
              _buildInfoRow(
                'Rendimiento neto',
                '${ing.netYieldPercentage.toStringAsFixed(1)}%',
              ),
              if (ing.wasteDescription != null)
                _buildInfoRow('Uso de mermas', ing.wasteDescription!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Obx(() {
      if (priceHistory.isEmpty) {
        return const EmptyStateWidget(
          title: 'Sin historial de precios',
          message: 'No hay cambios de precio registrados para este ingrediente',
          icon: Icons.history,
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(AppDimensions.screenPadding),
        itemCount: priceHistory.length,
        itemBuilder: (context, index) {
          final history = priceHistory[index];
          return _buildHistoryItem(history, index == 0);
        },
      );
    });
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYieldChart(IngredientModel ing) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución de Rendimiento',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),
            
            // Gráfico de barras simple
            Container(
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Row(
                children: [
                  // Parte aprovechable
                  Expanded(
                    flex: ing.usablePercentage.toInt(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppDimensions.radiusS),
                          bottomLeft: Radius.circular(AppDimensions.radiusS),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${ing.usablePercentage.toStringAsFixed(0)}%',
                          style: AppTypography.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Merma reutilizable
                  if (ing.reusableWastePercentage > 0)
                    Expanded(
                      flex: ing.reusableWastePercentage.toInt(),
                      child: Container(
                        color: AppColors.warning,
                        child: Center(
                          child: Text(
                            '${ing.reusableWastePercentage.toStringAsFixed(0)}%',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Desperdicio
                  if (ing.totalWastePercentage > 0)
                    Expanded(
                      flex: ing.totalWastePercentage.toInt(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(AppDimensions.radiusS),
                            bottomRight: Radius.circular(AppDimensions.radiusS),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${ing.totalWastePercentage.toStringAsFixed(0)}%',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            SizedBox(height: AppDimensions.paddingM),
            
            // Leyenda
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Aprovechable', AppColors.success),
                _buildLegendItem('Merma', AppColors.warning),
                _buildLegendItem('Desperdicio', AppColors.error),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppDimensions.paddingXS),
        Text(
          label,
          style: AppTypography.labelMedium,
        ),
      ],
    );
  }

  Widget _buildYieldCalculator(IngredientModel ing) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculadora de Rendimiento',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),
            
            Text(
              'Si compras 1 ${ing.baseUnit} a ${Formatters.currency(ing.purchasePrice)}:',
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppDimensions.paddingS),
            
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Obtienes ${(ing.usablePercentage / 100).toStringAsFixed(2)} ${ing.baseUnit} útiles',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Costo: ${Formatters.currency(ing.realCostPerUsableUnit)}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionalInfoCard(Map<String, dynamic> nutritionalInfo) {
    return _buildSectionCard(
      'Información Nutricional (por 100g)',
      nutritionalInfo.entries.map((entry) {
        return _buildInfoRow(
          _formatNutritionalKey(entry.key),
          entry.value.toString(),
        );
      }).toList(),
    );
  }

  Widget _buildHistoryItem(PriceHistory history, bool isLatest) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: isLatest ? AppColors.primary : AppColors.grey400,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.currency(history.price),
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isLatest ? AppColors.primary : null,
                          ),
                        ),
                        if (isLatest)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingS,
                              vertical: AppDimensions.paddingXXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                            ),
                            child: Text(
                              'Actual',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      '${history.supplier} • ${Formatters.dateTime(history.date)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (history.notes != null) ...[
                      SizedBox(height: AppDimensions.paddingXS),
                      Text(
                        history.notes!,
                        style: AppTypography.bodySmall.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos de utilidad
  Color _getCategoryColor(String category) {
    const categoryColors = {
      'Verduras': AppColors.success,
      'Frutas': AppColors.warning,
      'Carnes Rojas': AppColors.error,
      'Carnes Blancas': AppColors.secondary,
      'Pescados y Mariscos': AppColors.info,
      'Lácteos': AppColors.accent,
      'Granos y Cereales': AppColors.grey700,
      'Especias y Condimentos': AppColors.chartPurple,
      'Aceites y Grasas': AppColors.chartYellow,
      'Bebidas': AppColors.chartBlue,
      'Endulzantes': AppColors.chartPink,
      'Harinas': AppColors.grey600,
      'Conservas': AppColors.chartGreen,
      'Congelados': AppColors.info,
      'Otros': AppColors.grey500,
    };
    
    return categoryColors[category] ?? AppColors.grey500;
  }

  String _formatNutritionalKey(String key) {
    final formatted = {
      'calories': 'Calorías',
      'protein': 'Proteína (g)',
      'carbs': 'Carbohidratos (g)',
      'fat': 'Grasa (g)',
      'fiber': 'Fibra (g)',
      'sodium': 'Sodio (mg)',
    };
    return formatted[key] ?? key;
  }

  // Métodos de acción
  void _onEditPressed() {
    Get.toNamed(
      AppRoutes.ingredientEdit,
      arguments: ingredient.value,
    );
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'share':
        _shareIngredient();
        break;
      case 'duplicate':
        _duplicateIngredient();
        break;
      case 'delete':
        _deleteIngredient();
        break;
    }
  }

  void _shareIngredient() {
    // Implementar funcionalidad de compartir
    Get.snackbar(
      AppStrings.info,
      'Funcionalidad de compartir próximamente',
    );
  }

  void _duplicateIngredient() {
    // Implementar duplicación de ingrediente
    Get.snackbar(
      AppStrings.info,
      'Funcionalidad de duplicar próximamente',
    );
  }

  void _deleteIngredient() {
    final ing = ingredient.value!;
    _controller.deleteIngredient(ing.id, ing.name).then((success) {
      if (success) {
        Get.back(); // Regresar a la lista
      }
    });
  }
}