import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'nix_button_size.dart';
import 'nix_button_state.dart';
import 'nix_button_style.dart';

/// A custom, premium, and theme-dynamic button widget.
///
/// Features a stadium-shaped (100% rounded) button designed to hold an icon,
/// with an optional text label positioned directly underneath.
///
/// Utilizes Riverpod for high performance by scoping interactive state (hover,
/// press, focus) updates so they do not rebuild parent widgets.
class NixButton extends ConsumerStatefulWidget {
  /// Callback when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;

  /// The child widget (typically an [Icon]) centered inside the button.
  final Widget icon;

  /// Optional label widget (typically [Text]) positioned under the button.
  final Widget? label;

  /// The size variant of the button. Defaults to [NixButtonSize.m].
  final NixButtonSize size;

  /// The styling variant of the button. Defaults to [NixButtonStyle.filled].
  final NixButtonStyle style;

  /// Whether the button is enabled. Defaults to true.
  final bool enabled;

  /// Whether to enable scale and decoration transitions. Defaults to false.
  final bool enableAnimations;

  /// Whether to show shadows under the button. Defaults to false.
  final bool showShadow;

  /// Optional custom background color, overriding the theme defaults.
  final Color? customBackgroundColor;

  /// Optional custom foreground color (icon & label text), overriding theme defaults.
  final Color? customForegroundColor;

  /// Optional custom border color for the outlined style.
  final Color? customBorderColor;

  /// The maximum width allowed for the label below the button to prevent layout overflow.
  ///
  /// Defaults to `width * 1.6` of the button size.
  final double? maxLabelWidth;

  /// Optional tooltip message shown on long-press or hover.
  final String? tooltip;

  /// Optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether this button should focus itself on mount.
  final bool autofocus;

  /// Custom cursor shown when hovering over the button.
  final MouseCursor mouseCursor;

  /// The duration of hover/press animations. Defaults to 150ms.
  final Duration animationDuration;

  /// The curve used for animations. Defaults to [Curves.easeInOut].
  final Curve animationCurve;

  /// The scale multiplier applied when hovered. Defaults to 1.03.
  final double hoverScale;

  /// The scale multiplier applied when pressed. Defaults to 0.96.
  final double pressScale;

  const NixButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.label,
    this.size = NixButtonSize.m,
    this.style = NixButtonStyle.filled,
    this.enabled = true,
    this.enableAnimations = false,
    this.showShadow = false,
    this.customBackgroundColor,
    this.customForegroundColor,
    this.customBorderColor,
    this.maxLabelWidth,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor = SystemMouseCursors.click,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.hoverScale = 1.03,
    this.pressScale = 0.96,
  });

  @override
  ConsumerState<NixButton> createState() => _NixButtonState();
}

class _NixButtonState extends ConsumerState<NixButton> {
  late final String _buttonId;

  @override
  void initState() {
    super.initState();
    // Unique ID to scope interaction states in Riverpod
    _buttonId =
        'nix_button_${DateTime.now().microsecondsSinceEpoch}_${identityHashCode(this)}';
  }

