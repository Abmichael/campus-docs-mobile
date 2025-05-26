import 'package:flutter/material.dart';
import '../config/theme_config.dart';

/// Custom status chip widget that automatically styles based on status
class StatusChip extends StatelessWidget {
  final String status;
  final bool isLarge;

  const StatusChip({
    super.key,
    required this.status,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = ThemeConfig.getStatusColor(status);
    final textStyle = isLarge
        ? ThemeConfig.labelLarge
        : ThemeConfig.labelSmall; // Use even smaller text when isLarge is false

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? ThemeConfig.spaceMedium : ThemeConfig.spaceXSmall, // Smaller horizontal padding
        vertical: isLarge ? ThemeConfig.spaceSmall : 2, // Even smaller vertical padding
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: textStyle.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Custom role badge widget
class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final color = ThemeConfig.getRoleColor(role);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConfig.spaceSmall,
        vertical: ThemeConfig.spaceXSmall,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
      ),
      child: Text(
        role.toUpperCase(),
        style: ThemeConfig.labelSmall.copyWith(
          color: ThemeConfig.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Modern card wrapper with consistent styling
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isElevated;
  final Color? backgroundColor;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.isElevated = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: ThemeConfig.spaceSmall),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
        boxShadow: isElevated ? ThemeConfig.elevatedShadow : ThemeConfig.cardShadow,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(ThemeConfig.spaceMedium),
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Custom action button with consistent styling
class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isLoading;
  final bool isExpanded;

  const ActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isLoading = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    if (isSecondary) {
      button = OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading 
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : (icon != null ? Icon(icon) : const SizedBox.shrink()),
        label: Text(text),
      );
    } else {
      button = ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading 
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(ThemeConfig.white),
                ),
              )
            : (icon != null ? Icon(icon) : const SizedBox.shrink()),
        label: Text(text),
      );
    }

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

/// Custom info row for displaying key-value pairs
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Widget? trailing;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ThemeConfig.spaceXSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: ThemeConfig.textSecondary,
            ),
            const SizedBox(width: ThemeConfig.spaceSmall),
          ],
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: ThemeConfig.labelMedium.copyWith(
                color: ThemeConfig.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: ThemeConfig.bodyMedium.copyWith(
                color: ThemeConfig.textPrimary,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Custom section header
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ThemeConfig.spaceSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ThemeConfig.headlineSmall.copyWith(
                    color: ThemeConfig.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: ThemeConfig.spaceXSmall),
                  Text(
                    subtitle!,
                    style: ThemeConfig.bodySmall.copyWith(
                      color: ThemeConfig.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Custom empty state widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spaceLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: ThemeConfig.lightGray,
            ),
            const SizedBox(height: ThemeConfig.spaceMedium),
            Text(
              title,
              style: ThemeConfig.headlineSmall.copyWith(
                color: ThemeConfig.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ThemeConfig.spaceSmall),
            Text(
              message,
              style: ThemeConfig.bodyMedium.copyWith(
                color: ThemeConfig.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: ThemeConfig.spaceLarge),
              ActionButton(
                text: actionText!,
                onPressed: onAction,
                isSecondary: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom loading widget
class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: ThemeConfig.spaceMedium),
            Text(
              message!,
              style: ThemeConfig.bodyMedium.copyWith(
                color: ThemeConfig.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Custom gradient background
class GradientBackground extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final bool useHeaderGradient;

  const GradientBackground({
    super.key,
    required this.child,
    this.gradient,
    this.useHeaderGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? 
          (useHeaderGradient ? ThemeConfig.headerGradient : ThemeConfig.primaryGradient),
      ),
      child: child,
    );
  }
}
