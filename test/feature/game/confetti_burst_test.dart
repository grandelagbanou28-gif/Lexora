import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wordly/src/feature/game/widget/confetti_burst.dart';

void main() {
  testWidgets('confetti burst animates without exceptions and finishes', (tester) async {
    var finished = false;
    await tester.pumpWidget(MaterialApp(home: ConfettiBurst(particleCount: 24, onFinished: () => finished = true)));
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);

    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(tester.takeException(), isNull);
    expect(finished, isTrue);
  });

  testWidgets('showConfettiBurst inserts an overlay entry that removes itself', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Center(
            child: TextButton(onPressed: () => showConfettiBurst(context), child: const Text('boom')),
          ),
        ),
      ),
    );
    await tester.tap(find.text('boom'));
    await tester.pump();
    expect(find.byType(ConfettiBurst), findsOneWidget);

    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(find.byType(ConfettiBurst), findsNothing);
  });
}
