import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/services/presence/presence_wire_native.dart';

class _RealHttp extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context);
}

void main() {
  testWidgets(
    'native socket authenticates on the wire and reports suspension without leaking lifecycle listeners',
    (tester) async {
      await tester.runAsync(
        () => HttpOverrides.runWithHttpOverrides(() async {
          final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
          final peer = Completer<WebSocket>();
          server.listen((request) async {
            expect(
              request.headers.value('origin'),
              NativePresenceConnection.origin,
            );
            peer.complete(await WebSocketTransformer.upgrade(request));
          });
          final binding = WidgetsBinding.instance;
          binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
          final connection = NativePresenceConnection(
            Uri.parse('ws://127.0.0.1:${server.port}/api/presence'),
          );
          final messages = <String>[],
              visibility = <bool>[],
              interactions = <void>[];
          connection.messages.listen(messages.add);
          connection.visibility.listen(visibility.add);
          connection.interactions.listen(interactions.add);
          await connection.ready;
          final socket = await peer.future;
          final frames = <dynamic>[];
          socket.listen(frames.add);
          connection.send('{"type":"auth","token":"synthetic-native-test"}');
          await Future<void>.delayed(const Duration(milliseconds: 30));
          expect(
            frames.single,
            '{"type":"auth","token":"synthetic-native-test"}',
          );
          socket.add('{"type":"snapshot","version":1}');
          await Future<void>.delayed(const Duration(milliseconds: 30));
          expect(messages, ['{"type":"snapshot","version":1}']);
          binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
          await Future<void>.delayed(const Duration(milliseconds: 10));
          expect(connection.visible, isFalse);
          expect(visibility.last, isFalse);
          GestureBinding.instance.pointerRouter.route(const PointerDownEvent());
          await Future<void>.delayed(const Duration(milliseconds: 10));
          expect(interactions, isEmpty);
          binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
          GestureBinding.instance.pointerRouter.route(const PointerDownEvent());
          await Future<void>.delayed(const Duration(milliseconds: 10));
          expect(connection.visible, isTrue);
          expect(visibility.last, isTrue);
          expect(interactions.length, 1);
          connection.close();
          connection.close();
          await socket.close();
          await server.close(force: true);
        }, _RealHttp()),
      );
      await tester.pump();
    },
  );
}
