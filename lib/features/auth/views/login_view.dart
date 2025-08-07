import 'package:costeosmart/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveLoginLayout(
          controller: controller,
        ),
      ),
    );
  }
}

class ResponsiveLoginLayout extends StatelessWidget {
  final AuthController controller;

  const ResponsiveLoginLayout({
    super.key,
    required this.controller,
  });

  // Breakpoints para diferentes dispositivos
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar el tipo de dispositivo
        if (constraints.maxWidth < mobileBreakpoint) {
          return _MobileLayout(controller: controller);
        } else if (constraints.maxWidth < tabletBreakpoint) {
          return _TabletLayout(controller: controller);
        } else {
          return _DesktopLayout(controller: controller);
        }
      },
    );
  }
}

// Layout para móviles
class _MobileLayout extends StatelessWidget {
  final AuthController controller;

  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.06, // 6% del ancho
          vertical: 24,
        ),
        child: _LoginForm(
          controller: controller,
          logoSize: size.width * 0.25, // 25% del ancho
          maxFormWidth: double.infinity,
          spacing: 20,
          buttonHeight: 48,
          fontSize: 14,
          inputHeight: 52,
        ),
      ),
    );
  }
}

// Layout para tablets
class _TabletLayout extends StatelessWidget {
  final AuthController controller;

  const _TabletLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.08,
          vertical: 32,
        ),
        child: SingleChildScrollView(
          child: _LoginForm(
            controller: controller,
            logoSize: 140,
            maxFormWidth: 500,
            spacing: 24,
            buttonHeight: 52,
            fontSize: 15,
            inputHeight: 56,
          ),
        ),
      ),
    );
  }
}

// Layout para desktop
class _DesktopLayout extends StatelessWidget {
  final AuthController controller;

