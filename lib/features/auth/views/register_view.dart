import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../controllers/auth_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveRegisterLayout(
          controller: controller,
        ),
      ),
    );
  }
}

class ResponsiveRegisterLayout extends StatelessWidget {
  final AuthController controller;

  const ResponsiveRegisterLayout({
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
          horizontal: size.width * 0.06,
          vertical: 24,
        ),
        child: _RegisterForm(
          controller: controller,
          logoSize: size.width * 0.20,
          maxFormWidth: double.infinity,
          spacing: 16,
          buttonHeight: 48,
          fontSize: 14,
          compact: true,
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
        constraints: const BoxConstraints(maxWidth: 550),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.08,
          vertical: 32,
        ),
        child: SingleChildScrollView(
          child: _RegisterForm(
            controller: controller,
            logoSize: 100,
            maxFormWidth: 550,
            spacing: 20,
            buttonHeight: 52,
            fontSize: 15,
            compact: false,
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
        // Panel izquierdo con información
        if (size.width > 1200)
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIcons.cooking_pot,
                        size: 100,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Únete a CosteoSmart',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'La plataforma más completa para gestionar\nlos costos de tu restaurante',
                        style: TextStyle(
                          fontSize: 18,
                          // ignore: deprecated_member_use
                          color: AppColors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      // Beneficios
                      _buildBenefit(
                        PhosphorIcons.chart_line,
                        'Control de costos en tiempo real',
                      ),
                      const SizedBox(height: 16),
                      _buildBenefit(
                        PhosphorIcons.calculator,
                        'Cálculo automático de precios',
                      ),
                      const SizedBox(height: 16),
                      _buildBenefit(
                        PhosphorIcons.package,
                        'Gestión inteligente de inventario',
                      ),
                    ],
                  ),
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
                  maxWidth: 500,
                  maxHeight: 900,
                ),
                padding: const EdgeInsets.all(40),
                child: SingleChildScrollView(
                  child: _RegisterForm(
                    controller: controller,
                    logoSize: size.width > 1200 ? 0 : 80,
                    maxFormWidth: 500,
                    spacing: 24,
                    buttonHeight: 52,
                    fontSize: 16,
                    showLogo: size.width <= 1200,
                    compact: false,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          // ignore: deprecated_member_use
          color: AppColors.white.withOpacity(0.9),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            // ignore: deprecated_member_use
            color: AppColors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

// Formulario reutilizable
class _RegisterForm extends StatelessWidget {
  final AuthController controller;
  final double logoSize;
  final double maxFormWidth;
  final double spacing;
  final double buttonHeight;
  final double fontSize;
  final bool showLogo;
  final bool compact;

  const _RegisterForm({
    required this.controller,
    required this.logoSize,
    required this.maxFormWidth,
    required this.spacing,
    required this.buttonHeight,
    required this.fontSize,
    this.showLogo = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.registerFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo
          if (showLogo && logoSize > 0) ...[
            _buildLogo(logoSize),
            SizedBox(height: spacing * 1.5),
          ],
          
          // Título
          _buildHeader(fontSize),
          SizedBox(height: spacing * 1.5),
          
          // Campos del formulario
          _buildNameField(fontSize),
          SizedBox(height: spacing * 0.8),
          
          _buildEmailField(fontSize),
          SizedBox(height: spacing * 0.8),
          
          if (!compact) ...[
            _buildPhoneField(fontSize),
            SizedBox(height: spacing * 0.8),
          ],
          
          _buildPasswordField(fontSize),
          SizedBox(height: spacing * 0.8),
          
          _buildConfirmPasswordField(fontSize),
          SizedBox(height: spacing),
          
          // Términos y condiciones
          _buildTermsCheckbox(fontSize),
          SizedBox(height: spacing * 1.2),
          
          // Botón de registro
          _buildRegisterButton(buttonHeight, fontSize),
          SizedBox(height: spacing * 1.2),
          
          // Divider
          _buildDivider(fontSize),
          SizedBox(height: spacing * 1.2),
          
          // Botón de Google
          _buildGoogleButton(buttonHeight * 0.9, fontSize),
          
          // Botón de Apple (solo iOS)
          if (GetPlatform.isIOS) ...[
            SizedBox(height: spacing * 0.6),
            _buildAppleButton(buttonHeight * 0.9, fontSize),
          ],
          
          SizedBox(height: spacing * 1.2),
          
          // Link de login
          _buildLoginLink(fontSize),
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
          AppStrings.createAccount,
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
          'Gestiona tu restaurante de manera eficiente',
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

  Widget _buildNameField(double fontSize) {
    return CustomTextField(
      label: AppStrings.name,
      hint: 'Ingresa tu nombre completo',
      controller: controller.nameController,
      prefixIcon: Icon(
        PhosphorIcons.user,
        size: 20,
        color: AppColors.textSecondary,
      ),
      validator: (value) => Validators.minLength(value, 2, 'Nombre'),
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      style: TextStyle(fontSize: fontSize),
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

  Widget _buildPhoneField(double fontSize) {
    return CustomTextField(
      label: '${AppStrings.phone} (opcional)',
      hint: '987654321',
      controller: controller.phoneController,
      keyboardType: TextInputType.phone,
      prefixIcon: Icon(
        PhosphorIcons.phone,
        size: 20,
        color: AppColors.textSecondary,
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return Validators.phone(value);
        }
        return null;
      },
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
      hint: 'Mínimo 6 caracteres',
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
      validator: Validators.password,
      textInputAction: TextInputAction.next,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      style: TextStyle(fontSize: fontSize),
    ));
  }

  Widget _buildConfirmPasswordField(double fontSize) {
    return Obx(() => CustomTextField(
      label: AppStrings.confirmPassword,
      hint: 'Repite tu contraseña',
      controller: controller.confirmPasswordController,
      obscureText: controller.obscureConfirmPassword.value,
      prefixIcon: Icon(
        PhosphorIcons.lock,
        size: 20,
        color: AppColors.textSecondary,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          controller.obscureConfirmPassword.value
              ? PhosphorIcons.eye_slash
              : PhosphorIcons.eye,
          size: 20,
          color: AppColors.textSecondary,
        ),
        onPressed: controller.toggleConfirmPasswordVisibility,
      ),
      validator: (value) => Validators.confirmPassword(
        value,
        controller.passwordController.text,
      ),
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => controller.register(),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      style: TextStyle(fontSize: fontSize),
    ));
  }

  Widget _buildTermsCheckbox(double fontSize) {
    return Obx(() => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: controller.acceptTerms.value,
            onChanged: (value) => controller.acceptTerms.value = value ?? false,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: fontSize * 0.85,
                color: AppColors.textSecondary,
              ),
              children: [
                const TextSpan(text: 'Acepto los '),
                TextSpan(
                  text: 'Términos y Condiciones',
                  style: TextStyle(
                    fontSize: fontSize * 0.85,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    // ignore: deprecated_member_use
                    decorationColor: AppColors.primary.withOpacity(0.3),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed('/terms-of-service'),
                ),
                const TextSpan(text: ' y la '),
                TextSpan(
                  text: 'Política de Privacidad',
                  style: TextStyle(
                    fontSize: fontSize * 0.85,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    // ignore: deprecated_member_use
                    decorationColor: AppColors.primary.withOpacity(0.3),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed('/privacy-policy'),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildRegisterButton(double height, double fontSize) {
    return Obx(() => SizedBox(
      height: height,
      child: CustomButton(
        text: AppStrings.register,
        onPressed: controller.isLoading.value ? null : controller.register,
        isLoading: controller.isLoading.value,
        type: ButtonType.primary,
        size: ButtonSize.large,
        isFullWidth: true,
        icon: PhosphorIcons.arrow_right,
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
          size: 20,
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
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildAppleButton(double height, double fontSize) {
    return SizedBox(
      height: height,
      child: OutlinedButton.icon(
        onPressed: () {
          // Implementar Apple Sign In
        },
        icon: Icon(
          PhosphorIcons.apple_logo,
          size: 20,
          color: AppColors.black,
        ),
        label: Text(
          'Continuar con Apple',
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
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(double fontSize) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          color: AppColors.textSecondary,
        ),
        children: [
          TextSpan(text: AppStrings.alreadyHaveAccount),
          const TextSpan(text: ' '),
          TextSpan(
            text: AppStrings.login,
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              // ignore: deprecated_member_use
              decorationColor: AppColors.primary.withOpacity(0.3),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = controller.goToLogin,
          ),
        ],
      ),
    );
  }
}