  bool get _isEnabled => widget.enabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nixButtonStateProvider(_buttonId));
    final double height = widget.size.height;
    final double width = widget.size.width;

    // Resolve dynamic colors based on theme and states
    final Color backgroundColor = _resolveBackgroundColor(context, state);
    final Color foregroundColor = _resolveForegroundColor(context, state);
    final Border? border = _resolveBorder(context, state);

    // Build the icon inside the button
    final Widget iconWithTheme = IconTheme.merge(
      data: IconThemeData(
        color: foregroundColor,
        size: widget.size.iconSize,
      ),
      child: widget.icon,
    );

    // Configure animation duration
    final duration = widget.enableAnimations ? widget.animationDuration : Duration.zero;

    // Define shadows
    final List<BoxShadow>? shadows = widget.showShadow
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: state.isHovered ? 8.0 : 4.0,
              offset: state.isHovered ? const Offset(0, 4.0) : const Offset(0, 2.0),
            )
          ]
        : null;

    final List<BoxShadow> focusRing = state.isFocused
        ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
              spreadRadius: 3.0,
              blurRadius: 3.0,
            )
          ]
        : [];

    final List<BoxShadow>? combinedShadows =
        (shadows == null && focusRing.isEmpty)
            ? null
            : [...(shadows ?? []), ...focusRing];

    // Main button container
    Widget buttonContainer = AnimatedContainer(
      duration: duration,
      curve: widget.animationCurve,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
        border: border,
        boxShadow: combinedShadows,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: _isEnabled ? widget.onPressed : null,
          onHover: _isEnabled
              ? (hovered) => ref
                  .read(nixButtonStateProvider(_buttonId).notifier)
                  .update((s) => s.copyWith(isHovered: hovered))
              : null,
          onFocusChange: _isEnabled
              ? (focused) => ref
                  .read(nixButtonStateProvider(_buttonId).notifier)
                  .update((s) => s.copyWith(isFocused: focused))
              : null,
          onTapDown: _isEnabled
              ? (_) => ref
                  .read(nixButtonStateProvider(_buttonId).notifier)
                  .update((s) => s.copyWith(isPressed: true))
              : null,
          onTapUp: _isEnabled
              ? (_) => ref
                  .read(nixButtonStateProvider(_buttonId).notifier)
                  .update((s) => s.copyWith(isPressed: false))
              : null,
          onTapCancel: _isEnabled
              ? () => ref
                  .read(nixButtonStateProvider(_buttonId).notifier)
                  .update((s) => s.copyWith(isPressed: false))
              : null,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          mouseCursor: _isEnabled ? widget.mouseCursor : SystemMouseCursors.basic,
          borderRadius: BorderRadius.circular(height / 2),
          child: Center(
            child: iconWithTheme,
          ),
        ),
      ),
    );

    // Combine button and label into a single layout
    Widget mainWidget;
    if (widget.label != null) {
      Widget labelWidget = widget.label!;

      // Automatically handle text style and overflow for the label under the button
      if (labelWidget is Text) {
        labelWidget = Text(
          labelWidget.data ?? '',
          style: TextStyle(
            fontSize: widget.size.labelFontSize,
            fontWeight: FontWeight.normal,
            color: _isEnabled
                ? (widget.customForegroundColor ??
                    Theme.of(context).colorScheme.onSurface)
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
          ).merge(labelWidget.style),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        );
      } else {
        labelWidget = DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: widget.size.labelFontSize,
            fontWeight: FontWeight.normal,
            color: _isEnabled
                ? (widget.customForegroundColor ??
                    Theme.of(context).colorScheme.onSurface)
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          child: labelWidget,
        );
      }

      // Constrain label width to prevent overflow
      labelWidget = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxLabelWidth ?? (width * 1.6),
        ),
        child: labelWidget,
      );

      mainWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buttonContainer,
          SizedBox(height: widget.size.labelGap),
          labelWidget,
        ],
      );
    } else {
      mainWidget = buttonContainer;
    }

    // Apply scale animation if enabled
    if (widget.enableAnimations && _isEnabled) {
      double scale = 1.0;
      if (state.isPressed) {
        scale = widget.pressScale;
      } else if (state.isHovered) {
        scale = widget.hoverScale;
      }

      mainWidget = AnimatedScale(
        scale: scale,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        child: mainWidget,
      );
    }

    // Apply tooltip if provided
    if (widget.tooltip != null) {
      mainWidget = Tooltip(
        message: widget.tooltip!,
        child: mainWidget,
      );
    }

    return mainWidget;
  }

  // Helper color utilities
  Color _darken(Color color, [double amount = .08]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  Color _lighten(Color color, [double amount = .08]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  // Resolve dynamic background color based on style, theme, and interaction state
  Color _resolveBackgroundColor(BuildContext context, NixButtonState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!_isEnabled) {
      if (widget.style == NixButtonStyle.outlined ||
          widget.style == NixButtonStyle.text) {
        return Colors.transparent;
      }
      return colorScheme.onSurface.withValues(alpha: 0.12);
    }

    Color baseColor;
    switch (widget.style) {
      case NixButtonStyle.filled:
        baseColor = widget.customBackgroundColor ?? colorScheme.primary;
        break;
      case NixButtonStyle.tonal:
        baseColor = widget.customBackgroundColor ?? colorScheme.primaryContainer;
        break;
      case NixButtonStyle.outlined:
      case NixButtonStyle.text:
        return Colors.transparent;
      case NixButtonStyle.elevated:
        baseColor = widget.customBackgroundColor ?? colorScheme.surface;
        break;
    }

    if (state.isPressed) {
      return _darken(baseColor, 0.08);
    } else if (state.isHovered) {
      return _lighten(baseColor, 0.05);
    }
    return baseColor;
  }

  // Resolve dynamic foreground color (icon/label) based on style, theme, and state
  Color _resolveForegroundColor(BuildContext context, NixButtonState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!_isEnabled) {
      return colorScheme.onSurface.withValues(alpha: 0.38);
    }

    Color baseColor;
    switch (widget.style) {
      case NixButtonStyle.filled:
        baseColor = widget.customForegroundColor ?? colorScheme.onPrimary;
        break;
      case NixButtonStyle.tonal:
        baseColor = widget.customForegroundColor ?? colorScheme.onPrimaryContainer;
        break;
      case NixButtonStyle.outlined:
      case NixButtonStyle.text:
      case NixButtonStyle.elevated:
        baseColor = widget.customForegroundColor ?? colorScheme.primary;
        break;
    }

    return baseColor;
  }

  // Resolve borders for outlined style
  Border? _resolveBorder(BuildContext context, NixButtonState state) {
    if (widget.style != NixButtonStyle.outlined) return null;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color color;
    if (!_isEnabled) {
      color = colorScheme.onSurface.withValues(alpha: 0.12);
    } else {
      color = widget.customBorderColor ?? colorScheme.outline;
    }

    return Border.all(color: color, width: 1.5);
  }
}