  const _DesktopLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Row(
      children: [
        // Panel izquierdo con imagen/branding
        if (size.width > 1200)
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.cooking_pot,
                      size: 120,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'CosteoSmart',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sistema de Gestión de Costos',
                      style: TextStyle(
                        fontSize: 20,
                        // ignore: deprecated_member_use
                        color: AppColors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        
        // Panel derecho con el formulario
        Expanded(
          flex: size.width > 1200 ? 4 : 1,
          child: Container(
            color: AppColors.background,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 450,
                  maxHeight: 900,
                ),
                padding: const EdgeInsets.all(40),
                child: SingleChildScrollView(
                  child: _LoginForm(
                    controller: controller,
                    logoSize: size.width > 1200 ? 0 : 100, // No mostrar logo si hay panel izquierdo
                    maxFormWidth: 450,
                    spacing: 28,
                    buttonHeight: 52,
                    fontSize: 16,
                    inputHeight: 56,
                    showLogo: size.width <= 1200,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Formulario reutilizable
class _LoginForm extends StatelessWidget {
  final AuthController controller;
  final double logoSize;
  final double maxFormWidth;
  final double spacing;
  final double buttonHeight;
  final double fontSize;
  final double inputHeight;
  final bool showLogo;

  const _LoginForm({
    required this.controller,
    required this.logoSize,
    required this.maxFormWidth,
    required this.spacing,
    required this.buttonHeight,
    required this.fontSize,
    this.inputHeight = 52,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo (solo si showLogo es true y logoSize > 0)
          if (showLogo && logoSize > 0) ...[
            _buildLogo(logoSize),
            SizedBox(height: spacing * 2),
          ],
          
          // Título
          _buildHeader(fontSize),
          SizedBox(height: spacing * 1.5),
          
          // Campos del formulario
          _buildEmailField(fontSize),
          SizedBox(height: spacing * 0.8),
          
          _buildPasswordField(fontSize),
          SizedBox(height: spacing * 0.8),
          
          // Opciones
          _buildOptions(fontSize),
          SizedBox(height: spacing * 1.2),
          
          // Botón de login
          _buildLoginButton(buttonHeight, fontSize),
          SizedBox(height: spacing * 1.2),
          
          // Divider
          _buildDivider(fontSize),
          SizedBox(height: spacing * 1.2),
          
          // Botón de Google
          _buildGoogleButton(buttonHeight * 0.9, fontSize),
          SizedBox(height: spacing * 1.2),
          
          // Link de registro
          _buildRegisterLink(fontSize),
        ],
      ),
    );
  }

  Widget _buildLogo(double size) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: size,
        width: size,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(size * 0.2),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(
          PhosphorIcons.cooking_pot,
          size: size * 0.5,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildHeader(double fontSize) {
    return Column(
      children: [
        Text(
          AppStrings.welcomeBack,
          style: TextStyle(
            fontSize: fontSize * 2,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Ingresa a tu cuenta para continuar',
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField(double fontSize) {
    return CustomTextField(
      label: AppStrings.email,
      hint: 'correo@ejemplo.com',
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icon(
        PhosphorIcons.envelope,
        size: 20,
        color: AppColors.textSecondary,
      ),
      validator: Validators.email,
      textInputAction: TextInputAction.next,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      style: TextStyle(fontSize: fontSize),
    );
  }

  Widget _buildPasswordField(double fontSize) {
    return Obx(() => CustomTextField(
      label: AppStrings.password,
      hint: '••••••••',
      controller: controller.passwordController,
      obscureText: controller.obscurePassword.value,
      prefixIcon: Icon(
        PhosphorIcons.lock,
        size: 20,
        color: AppColors.textSecondary,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          controller.obscurePassword.value
              ? PhosphorIcons.eye_slash
              : PhosphorIcons.eye,
          size: 20,
          color: AppColors.textSecondary,
        ),
        onPressed: controller.togglePasswordVisibility,
      ),
      validator: Validators.required,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => controller.login(),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      style: TextStyle(fontSize: fontSize),
    ));
  }

  Widget _buildOptions(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => controller.rememberMe.toggle(),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: fontSize * 1.4,
                height: fontSize * 1.4,
                decoration: BoxDecoration(
                  color: controller.rememberMe.value 
                      ? AppColors.primary 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: controller.rememberMe.value 
                        ? AppColors.primary 
                        : AppColors.grey400,
                    width: 1.5,
                  ),
                ),
                child: controller.rememberMe.value
                    ? Icon(
                        PhosphorIcons.check,
                        size: fontSize,
                        color: AppColors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Recordarme',
                style: TextStyle(
                  fontSize: fontSize,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        )),
        
        GestureDetector(
          onTap: controller.goToForgotPassword,
          child: Text(
            AppStrings.forgotPassword,
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              // ignore: deprecated_member_use
              decorationColor: AppColors.primary.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(double height, double fontSize) {
    return Obx(() => SizedBox(
      height: height,
      child: CustomButton(
        text: AppStrings.login,
        onPressed: controller.isLoading.value ? null : controller.login,
        isLoading: controller.isLoading.value,
        type: ButtonType.primary,
        size: ButtonSize.large,
        isFullWidth: true,
        icon: PhosphorIcons.sign_in,
      ),
    ));
  }

  Widget _buildDivider(double fontSize) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.grey200,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppStrings.orContinueWith,
            style: TextStyle(
              fontSize: fontSize * 0.9,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.grey200,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton(double height, double fontSize) {
    return SizedBox(
      height: height,
      child: OutlinedButton.icon(
        onPressed: controller.loginWithGoogle,
        icon: Icon(
          PhosphorIcons.google_logo,
          size: fontSize * 1.4,
          color: AppColors.error,
        ),
        label: Text(
          'Continuar con Google',
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.grey200,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: height * 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink(double fontSize) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          color: AppColors.textSecondary,
        ),
        children: [
          TextSpan(text: AppStrings.dontHaveAccount),
          const TextSpan(text: ' '),
          TextSpan(
            text: AppStrings.register,
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              // ignore: deprecated_member_use
              decorationColor: AppColors.primary.withOpacity(0.3),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = controller.goToRegister,
          ),
        ],
      ),
    );
  }
}