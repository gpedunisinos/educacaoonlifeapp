import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/widgets/anchored_tutorial_layout.dart';

void main() {
  testWidgets('tutorial ignores an anchor after its route is removed', (
    tester,
  ) async {
    BuildContext? saved;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            saved = context;
            return const SizedBox(width: 100, height: 100);
          },
        ),
      ),
    );
    expect(attachedTutorialBox(saved), isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(attachedTutorialBox(saved), isNull);
    expect(tester.takeException(), isNull);
  });
}
