import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/widgets/auto_visible_frame.dart';

void main() {
  testWidgets(
    'loads nearby frames once and retains them while scrolling',
    (tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: AutoVisibleFrame(
                      builder: (_) => const Text('primeiro'),
                    ),
                  ),
                  const SizedBox(height: 1800),
                  SizedBox(
                    height: 200,
                    child: AutoVisibleFrame(
                      builder: (_) => const Text('segundo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('primeiro'), findsOneWidget);
      expect(find.text('segundo'), findsNothing);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -1800),
      );
      await tester.pumpAndSettle();
      expect(find.text('primeiro'), findsOneWidget);
      expect(find.text('segundo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
