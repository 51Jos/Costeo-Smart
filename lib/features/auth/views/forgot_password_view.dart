import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../controllers/auth_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            PhosphorIcons.arrow_left,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: ResponsiveForgotPasswordLayout(
          controller: controller,
        ),
      ),
    );
  }
}

class ResponsiveForgotPasswordLayout extends StatelessWidget {
  final AuthController controller;

  const ResponsiveForgotPasswordLayout({
    super.key,
    required this.controller,
  });

  // Breakpoints
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
        child: _ForgotPasswordForm(
          controller: controller,
          illustrationSize: size.width * 0.5,
          maxFormWidth: double.infinity,
          spacing: 20,
          buttonHeight: 48,
          fontSize: 14,
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
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 32,
        ),
        child: SingleChildScrollView(
          child: _ForgotPasswordForm(
            controller: controller,
            illustrationSize: 220,
            maxFormWidth: 500,
            spacing: 24,
            buttonHeight: 52,
            fontSize: 15,
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
    
    if (size.width > 1200) {
      // Layout con panel lateral
      return Row(
        children: [
          // Panel izquierdo decorativo
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
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: AppColors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        PhosphorIcons.lock_simple_open,
                        size: 80,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'No te preocupes, esto le pasa a todos.\nTe ayudaremos a recuperar el acceso a tu cuenta.',
                        style: TextStyle(
                          fontSize: 18,
                          // ignore: deprecated_member_use
                          color: AppColors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Panel derecho con el formulario
          Expanded(
            flex: 4,
            child: Container(
              color: AppColors.background,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.all(40),
                  child: SingleChildScrollView(
                    child: _ForgotPasswordForm(
                      controller: controller,
                      illustrationSize: 0, // No mostrar ilustración
                      maxFormWidth: 450,
                      spacing: 28,
                      buttonHeight: 52,
                      fontSize: 16,
                      showIllustration: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Layout centrado para desktop pequeño
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(40),
          child: SingleChildScrollView(
            child: _ForgotPasswordForm(
              controller: controller,
              illustrationSize: 200,
              maxFormWidth: 500,
              spacing: 28,
              buttonHeight: 52,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
  }
}

// Formulario reutilizable
class _ForgotPasswordForm extends StatelessWidget {
  final AuthController controller;
  final double illustrationSize;
  final double maxFormWidth;
  final double spacing;
  final double buttonHeight;
  final double fontSize;
  final bool showIllustration;

  const _ForgotPasswordForm({
    required this.controller,
    required this.illustrationSize,
    required this.maxFormWidth,
    required this.spacing,
    required this.buttonHeight,
    required this.fontSize,
    this.showIllustration = true,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.forgotPasswordFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ilustración
          if (showIllustration && illustrationSize > 0) ...[
            _buildIllustration(illustrationSize),
            SizedBox(height: spacing * 2),
          ],
          
          // Título y descripción
          _buildHeader(fontSize),
          SizedBox(height: spacing * 1.5),
          
          // Campo de email
          _buildEmailField(fontSize),
          SizedBox(height: spacing * 1.5),
          
          // Botón de enviar
          _buildSendButton(buttonHeight, fontSize),
          SizedBox(height: spacing * 1.5),
          
          // Información adicional
          _buildInfoCard(fontSize),
          
          SizedBox(height: spacing * 2),
          
          // Link para volver al login
          _buildBackToLoginLink(fontSize),
        ],
      ),
    );
  }

  Widget _buildIllustration(double size) {
    return Center(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              PhosphorIcons.lock,
              size: size * 0.4,
              color: AppColors.primary,
            ),
            Positioned(
              bottom: size * 0.25,
              right: size * 0.25,
              child: Container(
                padding: EdgeInsets.all(size * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: AppColors.secondary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  PhosphorIcons.envelope,
                  size: size * 0.12,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double fontSize) {
    return Column(
      children: [
        Text(
          AppStrings.forgotPassword,
          style: TextStyle(
            fontSize: fontSize * 2,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'No te preocupes, te enviaremos un enlace para restablecer tu contraseña',
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField(double fontSize) {
    return CustomTextField(
      label: AppStrings.email,
      hint: 'Ingresa tu correo registrado',
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(
        PhosphorIcons.envelope,
        size: 20,
        color: AppColors.textSecondary,
      ),
      validator: Validators.email,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => controller.resetPassword(),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      style: TextStyle(fontSize: fontSize),
    );
  }

  Widget _buildSendButton(double height, double fontSize) {
    return Obx(() => SizedBox(
      height: height,
      child: CustomButton(
        text: 'Enviar enlace de recuperación',
        onPressed: controller.isLoading.value ? null : controller.resetPassword,
        isLoading: controller.isLoading.value,
        type: ButtonType.primary,
        size: ButtonSize.large,
        isFullWidth: true,
        icon: PhosphorIcons.paper_plane_tilt,
      ),
    ));
  }

  Widget _buildInfoCard(double fontSize) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // ignore: deprecated_member_use
          color: AppColors.info.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            PhosphorIcons.info,
            size: 20,
            color: AppColors.info,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importante',
                  style: TextStyle(
                    fontSize: fontSize,
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Revisa tu bandeja de entrada y la carpeta de spam. El enlace expirará en 24 horas.',
                  style: TextStyle(
                    fontSize: fontSize * 0.85,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToLoginLink(double fontSize) {
    return Center(
      child: TextButton.icon(
        onPressed: () => Get.back(),
        icon: const Icon(
          PhosphorIcons.arrow_left,
          size: 18,
        ),
        label: Text(
          'Volver al inicio de sesión',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}