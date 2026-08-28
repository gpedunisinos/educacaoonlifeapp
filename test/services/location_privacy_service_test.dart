import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/services/location_privacy_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('requires acknowledgement and remembers the decision',
      (tester) async {
    late BuildContext testContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            testContext = context;
            return const Scaffold();
          },
        ),
      ),
    );

    final firstConfirmation =
        LocationPrivacyService.ensureAcknowledged(testContext);
    await tester.pumpAndSettle();

    expect(find.text('Proteja sua localização'), findsOneWidget);
    expect(find.text('Entendi, continuar'), findsOneWidget);

    await tester.tap(find.text('Entendi, continuar'));
    await tester.pumpAndSettle();

    expect(await firstConfirmation, isTrue);

    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getBool(LocationPrivacyService.acknowledgementKey),
      isTrue,
    );

    expect(
      await LocationPrivacyService.ensureAcknowledged(testContext),
      isTrue,
    );
    expect(find.text('Proteja sua localização'), findsNothing);
  });

  testWidgets('does not remember a cancelled warning', (tester) async {
    late BuildContext testContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            testContext = context;
            return const Scaffold();
          },
        ),
      ),
    );

    final confirmation = LocationPrivacyService.ensureAcknowledged(testContext);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(await confirmation, isFalse);

    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getBool(LocationPrivacyService.acknowledgementKey),
      isNull,
    );
  });
}
