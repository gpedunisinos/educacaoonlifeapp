import 'package:unisinos_usp_app/widgets/native_webview.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpaceView extends StatefulWidget {
  const SpaceView({super.key, required this.onMessage, required this.commands});
  final void Function(Map<String, dynamic>) onMessage;
  final Stream<Map<String, dynamic>> commands;
  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView> {
  WebViewController? controller;
  StreamSubscription<Map<String, dynamic>>? commands;
  bool failed = false;
  @override
  void initState() {
    super.initState();
    if (![
      TargetPlatform.android,
      TargetPlatform.iOS,
      TargetPlatform.macOS,
    ].contains(defaultTargetPlatform)) {
      return;
    }
    controller = WebViewController()
      ..setBackgroundColor(const Color(0xFF030914))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SpaceBridge',
        onMessageReceived: (message) {
          try {
            final data = jsonDecode(message.message);
            if (data is Map<String, dynamic> &&
                data['channel'] == 'econectiva-space') {
              if (data['type'] == 'ready') _sendEarthTexture();
              widget.onMessage(data);
            }
          } catch (_) {
            /* Only structured scene events are accepted. */
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) =>
              request.url.startsWith('file:') ||
                  request.url.startsWith('about:')
              ? NavigationDecision.navigate
              : NavigationDecision.prevent,
          onWebResourceError: (error) {
            if ((error.isForMainFrame ?? false) && mounted) {
              setState(() => failed = true);
            }
          },
        ),
      );
    controller!.loadFlutterAsset('assets/space/index.html').catchError((
      Object error,
    ) {
      if (mounted) setState(() => failed = true);
    });
    commands = widget.commands.listen((data) {
      controller
          ?.runJavaScript(
            'if (typeof window.receiveSpaceCommand === "function") window.receiveSpaceCommand(${jsonEncode({...data, 'channel': 'econectiva-space'})});',
          )
          .catchError((_) {});
    });
  }

  // WebGL cannot sample file:// images on Android. Deliver this bundled asset
  // as a data URI through our private scene bridge; no file-access relaxation.
  Future<void> _sendEarthTexture() async {
    try {
      final bytes = await rootBundle.load('assets/space/earth.png');
      if (!mounted || controller == null) return;
      final src =
          'data:image/png;base64,${base64Encode(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes))}';
      await controller!.runJavaScript(
        'window.receiveSpaceCommand(${jsonEncode({'channel': 'econectiva-space', 'type': 'earth-texture', 'src': src})});',
      );
    } catch (_) {
      // The scene keeps its simplified globe and the other modules available.
    }
  }

  @override
  void dispose() {
    commands?.cancel();
    controller
        ?.runJavaScript(
          'if (typeof window.receiveSpaceCommand === "function") window.receiveSpaceCommand({type:"pause",channel:"econectiva-space"});',
        )
        .catchError((_) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => controller == null || failed
      ? const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'A experiência espacial precisa de WebGL. Abra a versão web em um navegador atualizado ou volte aos módulos da plataforma.',
              textAlign: TextAlign.center,
            ),
          ),
        )
      : SafeArea(child: nativeWebView(controller!));
}
