import 'package:costeosmart/core/routes/app_routes.dart';
import 'package:costeosmart/core/routes/route_generator.dart';
import 'package:costeosmart/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'core/utils/initial_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fijar orientación vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Estilo de sistema (barra de estado y navegación)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Correr la app con bindings
    runApp(
      ScreenUtilInit(
        designSize: kIsWeb ? const Size(1440, 900) : const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Costeo Smart',
            debugShowCheckedModeBanner: false,

            // 👇 Este es el binding inicial
            initialBinding: InitialBindings(),

            // Temas
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,

            // Escalado de texto
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0),
                ),
                child: widget!,
              );
            },

            // Rutas
            initialRoute: AppRoutes.splash,
            getPages: RouteGenerator.routes,

            // Configuración GetX
            defaultTransition: Transition.cupertino,
            transitionDuration: const Duration(milliseconds: 300),
            locale: const Locale('es', 'ES'),
            fallbackLocale: const Locale('en', 'US'),
            popGesture: true,
            enableLog: true,
          );
        },
      ),
    );
  } catch (e) {
    debugPrint('Error al inicializar la app: $e');
    runApp(const ErrorApp());
  }
}

// Pantalla si falla la inicialización
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Error al iniciar la app',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Reinicia la aplicación'),
            ],
          ),
        ),
      ),
    );
  }
}
