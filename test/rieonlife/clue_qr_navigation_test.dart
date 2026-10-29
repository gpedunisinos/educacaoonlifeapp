import 'package:unisinos_usp_app/services/user_auth_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_spo/utils.dart';
import 'package:unisinos_usp_app/services/clue_links.dart';
import 'package:unisinos_usp_app/services/clue_qr.dart';
import 'package:unisinos_usp_app/services/clue_map_navigation.dart';
import 'package:unisinos_usp_app/widgets/clue_qr_dialog.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';

const member = AuthUser(
  id: 7,
  name: 'Teste',
  email: 'test@example.test',
  token: 'test',
  usageMode: 'explorer',
);

class _LoginUser extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {
    initialization = Future.value();
  }

  @override
  Future<void> savePrefs(AuthUser value) async {
    user.value = value;
  }
}

class _LoginApi extends UserWebclient {
  bool fail = false;
  @override
  Future<AuthUser> login({
    required String mail,
    required String password,
  }) async {
    if (fail) throw Exception('invalid credentials');
    return member;
  }
}

void main() {
  setUp(() async {
    PackageInfo.setMockInitialValues(
      appName: 'test',
      packageName: 'test',
      version: '1',
      buildNumber: '1',
      buildSignature: '',
    );
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    await Util.initPrefs();
  });
  tearDown(Get.reset);
  test(
    'QR links contain only a public web destination; returns reject unsafe routes',
    () {
      expect(
        ClueLinks.publicUrl(72),
        'https://educacaoonlife.gpedu.com.br/#/space/research/72',
      );
      for (final value in [
        'https://evil.test/space/research/72',
        '//evil.test',
        '/space/research/0',
        '/space/research/-1',
        '/space/research/72?token=secret',
        '/living_clues/update?id=72',
        '/space/research/72/../73',
        '/space/research/072',
        '/space/research/72#evil',
      ]) {
        expect(ClueLinks.safeTarget(value), isNull, reason: value);
      }
      expect(
        ClueLinks.safeTarget('/living_clues/show?id=72'),
        '/space/research/72',
      );
      ClueLinks.remember('/space/research/72');
      expect(ClueLinks.pending(), '/space/research/72');
      ClueLinks.remember('https://evil.test');
      expect(ClueLinks.pending(), '/space/research/72');
      ClueLinks.clear();
      expect(ClueLinks.pending(), isNull);
    },
  );
  testWidgets('QR raster has a white quiet zone and exports a decodable PNG', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final qr = ClueQr(72);
      final bytes = await qr.png();
      expect(bytes.take(8), [137, 80, 78, 71, 13, 10, 26, 10]);
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final rgba = await frame.image.toByteData();
      expect(rgba!.buffer.asUint8List().take(4), [255, 255, 255, 255]);
      expect(frame.image.width, (qr.matrix.moduleCount + 8) * 16);
      const output = String.fromEnvironment('QR_VALIDATION_PNG');
      if (output.isNotEmpty) await File(output).writeAsBytes(bytes);
      frame.image.dispose();
      codec.dispose();
    });
  });
  for (final size in [const Size(390, 844), const Size(844, 390)]) {
    testWidgets('QR dialog fits $size and copies the canonical pista link', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData')
            copied = (call.arguments as Map)['text'] as String;
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const ClueQrDialog(
                    clueId: 72,
                    name:
                        'Pista com um título extenso para conferir a legibilidade do código',
                  ),
                ),
                child: const Text('QR'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('QR'));
      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.tap(find.text('Copiar link'));
      await tester.pumpAndSettle();
      expect(copied, ClueLinks.publicUrl(72));
      expect(find.text('Link da pista copiado.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Fechar QR Code'));
      await tester.pumpAndSettle();
    });
  }
  testWidgets(
    'an unauthenticated QR keeps its destination through login reload and failure',
    (tester) async {
      final user = Get.put<UserController>(_LoginUser());
      final api = _LoginApi()..fail = true;
      user.webclient = api;
      final redirect = AppRouteGuard(
        canActivate: (user) => user != null,
      ).redirect('/space/research/72')!;
      expect(
        Uri.parse(redirect.name!).queryParameters['returnTo'],
        '/space/research/72',
      );
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: redirect.name,
          getPages: [
            GetPage(
              name: '/login',
              page: () => const Scaffold(body: Text('Login')),
            ),
            GetPage(
              name: '/space/research/:id',
              page: () => const Scaffold(body: Text('Pista retomada')),
            ),
            GetPage(
              name: '/space',
              page: () => const Scaffold(body: Text('Cockpit')),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        user.login('test@example.test', 'invalid'),
        throwsException,
      );
      expect(ClueLinks.pending(), '/space/research/72');
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      // Reconstructing navigation from the login URL must preserve the target.
      Get.offAllNamed(redirect.name!);
      await tester.pumpAndSettle();
      api.fail = false;
      await user.login('test@example.test', 'valid');
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/space/research/72');
      expect(find.text('Pista retomada'), findsOneWidget);
      expect(ClueLinks.pending(), isNull);
    },
  );
  testWidgets(
    'first mode selection keeps a QR target until the user can open it',
    (tester) async {
      final user = Get.put<UserController>(_LoginUser());
      user.user.value = const AuthUser(
        id: 7,
        name: 'Teste',
        email: 'test@example.test',
        token: 'test',
      );
      ClueLinks.remember('/space/research/72');
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/login',
          getPages: [
            GetPage(
              name: '/login',
              page: () => const Scaffold(body: Text('Login')),
            ),
            GetPage(
              name: '/choose_mode',
              page: () => const Scaffold(body: Text('Modo')),
            ),
            GetPage(
              name: '/space/research/:id',
              page: () => const Scaffold(body: Text('Pista')),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      user.completeAuthentication();
      await tester.pumpAndSettle();
      expect(Uri.parse(Get.currentRoute).path, '/choose_mode');
      expect(ClueLinks.pending(), '/space/research/72');
      user.user.value = member;
      user.completeAuthentication();
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/space/research/72');
      expect(ClueLinks.pending(), isNull);
      expect(
        AppRouteGuard(canActivate: (_) => true).redirect('/space/research/72'),
        isNull,
      );
    },
  );
  testWidgets(
    'session expiration forwards the pista in the login URL after clearing preferences',
    (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/space/research/72',
          getPages: [
            GetPage(
              name: '/login',
              page: () => const Scaffold(body: Text('Login')),
            ),
            GetPage(
              name: '/space/research/:id',
              page: () => const Scaffold(body: Text('Pista')),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      // Navigation futures finish when the route is removed, not when it opens.
      UserAuthService().logout();
      await tester.pumpAndSettle();
      expect(Uri.parse(Get.currentRoute).path, '/login');
      expect(Get.parameters['returnTo'], '/space/research/72');
      expect(ClueLinks.pending(), isNull);
    },
  );
  for (final existing in [true, false]) {
    testWidgets(
      'return to map unwinds sequential pistas; existing map=$existing',
      (tester) async {
        final mapKey = GlobalKey();
        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: existing ? '/living_clues/map' : '/space/research/1',
            getPages: [
              GetPage(
                name: '/living_clues/map',
                page: () =>
                    Scaffold(key: mapKey, body: const Text('Mapa preservado')),
              ),
              GetPage(
                name: '/space/research/:id',
                page: () => Scaffold(
                  body: TextButton(
                    onPressed: returnToClueMap,
                    child: const Text('Voltar ao mapa'),
                  ),
                ),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();
        final original = mapKey.currentContext;
        Get.toNamed('/space/research/2');
        await tester.pumpAndSettle();
        Get.toNamed('/space/research/3');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Voltar ao mapa'));
        await tester.pumpAndSettle();
        expect(Get.currentRoute, '/living_clues/map');
        if (existing) expect(mapKey.currentContext, same(original));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
