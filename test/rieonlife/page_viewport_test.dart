import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/widgets/app_page_viewport.dart';
import 'package:unisinos_usp_app/widgets/living_clue_layout.dart';

void main() {
  for (final width in [1920.0, 1040.0, 390.0]) {
    testWidgets('all route content fits a $width px window', (tester) async {
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Size? measured;
      EdgeInsets? padding;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => AppPageViewport(child: child!),
          home: Builder(
            builder: (context) {
              measured = MediaQuery.sizeOf(context);
              padding = LivingClueLayout.pagePadding(context);
              return const Scaffold(
                body: SizedBox.expand(key: ValueKey('page')),
              );
            },
          ),
        ),
      );
      await tester.pump();
      final expectedWidth = width.clamp(0, AppPageViewport.maxWidth);
      final rect = tester.getRect(find.byKey(const ValueKey('page')));
      expect(rect.width, expectedWidth);
      expect(rect.left, (width - expectedWidth) / 2);
      expect(measured!.width, expectedWidth);
      expect(padding!.horizontal, 32, reason: 'no double desktop gutters');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
