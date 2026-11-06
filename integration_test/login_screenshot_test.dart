import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:unisinos_usp_app/main.dart' as app;

Future<void> _saveCurrentScreenPng(
    WidgetTester tester, String outputPath) async {
  OffsetLayer? layer;
  Rect? bounds;

  final scaffoldMatches = find.byType(Scaffold).evaluate();
  if (scaffoldMatches.isNotEmpty) {
    final ro = scaffoldMatches.first.renderObject;
    if (ro != null && ro.layer is OffsetLayer) {
      layer = ro.layer! as OffsetLayer;
      bounds = ro.paintBounds;
    }
  }

  if (layer == null || bounds == null) {
    final root = RendererBinding.instance.renderView;
    if (root.debugLayer is OffsetLayer) {
      layer = root.debugLayer as OffsetLayer;
      bounds = root.paintBounds;
    }
  }

  if (layer == null || bounds == null) {
    throw Exception('Render object/layer not available for screenshot');
  }

  final image = await layer.toImage(bounds);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) throw Exception('Could not encode PNG bytes');

  final bytes = Uint8List.view(byteData.buffer);
  final file = File(outputPath);
  await file.writeAsBytes(bytes, flush: true);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const email =
      String.fromEnvironment('E2E_EMAIL', defaultValue: 'admin@admin.com');
  const password =
      String.fromEnvironment('E2E_PASSWORD', defaultValue: 'uu2admin');

  testWidgets('login, navegar até Nova conexão e gerar print', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 8));

    final emailField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    final loginButton = find.text('Entrar');

    if (emailField.evaluate().isNotEmpty &&
        passwordField.evaluate().isNotEmpty &&
        loginButton.evaluate().isNotEmpty) {
      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(loginButton);

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(const Duration(seconds: 20));
    } else {
      await tester.pumpAndSettle(const Duration(seconds: 10));
    }

    expect(find.text('Home'), findsWidgets,
        reason: 'Não detectou tela inicial após login/redirect.');

    final conexoesCard = find.text('Conexões');
    expect(conexoesCard, findsWidgets,
        reason: 'Card de Conexões não encontrado na Home.');
    await tester.tap(conexoesCard.first);
    await tester.pumpAndSettle(const Duration(seconds: 12));

    expect(find.text('Conexões'), findsWidgets,
        reason: 'Tela de Conexões não abriu.');

    final addButton = find.byTooltip('Nova conexão');
    expect(addButton, findsWidgets,
        reason: 'Botão Nova conexão não encontrado.');
    await tester.tap(addButton.first);
    await tester.pumpAndSettle(const Duration(seconds: 12));

    expect(find.text('Nova conexão'), findsWidgets,
        reason: 'Tela Nova conexão não abriu.');
    expect(find.text('Pista origem'), findsWidgets);
    expect(find.text('Pista destino'), findsWidgets);
    expect(find.text('Tipo de conexão'), findsWidgets);

    const out = '/home/odair/.openclaw/workspace/unisinos_usp_nova_conexao.png';
    try {
      await _saveCurrentScreenPng(tester, out);
    } catch (e) {
      debugPrint('Screenshot capture skipped: $e');
    }
  });
}
