import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/widgets/deter_nearby.dart';
import 'package:unisinos_usp_app/webclients/deter_webclient.dart';

class FakeDeter implements DeterSource {
  bool covered = true, fail = false;
  final radii = <int>[];
  @override
  Future<Map<String, dynamic>> nearby(
    double lat,
    double lon,
    int radius,
  ) async {
    radii.add(radius);
    if (fail) throw Exception('offline');
    return {
      'covered': covered,
      'total': 2,
      'classes': [
        {'class_name': 'DESMATAMENTO_CR', 'count': 2},
      ],
      'period_start': '2025-11-19',
      'period_end': '2026-11-19',
      'fetched_at': '2026-11-19T12:00:00Z',
      'stale': false,
    };
  }
}

void main() {
  testWidgets('radius and records are updated without changing clue', (
    tester,
  ) async {
    final source = FakeDeter();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: DeterNearby(latitude: -3, longitude: -55, source: source),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('2 avisos no entorno'), findsOneWidget);
    await tester.tap(find.text('5 km'));
    await tester.pumpAndSettle();
    expect(source.radii, [1000, 5000]);
    expect(find.textContaining('19/11/2025 a 19/11/2026'), findsOneWidget);
  });
  testWidgets('outside coverage is not presented as zero notices', (
    tester,
  ) async {
    final source = FakeDeter()..covered = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: DeterNearby(latitude: -30, longitude: -51, source: source),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('fora da cobertura'), findsOneWidget);
    expect(find.textContaining('2 avisos no entorno'), findsNothing);
  });
  testWidgets('failed source can be retried', (tester) async {
    final source = FakeDeter()..fail = true;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: DeterNearby(latitude: -3, longitude: -55, source: source),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tentar novamente'), findsOneWidget);
    source.fail = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.textContaining('2 avisos no entorno'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
