// The iframe owns the WebGL canvas; Flutter owns navigation and authentication.
import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class SpaceView extends StatefulWidget {
  const SpaceView({super.key, required this.onMessage, required this.commands});
  final void Function(Map<String, dynamic>) onMessage;
  final Stream<Map<String, dynamic>> commands;
  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView> {
  static int nextId = 0;
  late final String viewId = 'econectiva-space-${nextId++}';
  late final web.HTMLIFrameElement frame;
  late final JSFunction messageListener;
  StreamSubscription<Map<String, dynamic>>? commands;
  @override
  void initState() {
    super.initState();
    frame = web.HTMLIFrameElement()
      ..src = Uri.base
          .resolve('assets/assets/space/index.html?v=presence-regions-2')
          .toString()
      ..title = 'Cockpit da nave Educação OnLIFE'
      ..allow = 'autoplay'
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%';
    ui.platformViewRegistry.registerViewFactory(viewId, (_) => frame);
    messageListener = ((web.MessageEvent event) {
      if (!(event.source?.strictEquals(frame.contentWindow).toDart ?? false) ||
          event.origin != web.window.location.origin) {
        return;
      }
      final raw = event.data;
      if (raw == null || !raw.isA<JSString>()) return;
      try {
        final data = jsonDecode((raw as JSString).toDart);
        if (data is Map<String, dynamic> &&
            data['channel'] == 'econectiva-space') {
          widget.onMessage(data);
        }
      } catch (_) {
        /* Ignore unrelated browser messages. */
      }
    }).toJS;
    web.window.addEventListener('message', messageListener);
    commands = widget.commands.listen((data) {
      if (data['cover'] == true) frame.style.visibility = 'hidden';
      if (data['type'] == 'resume') frame.style.visibility = 'visible';
      frame.contentWindow?.postMessage(
        jsonEncode({...data, 'channel': 'econectiva-space'}).toJS,
        web.window.location.origin.toJS,
      );
    });
  }

  @override
  void dispose() {
    web.window.removeEventListener('message', messageListener);
    commands?.cancel();
    frame.src = 'about:blank';
    frame.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: viewId);
}
