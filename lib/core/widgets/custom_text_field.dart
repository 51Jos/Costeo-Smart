import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final TextAlign textAlign;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final double? height;
  final bool dense;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.filled = true,
    this.fillColor,
    this.borderRadius,
    this.textAlign = TextAlign.start,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.height,
    this.dense = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Método para obtener tamaños responsivos basados en el contexto
  double _getResponsiveFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 14;
    if (width < 600) return 15;
    if (width < 900) return 16;
    return 16;
  }

  EdgeInsetsGeometry _getDefaultContentPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (widget.dense) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
    if (width < 600) {
      return const EdgeInsets.symmetric(horizontal: 14, vertical: 14);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }

  double _getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 20;
    return 22;
  }

  double _getBorderRadius() {
    return 12.0;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final responsiveFontSize = _getResponsiveFontSize(context);
    final defaultContentPadding = _getDefaultContentPadding(context);
    final iconSize = _getIconSize(context);
    final borderRadius = _getBorderRadius();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ?? TextStyle(
              fontSize: responsiveFontSize - 2,
              fontWeight: FontWeight.w500,
              color: hasError ? AppColors.error : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          height: widget.height,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: _obscureText,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            autovalidateMode: widget.autovalidateMode,
            autofocus: widget.autofocus,
            textCapitalization: widget.textCapitalization,
            textAlign: widget.textAlign,
            style: widget.style ?? TextStyle(
              fontSize: responsiveFontSize,
              color: widget.enabled ? AppColors.textPrimary : AppColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              isDense: widget.dense,
              hintText: widget.hint,
              hintStyle: widget.hintStyle ?? TextStyle(
                fontSize: responsiveFontSize,
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w400,
              ),
              errorText: widget.errorText,
              helperText: widget.helperText,
              helperStyle: TextStyle(
                fontSize: responsiveFontSize - 3,
                color: AppColors.textSecondary,
              ),
              errorStyle: TextStyle(
                fontSize: responsiveFontSize - 3,
                color: AppColors.error,
              ),
              filled: widget.filled,
              fillColor: widget.fillColor ?? (_hasFocus 
                // ignore: deprecated_member_use
                ? AppColors.primary.withOpacity(0.05) 
                : AppColors.grey50),
              contentPadding: widget.contentPadding ?? defaultContentPadding,
              prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 8,
                    ),
                    child: widget.prefixIcon,
                  )
                : null,
              suffixIcon: _buildSuffixIcon(iconSize),
              prefixIconConstraints: BoxConstraints(
                minWidth: iconSize + 20,
                minHeight: iconSize + 20,
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: iconSize + 20,
                minHeight: iconSize + 20,
              ),
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.grey300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.grey300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.error,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.grey200,
                ),
              ),
              counterText: '',
            ),
          ),
        ),
        if (widget.maxLength != null) ...[
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${widget.controller?.text.length ?? 0}/${widget.maxLength}',
              style: TextStyle(
                fontSize: responsiveFontSize - 4,
                color: hasError ? AppColors.error : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon(double iconSize) {
    if (widget.obscureText) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 8,
          left: 4,
        ),
        child: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            size: iconSize,
            color: AppColors.textSecondary,
          ),
          onPressed: widget.enabled ? _toggleObscureText : null,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: iconSize + 8,
            minHeight: iconSize + 8,
          ),
        ),
      );
    }
    
    if (widget.suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 12,
          left: 8,
        ),
        child: widget.suffixIcon,
      );
    }
    
    return null;
  }
}

// Clase de configuración responsiva opcional
class ResponsiveTextFieldConfig {
  static double getFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 14;
    if (width < 600) return 15;
    if (width < 900) return 16;
    return 16;
  }
  
  static EdgeInsets getPadding(BuildContext context, {bool dense = false}) {
    if (dense) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return const EdgeInsets.symmetric(horizontal: 14, vertical: 14);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }
  
  static double getHeight(BuildContext context, {bool dense = false}) {
    if (dense) return 40;
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 48;
    if (width < 900) return 52;
    return 56;
  }
}