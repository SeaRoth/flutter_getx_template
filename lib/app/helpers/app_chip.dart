import 'package:flutter/material.dart';

/// Consistent chip design system for the app
class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final AppChipType type;
  final AppChipSize size;
  final Widget? avatar;
  final Widget? deleteIcon;
  final VoidCallback? onDeleted;

  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.type = AppChipType.filter,
    this.size = AppChipSize.medium,
    this.avatar,
    this.deleteIcon,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return _buildChip(context);
  }

  Widget _buildChip(BuildContext context) {
    final chipStyle = _getChipStyle(context);
    final textStyle = _getTextStyle(context);

    switch (type) {
      case AppChipType.filter:
        return FilterChip(
          label: Text(label, style: textStyle),
          selected: isSelected,
          onSelected: onTap != null ? (_) => onTap!() : null,
          avatar: avatar,
          deleteIcon: deleteIcon,
          onDeleted: onDeleted,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: _getVisualDensity(),
          side: chipStyle.side,
          backgroundColor: chipStyle.backgroundColor,
          selectedColor: chipStyle.selectedColor,
          labelStyle: textStyle,
          shape: chipStyle.shape,
          padding: chipStyle.padding,
        );
      case AppChipType.choice:
        return ChoiceChip(
          label: Text(label, style: textStyle),
          selected: isSelected,
          onSelected: onTap != null ? (_) => onTap!() : null,
          avatar: avatar,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: _getVisualDensity(),
          side: chipStyle.side,
          backgroundColor: chipStyle.backgroundColor,
          selectedColor: chipStyle.selectedColor,
          labelStyle: textStyle,
          shape: chipStyle.shape,
          padding: chipStyle.padding,
        );
      case AppChipType.input:
        return InputChip(
          label: Text(label, style: textStyle),
          selected: isSelected,
          onSelected: onTap != null ? (_) => onTap!() : null,
          onDeleted: onDeleted,
          avatar: avatar,
          deleteIcon: deleteIcon,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: _getVisualDensity(),
          side: chipStyle.side,
          backgroundColor: chipStyle.backgroundColor,
          selectedColor: chipStyle.selectedColor,
          labelStyle: textStyle,
          shape: chipStyle.shape,
          padding: chipStyle.padding,
        );
      case AppChipType.action:
        return ActionChip(
          label: Text(label, style: textStyle),
          onPressed: onTap,
          avatar: avatar,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: _getVisualDensity(),
          side: chipStyle.side,
          backgroundColor: chipStyle.backgroundColor,
          labelStyle: textStyle,
          shape: chipStyle.shape,
          padding: chipStyle.padding,
        );
    }
  }

  _ChipStyle _getChipStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return _ChipStyle(
      backgroundColor: isDarkMode
          ? colorScheme.surface.withOpacity(0.3)
          : colorScheme.surface,
      selectedColor: colorScheme.primary,
      side: BorderSide(
        color: isSelected
            ? colorScheme.primary
            : colorScheme.outline.withOpacity(0.5),
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Consistent with buttons
      ),
      padding: _getPadding(),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppChipSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case AppChipSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case AppChipSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  VisualDensity _getVisualDensity() {
    switch (size) {
      case AppChipSize.small:
        return VisualDensity.compact;
      case AppChipSize.medium:
        return VisualDensity.standard;
      case AppChipSize.large:
        return VisualDensity.comfortable;
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseStyle = switch (size) {
      AppChipSize.small => theme.textTheme.bodySmall,
      AppChipSize.medium => theme.textTheme.bodyMedium,
      AppChipSize.large => theme.textTheme.bodyLarge,
    };

    return baseStyle?.copyWith(
          fontWeight: FontWeight.w500,
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        ) ??
        TextStyle(
          fontWeight: FontWeight.w500,
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        );
  }
}

class _ChipStyle {
  final Color backgroundColor;
  final Color selectedColor;
  final BorderSide side;
  final OutlinedBorder shape;
  final EdgeInsetsGeometry padding;

  _ChipStyle({
    required this.backgroundColor,
    required this.selectedColor,
    required this.side,
    required this.shape,
    required this.padding,
  });
}

enum AppChipType {
  filter, // Can be selected/deselected
  choice, // Single selection from group
  input, // Can be deleted
  action, // Performs an action
}

enum AppChipSize {
  small,
  medium,
  large,
}

/// Consistent chip group widget
class AppChipGroup extends StatelessWidget {
  final List<String> labels;
  final List<int> selectedIndices;
  final Function(List<int>) onSelectionChanged;
  final bool multiSelect;
  final AppChipType type;
  final AppChipSize size;
  final double spacing;
  final double runSpacing;

  const AppChipGroup({
    super.key,
    required this.labels,
    required this.selectedIndices,
    required this.onSelectionChanged,
    this.multiSelect = true,
    this.type = AppChipType.filter,
    this.size = AppChipSize.medium,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: labels.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final isSelected = selectedIndices.contains(index);

        return AppChip(
          label: label,
          isSelected: isSelected,
          type: type,
          size: size,
          onTap: () => _handleSelection(index),
        );
      }).toList(),
    );
  }

  void _handleSelection(int index) {
    List<int> newSelection = List.from(selectedIndices);

    if (multiSelect) {
      if (newSelection.contains(index)) {
        newSelection.remove(index);
      } else {
        newSelection.add(index);
      }
    } else {
      newSelection = [index];
    }

    onSelectionChanged(newSelection);
  }
}
