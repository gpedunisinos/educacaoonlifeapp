import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/models/nominatim_place_model.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_location_screen.dart';

class OfflineTiles extends TileProvider {
  @override
  ImageProvider getImage(
    TileCoordinates coordinates,
    TileLayer options,
  ) => MemoryImage(
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    ),
  );
}

void main() {
  testWidgets('search selects a point, confirmation returns it to the form', (
    tester,
  ) async {
    LatLng? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              child: const Text('Abrir mapa'),
              onPressed: () async {
                selected = await Navigator.of(context).push<LatLng>(
                  MaterialPageRoute(
                    builder: (_) => LivingClueLocationScreen(
                      tileProvider: OfflineTiles(),
                      loadLayers: () async => [],
                      searchPlaces: (query) async {
                        expect(query, 'São Leopoldo');
                        return [
                          NominatimPlaceModel(
                            displayName: 'São Leopoldo, RS',
                            latitude: -29.76,
                            longitude: -51.15,
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir mapa'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(
            find.byWidgetPredicate((widget) => widget is FilledButton),
          )
          .onPressed,
      isNull,
    );
    await tester.enterText(find.byType(TextField), 'São Leopoldo');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.text('São Leopoldo, RS'));
    await tester.pumpAndSettle();
    expect(find.text('-29.760000, -51.150000'), findsOneWidget);
    await tester.tap(find.text('Usar esta localização'));
    await tester.pumpAndSettle();
    expect(selected?.latitude, -29.76);
    expect(selected?.longitude, -51.15);
    expect(find.text('Abrir mapa'), findsOneWidget);
  });

  testWidgets('cancel preserves the original point and mobile layout fits', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    LatLng? selected = const LatLng(1, 2);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              child: const Text('Abrir mapa'),
              onPressed: () async {
                final result = await Navigator.of(context).push<LatLng>(
                  MaterialPageRoute(
                    builder: (_) => LivingClueLocationScreen(
                      initialPoint: selected,
                      tileProvider: OfflineTiles(),
                      loadLayers: () async => [],
                    ),
                  ),
                );
                if (result != null) selected = result;
              },
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir mapa'));
    await tester.pumpAndSettle();
    await tester.tapAt(tester.getCenter(find.byType(FlutterMap)));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(selected?.latitude, 1);
    expect(selected?.longitude, 2);
    expect(tester.takeException(), isNull);
  });
}
