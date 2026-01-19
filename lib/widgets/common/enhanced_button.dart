import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outline, text }

class EnhancedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double fontSize;
  final FontWeight fontWeight;

  const EnhancedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 12,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    Color? bgColor;
    Color? fgColor;
    Color? borderColor;

    switch (variant) {
      case ButtonVariant.primary:
        bgColor = backgroundColor ?? Colors.deepPurple;
        fgColor = foregroundColor ?? Colors.white;
        break;
      case ButtonVariant.secondary:
        bgColor = backgroundColor ?? Colors.deepPurple.withOpacity(0.1);
        fgColor = foregroundColor ?? Colors.deepPurple;
        break;
      case ButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = foregroundColor ?? Colors.deepPurple;
        borderColor = Colors.deepPurple;
        break;
      case ButtonVariant.text:
        bgColor = Colors.transparent;
        fgColor = foregroundColor ?? Colors.deepPurple;
        break;
    }

    if (!isEnabled) {
      bgColor = bgColor.withOpacity(0.5);
      fgColor = fgColor.withOpacity(0.5);
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: fgColor,
          ),
        ),
      ],
    );

    if (width != null || height != null) {
      content = SizedBox(
        width: width,
        height: height ?? 48,
        child: content,
      );
    }

    final finalBorderColor = borderColor;
    final button = Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: icon != null || isLoading ? 20 : 24,
                vertical: 14,
              ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: finalBorderColor != null
                ? Border.all(
                    color: isEnabled
                        ? finalBorderColor
                        : finalBorderColor.withOpacity(0.5),
                    width: 1.5,
                  )
                : null,
            boxShadow: variant == ButtonVariant.primary && isEnabled
                ? [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: content,
        ),
      ),
    );

    return button;
  }
}
