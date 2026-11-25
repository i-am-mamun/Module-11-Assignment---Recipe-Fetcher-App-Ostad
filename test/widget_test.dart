import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_fetcher_app/main.dart';

void main() {
  testWidgets('loads recipe data and displays recipe titles', (tester) async {
    await tester.pumpWidget(const RecipeFetcherApp());
    await tester.pumpAndSettle();

    expect(find.text('Pasta Carbonara'), findsOneWidget);
    expect(
      find.text('Creamy pasta dish with bacon and cheese.'),
      findsOneWidget,
    );
    expect(find.text('spaghetti'), findsOneWidget);

    final listScrollable = find.descendant(
      of: find.byKey(const ValueKey('recipe-list')),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('Berry Parfait'),
      300,
      scrollable: listScrollable,
    );
    expect(find.text('Berry Parfait'), findsOneWidget);
  });
}
