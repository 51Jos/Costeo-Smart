import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/constants/app_strings.dart';

class RestaurantManagementApp extends StatelessWidget {
  const RestaurantManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          
          // Tema
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          
          // Configuración de texto
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
              child: widget!,
            );
          },
          
          // Rutas
          initialRoute: AppRoutes.splash,
          getPages: RouteGenerator.routes,
          
          // Configuración de Get
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
          
          // Localización (preparado para multi-idioma)
          locale: const Locale('es', 'ES'),
          fallbackLocale: const Locale('en', 'US'),
          
          // Prevención de retroceso no deseado
          popGesture: true,
          
          // Log de navegación (solo en debug)
          enableLog: true,
          
          // Configuración de snackbar global
          // SnackBarThemeData should be set inside ThemeData in AppTheme.lightTheme and AppTheme.darkTheme
        );
      },
    );
  }
}