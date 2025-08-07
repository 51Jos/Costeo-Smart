import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? passwordValidator;
  final VoidCallback? onSubmit;
  final bool showForgotPassword;
  final VoidCallback? onForgotPassword;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    this.emailValidator,
    this.passwordValidator,
    this.onSubmit,
    this.showForgotPassword = true,
    this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          _buildEmailField(),
          SizedBox(height: AppDimensions.paddingM),
          
          // Password field
          _buildPasswordField(),
          
          if (showForgotPassword) ...[
            SizedBox(height: AppDimensions.paddingS),
            _buildForgotPasswordLink(),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: emailValidator,
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
        hintText: 'correo@ejemplo.com',
        prefixIcon: Icon(
          PhosphorIcons.envelope,
          size: AppDimensions.iconS,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: obscurePassword,
      textInputAction: TextInputAction.done,
      validator: passwordValidator,
      onFieldSubmitted: (_) => onSubmit?.call(),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: '••••••••',
        prefixIcon: Icon(
          PhosphorIcons.lock,
          size: AppDimensions.iconS,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? PhosphorIcons.eye_slash : PhosphorIcons.eye,
            size: AppDimensions.iconS,
          ),
          onPressed: onTogglePassword,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onForgotPassword,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          '¿Olvidaste tu contraseña?',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}