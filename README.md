# Nix Button

A custom, premium, and theme-dynamic button widget for Flutter designed for performance, style, and clean layout boundaries.

## Features

- **Stadium Shape**: 100% rounded corners with a custom aspect ratio layout where `width = height + 20.0` (1.0 design units more than height).
- **Label Underneath**: An optional label (e.g. Text) positioned directly underneath the button container, automatically styled with normal weight.
- **Overflow Prevention**: The label automatically handles layout overflows using size-constrained boundaries with ellipsis truncation.
- **Dynamic Theming**: Automatically resolves dynamic colors (background, foreground, outlines) based on the active `ThemeData` and dark/light modes.
- **Riverpod State Management**: High-performance rendering powered by a scoped Riverpod interactive state provider (`nixButtonStateProvider`). Hover, focus, and press updates rebuild only the button's internal parts, leaving the parent widget tree untouched.
- **Configurable Animations & Shadows**: Scale/color transitions and elevation shadows are disabled by default for absolute simplicity and maximum rendering speed, but can easily be enabled.

## Sizing Specs

NixButton supports three default sizes:

| Size | Height | Width | Label Font Size | Icon Size | Gap to Label |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **S** (Small) | `32.0` | `52.0` | `12.0` | `16.0` | `4.0` |
| **M** (Medium - Default) | `48.0` | `68.0` | `14.0` | `24.0` | `6.0` |
| **L** (Large) | `60.0` | `80.0` | `16.0` | `28.0` | `8.0` |

## Usage

Ensure your app is wrapped inside a Riverpod `ProviderScope` to enable performance optimizations:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nix_button/nix_button.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NixButton Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Standard Filled style NixButton
            NixButton(
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              onPressed: () {
                print('Button Pressed!');
              },
            ),
            const SizedBox(height: 20),

            // Outlined Small NixButton
            NixButton(
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
              size: NixButtonSize.s,
              style: NixButtonStyle.outlined,
              onPressed: () {},
            ),
            const SizedBox(height: 20),

            // Tonal Large NixButton with animations enabled
            NixButton(
              icon: const Icon(Icons.favorite),
              label: const Text('Favorite'),
              size: NixButtonSize.l,
              style: NixButtonStyle.tonal,
              enableAnimations: true,
              showShadow: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

## Additional Customization Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `style` | `NixButtonStyle` | `NixButtonStyle.filled` | Style variant: `filled`, `tonal`, `outlined`, `text`. |
| `size` | `NixButtonSize` | `NixButtonSize.m` | Size variant: `s`, `m`, `l`. |
| `enabled` | `bool` | `true` | Enables or disables interaction. |
| `enableAnimations` | `bool` | `false` | Enables scale and color transitions. |
| `showShadow` | `bool` | `false` | Shows box shadows underneath the button. |
| `customBackgroundColor` | `Color?` | `null` | Overrides the default theme background color. |
| `customForegroundColor` | `Color?` | `null` | Overrides the default theme foreground color. |
| `maxLabelWidth` | `double?` | `width * 1.6` | Imposes a maximum width constraint on the label to handle overflows. |
| `tooltip` | `String?` | `null` | Optional accessibility and hover tooltip message. |

## Example App

An example application showcasing various features, styles, sizes, and layout configurations of `NixButton` is available in the [example](./example) directory.

To run the example app:
1. Navigate to the example directory:
   ```bash
   cd example
   ```
2. Run the application:
   ```bash
   flutter run
   ```
