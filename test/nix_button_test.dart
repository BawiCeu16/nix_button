import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nix_button/nix_button.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('NixButton Widget Tests', () {
    testWidgets('renders icon inside NixButton', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const NixButton(
            icon: Icon(Icons.add),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('resolves dimensions correctly for S size', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const NixButton(
            icon: Icon(Icons.add),
            size: NixButtonSize.s,
          ),
        ),
      );

      // Find the AnimatedContainer representing the button's body.
      final containerFinder = find.byType(AnimatedContainer);
      expect(containerFinder, findsOneWidget);

      final RenderBox renderBox = tester.renderObject(containerFinder);
      expect(renderBox.size.height, 32.0);
      expect(renderBox.size.width, 52.0);
    });

    testWidgets('resolves dimensions correctly for M size (default)', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const NixButton(
            icon: Icon(Icons.add),
          ),
        ),
      );

      final containerFinder = find.byType(AnimatedContainer);
      expect(containerFinder, findsOneWidget);

      final RenderBox renderBox = tester.renderObject(containerFinder);
      expect(renderBox.size.height, 48.0);
      expect(renderBox.size.width, 68.0);
    });

    testWidgets('resolves dimensions correctly for L size', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const NixButton(
            icon: Icon(Icons.add),
            size: NixButtonSize.l,
          ),
        ),
      );

      final containerFinder = find.byType(AnimatedContainer);
      expect(containerFinder, findsOneWidget);

      final RenderBox renderBox = tester.renderObject(containerFinder);
      expect(renderBox.size.height, 60.0);
      expect(renderBox.size.width, 80.0);
    });

    testWidgets('renders label underneath button and handles overflow', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const NixButton(
            icon: Icon(Icons.add),
            label: Text('Sample Label Under Button'),
          ),
        ),
      );

      // The widget should render the label in a column layout below the button.
      expect(find.text('Sample Label Under Button'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);

      // Verify the label has constrained width to prevent overflow
      final constrainedFinder = find.byType(ConstrainedBox);
      expect(constrainedFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('triggers onPressed when enabled', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        buildTestableWidget(
          NixButton(
            icon: const Icon(Icons.add),
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('does not trigger onPressed when disabled', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        buildTestableWidget(
          NixButton(
            icon: const Icon(Icons.add),
            enabled: false,
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(pressed, isFalse);
    });
  });
}
