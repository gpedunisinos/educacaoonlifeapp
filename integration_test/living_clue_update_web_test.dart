import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:unisinos_usp_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const email =
      String.fromEnvironment('E2E_EMAIL', defaultValue: 'admin@admin.com');
  const password =
      String.fromEnvironment('E2E_PASSWORD', defaultValue: 'uu2admin');
  const route = '/living_clues/update?id=8';

  testWidgets('abre a edicao da pista viva 8 sem erro no Flutter Web',
      (tester) async {
    final errors = <String>[];
    final previousFlutterError = FlutterError.onError;
    final previousPlatformError = PlatformDispatcher.instance.onError;

    FlutterError.onError = (details) {
      errors.add(
          'FlutterError: ${details.exceptionAsString()}\n${details.stack}');
      previousFlutterError?.call(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      errors.add('PlatformError: $error\n$stack');
      return true;
    };

    try {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 8));

      final fields = find.byType(TextFormField);
      if (fields.evaluate().length >= 2) {
        await tester.enterText(fields.at(0), email);
        await tester.enterText(fields.at(1), password);
        await tester.tap(find.text('Entrar'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 20));
      }

      Get.offAllNamed(route);
      await tester.pump();

      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        final exception = tester.takeException();
        if (exception != null) {
          errors.add('WidgetTester: $exception');
        }
      }

      debugPrint('E2E route: $route');
      for (final error in errors) {
        debugPrint('E2E captured error:\n$error');
      }

      expect(find.text('Editar pista viva'), findsOneWidget,
          reason: 'A tela de edição não foi apresentada.');
      expect(errors, isEmpty,
          reason: 'A rota de edição produziu erros de execução.');
    } finally {
      FlutterError.onError = previousFlutterError;
      PlatformDispatcher.instance.onError = previousPlatformError;
    }
  });
}
