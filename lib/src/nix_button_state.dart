/// Represents the interaction states of a single [NixButton].
class NixButtonState {
  /// Whether the button is currently hovered.
  final bool isHovered;

  /// Whether the button is currently pressed.
  final bool isPressed;

  /// Whether the button currently has focus.
  final bool isFocused;

  /// Creates a [NixButtonState].
  const NixButtonState({
    this.isHovered = false,
    this.isPressed = false,
    this.isFocused = false,
  });

  /// Creates a copy of this state with the given fields replaced.
  NixButtonState copyWith({
    bool? isHovered,
    bool? isPressed,
    bool? isFocused,
  }) {
    return NixButtonState(
      isHovered: isHovered ?? this.isHovered,
      isPressed: isPressed ?? this.isPressed,
      isFocused: isFocused ?? this.isFocused,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NixButtonState &&
        other.isHovered == isHovered &&
        other.isPressed == isPressed &&
        other.isFocused == isFocused;
  }

  @override
  int get hashCode => Object.hash(isHovered, isPressed, isFocused);
}
