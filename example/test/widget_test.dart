import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/main.dart';
import 'package:nix_button/nix_button.dart';

void main() {
  testWidgets('NixButton example app smoke test', (WidgetTester tester) async {
    // Build our app wrapped in a ProviderScope.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the title is rendered.
    expect(find.text('NixButton Showcase'), findsOneWidget);

    // Verify that multiple NixButton widgets are rendered.
    expect(find.byType(NixButton), findsAtLeastNWidgets(3));

    // Find the NixButton widget that contains the "Filled" label
    final filledButtonFinder = find.ancestor(
      of: find.text('Filled'),
      matching: find.byType(NixButton),
    );

    // Find the Icon (or InkWell) inside that specific button and tap it
    final iconFinder = find.descendant(
      of: filledButtonFinder,
      matching: find.byType(Icon),
    );
    await tester.tap(iconFinder);
    await tester.pumpAndSettle();

    // Verify that the feedback status bar message updates.
    expect(find.text('Pressed Filled Style Button'), findsOneWidget);
  });
}
