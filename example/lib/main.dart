import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nix_button/nix_button.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NixButton Example App',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        splashFactory: NoSplash.splashFactory,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        splashFactory: NoSplash.splashFactory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: NixButtonDemoPage(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class NixButtonDemoPage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const NixButtonDemoPage({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<NixButtonDemoPage> createState() => _NixButtonDemoPageState();
}

class _NixButtonDemoPageState extends State<NixButtonDemoPage> {
  bool _animationsEnabled = true;
  String _message = 'Tap any button to see the action here!';

  void _showMessage(String text) {
    setState(() {
      _message = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NixButton Showcase'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme Mode',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status bar message
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                _message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Configurations Card
            _buildSectionCard(
              title: 'Configurations',
              child: SwitchListTile(
                title: const Text('Enable Hover/Press Animations'),
                subtitle: const Text(
                  'Adds scaling transitions and color shifting when interacting.',
                ),
                value: _animationsEnabled,
                onChanged: (val) {
                  setState(() {
                    _animationsEnabled = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Styles Section
            _buildSectionCard(
              title: 'Styles (Medium Size)',
              child: Wrap(
                spacing: 16,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  NixButton(
                    icon: const Icon(Icons.star),
                    label: const Text('Filled'),
                    style: NixButtonStyle.filled,
                    enableAnimations: _animationsEnabled,
                    onPressed: () =>
                        _showMessage('Pressed Filled Style Button'),
                  ),
                  NixButton(
                    icon: const Icon(Icons.favorite),
                    label: const Text('Tonal'),
                    style: NixButtonStyle.tonal,
                    enableAnimations: _animationsEnabled,
                    onPressed: () => _showMessage('Pressed Tonal Style Button'),
                  ),
                  NixButton(
                    icon: const Icon(Icons.send),
                    label: const Text('Outlined'),
                    style: NixButtonStyle.outlined,
                    enableAnimations: _animationsEnabled,
                    onPressed: () =>
                        _showMessage('Pressed Outlined Style Button'),
                  ),
                  NixButton(
                    icon: const Icon(Icons.shield),
                    label: const Text('Elevated'),
                    style: NixButtonStyle.elevated,
                    enableAnimations: _animationsEnabled,
                    onPressed: () =>
                        _showMessage('Pressed Elevated Style Button'),
                  ),
                  NixButton(
                    icon: const Icon(Icons.comment),
                    label: const Text('Text Only'),
                    style: NixButtonStyle.text,
                    enableAnimations: _animationsEnabled,
                    onPressed: () => _showMessage('Pressed Text Style Button'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sizes Section
            _buildSectionCard(
              title: 'Sizes (Filled Style)',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NixButton(
                    icon: const Icon(Icons.add),
                    label: const Text('Small'),
                    size: NixButtonSize.s,
                    style: NixButtonStyle.filled,
                    enableAnimations: _animationsEnabled,
                    onPressed: () => _showMessage('Pressed Small Button'),
                  ),
                  NixButton(
                    icon: const Icon(Icons.add),
                    label: const Text('Medium'),
                    size: NixButtonSize.m,
                    style: NixButtonStyle.filled,
                    enableAnimations: _animationsEnabled,
                    onPressed: () => _showMessage('Pressed Medium Button'),
                  ),
                  NixButton(
                    icon: const Icon(Icons.add),
                    label: const Text('Large'),
                    size: NixButtonSize.l,
                    style: NixButtonStyle.filled,
                    enableAnimations: _animationsEnabled,
                    onPressed: () => _showMessage('Pressed Large Button'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Edge Cases & Layout
            _buildSectionCard(
              title: 'Layout Scenarios',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Without a Label
                      NixButton(
                        icon: const Icon(Icons.delete),
                        enableAnimations: _animationsEnabled,
                        onPressed: () =>
                            _showMessage('Pressed Delete Button (No Label)'),
                      ),

                      // Custom Colors
                      NixButton(
                        icon: const Icon(Icons.check),
                        label: const Text('Success'),
                        customBackgroundColor: Colors.green,
                        customForegroundColor: Colors.white,
                        enableAnimations: _animationsEnabled,
                        onPressed: () => _showMessage(
                          'Pressed Success Button (Green Custom)',
                        ),
                      ),

                      // Disabled State
                      const NixButton(
                        icon: Icon(Icons.lock),
                        label: Text('Disabled'),
                        onPressed: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'Label Overflow Handling (Horizontal constraint):',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NixButton(
                        icon: const Icon(Icons.warning),
                        label: const Text('Super Long Overflows Label'),
                        enableAnimations: _animationsEnabled,
                        onPressed: () =>
                            _showMessage('Pressed Overflowing Button'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
