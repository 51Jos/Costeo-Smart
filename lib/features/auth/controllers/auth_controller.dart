import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../../../core/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  // Controladores de texto para formularios
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  
  // Estados
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool rememberMe = false.obs;
  final RxBool acceptTerms = false.obs;
  
  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  
  // Getters
  bool get isAuthenticated => _authService.isAuthenticated.value;
  UserModel? get currentUser => _authService.currentUser.value;
  bool get isEmailVerified => currentUser?.isEmailVerified ?? false;
  
  @override
  void onInit() {
    super.onInit();
    // Escuchar cambios en el estado de autenticación
    ever(_authService.isAuthenticated, _handleAuthStateChange);
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
  
  // Manejar cambios en el estado de autenticación
  void _handleAuthStateChange(bool isAuthenticated) {
    if (isAuthenticated) {
      // Si está autenticado, ir a la pantalla principal
      Get.offAllNamed(AppRoutes.main);
    } else {
      // Si no está autenticado, ir al login
      Get.offAllNamed(AppRoutes.login);
    }
  }
  
  // Toggle visibilidad de contraseña
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
  
  // Registro de usuario
  Future<void> register() async {
    try {
      if (!registerFormKey.currentState!.validate()) {
        return;
      }
      
      if (!acceptTerms.value) {
        Get.snackbar(
          'Términos y Condiciones',
          'Debes aceptar los términos y condiciones para continuar',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return;
      }
      
      isLoading.value = true;
      
      final user = await _authService.registerWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
      );
      
      if (user != null) {
        // Limpiar formularios
        _clearControllers();
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          '¡Registro exitoso!',
          'Se ha enviado un email de verificación a ${user.email}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(16),
        );
        
        // Navegar a la pantalla principal
        Get.offAllNamed(AppRoutes.main);
      }
    } catch (e) {
      Get.snackbar(
        'Error en el registro',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Login de usuario
  Future<void> login() async {
    try {
      if (!loginFormKey.currentState!.validate()) {
        return;
      }
      
      isLoading.value = true;
      
      final user = await _authService.loginWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      if (user != null) {
        // Guardar preferencias si "Recordarme" está activo
        if (rememberMe.value) {
          // Implementar guardado de credenciales seguro
        }
        
        // Limpiar formularios
        _clearControllers();
        
        // Mostrar mensaje de bienvenida
        Get.snackbar(
          '¡Bienvenido!',
          'Has iniciado sesión como ${user.displayName}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error al iniciar sesión',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Login con Google
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      
      final user = await _authService.loginWithGoogle();
      
      if (user != null) {
        Get.snackbar(
          '¡Bienvenido!',
          'Has iniciado sesión con Google',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error con Google',
        'No se pudo iniciar sesión con Google',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Recuperar contraseña
  Future<void> resetPassword() async {
    try {
      if (!forgotPasswordFormKey.currentState!.validate()) {
        return;
      }
      
      isLoading.value = true;
      
      await _authService.resetPassword(emailController.text.trim());
      
      Get.snackbar(
        'Email enviado',
        'Se ha enviado un enlace de recuperación a ${emailController.text}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(16),
      );
      
      // Volver al login
      Get.back();
      emailController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Verificar email
  Future<void> checkEmailVerification() async {
    try {
      final isVerified = await _authService.checkEmailVerification();
      
      if (isVerified) {
        Get.snackbar(
          'Email verificado',
          'Tu email ha sido verificado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar(
          'Email no verificado',
          'Por favor, verifica tu email para continuar',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error checking email verification: $e');
        // ignore: avoid_print
    }
  }
  
  // Reenviar email de verificación
  Future<void> resendVerificationEmail() async {
    try {
      isLoading.value = true;
      
      await _authService.resendVerificationEmail();
      
      Get.snackbar(
        'Email enviado',
        'Se ha reenviado el email de verificación',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo enviar el email de verificación',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Cerrar sesión
  Future<void> logout() async {
    try {
      // Mostrar diálogo de confirmación
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      );
      
      if (confirm == true) {
        await _authService.logout();
        _clearControllers();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cerrar sesión',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
  
  // Limpiar controladores
  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    phoneController.clear();
    rememberMe.value = false;
    acceptTerms.value = false;
  }
  
  // Navegar a registro
  void goToRegister() {
    _clearControllers();
    Get.toNamed(AppRoutes.register);
  }
  
  // Navegar a login
  void goToLogin() {
    _clearControllers();
    Get.toNamed(AppRoutes.login);
  }
  
  // Navegar a recuperar contraseña
  void goToForgotPassword() {
    emailController.clear();
    Get.toNamed(AppRoutes.forgotPassword);
  }
}