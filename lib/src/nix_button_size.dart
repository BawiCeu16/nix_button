/// The size configuration for [NixButton].
enum NixButtonSize {
  /// Small size (Height: 32, Width: 52).
  s,

  /// Medium size (Height: 48, Width: 68) - Default.
  m,

  /// Large size (Height: 60, Width: 80).
  l,
}

/// Extension to provide easy access to dimensional properties for each [NixButtonSize].
extension NixButtonSizeExtension on NixButtonSize {
  /// The height of the button container.
  double get height {
    switch (this) {
      case NixButtonSize.s:
        return 32.0;
      case NixButtonSize.m:
        return 48.0;
      case NixButtonSize.l:
        return 60.0;
    }
  }

  /// The width of the button container (height + 20.0).
  double get width => height + 20.0;

  /// The font size of the label text below the button.
  double get labelFontSize {
    switch (this) {
      case NixButtonSize.s:
        return 12.0;
      case NixButtonSize.m:
        return 14.0;
      case NixButtonSize.l:
        return 16.0;
    }
  }

  /// The size of the icon inside the button.
  double get iconSize {
    switch (this) {
      case NixButtonSize.s:
        return 16.0;
      case NixButtonSize.m:
        return 24.0;
      case NixButtonSize.l:
        return 28.0;
    }
  }

  /// The spacing gap between the button and the label.
  double get labelGap {
    switch (this) {
      case NixButtonSize.s:
        return 4.0;
      case NixButtonSize.m:
        return 6.0;
      case NixButtonSize.l:
        return 8.0;
    }
  }
}
