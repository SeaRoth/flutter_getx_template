import 'package:flutter/material.dart';

/// Consistent button design system for the app
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final Color? customColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = _buildButton(context);

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildButton(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final textStyle = _getTextStyle(context);
    final buttonChild = _buildButtonChild(textStyle);

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
      case AppButtonType.secondary:
        return FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
      case AppButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final padding = _getPadding();
    final borderRadius = BorderRadius.circular(12);

    return ButtonStyle(
      padding: WidgetStateProperty.all(padding),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      backgroundColor:
          customColor != null ? WidgetStateProperty.all(customColor) : null,
      minimumSize: WidgetStateProperty.all(_getMinimumSize()),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) return 1;
        if (type == AppButtonType.primary) return 2;
        return 0;
      }),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    if (padding != null) return padding!;

    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  Size _getMinimumSize() {
    switch (size) {
      case AppButtonSize.small:
        return const Size(80, 36);
      case AppButtonSize.medium:
        return const Size(100, 44);
      case AppButtonSize.large:
        return const Size(120, 52);
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final baseStyle = switch (size) {
      AppButtonSize.small => Theme.of(context).textTheme.bodyMedium,
      AppButtonSize.medium => Theme.of(context).textTheme.bodyLarge,
      AppButtonSize.large => Theme.of(context).textTheme.titleMedium,
    };

    return baseStyle?.copyWith(
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(fontWeight: FontWeight.w600);
  }

  Widget _buildButtonChild(TextStyle textStyle) {
    if (isLoading) {
      return SizedBox(
        height: switch (size) {
          AppButtonSize.small => 16,
          AppButtonSize.medium => 20,
          AppButtonSize.large => 24,
        },
        width: switch (size) {
          AppButtonSize.small => 16,
          AppButtonSize.medium => 20,
          AppButtonSize.large => 24,
        },
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }
}

enum AppButtonType {
  primary, // Filled with primary color
  secondary, // Tonal/surface color
  outlined, // Outlined border
  text, // Text only
}

enum AppButtonSize {
  small,
  medium,
  large,
}

// Legacy support - gradually replace with AppButton
Widget returnButtonCenter({
  required BuildContext context,
  required String buttonText,
  required Function onClick,
  Color? tintColor,
  Color? textColor,
}) {
  return AppButton(
    text: buttonText,
    onPressed: () => onClick(),
    type: AppButtonType.primary,
    size: AppButtonSize.medium,
    customColor: tintColor,
    isFullWidth: true,
  );
}
