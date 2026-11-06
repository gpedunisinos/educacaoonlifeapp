import 'dart:async';
import 'package:flutter/material.dart';

/// Present a new reply in short bursts. Stored history is always rendered whole.
class IareteReply extends StatefulWidget {
  const IareteReply({
    super.key,
    required this.text,
    required this.animate,
    required this.builder,
    this.reserveCompletionSpace = false,
    this.onType,
    this.onProgress,
    this.onComplete,
  });
  final bool reserveCompletionSpace;
  final String text;
  final bool animate;
  final Widget Function(String visibleText) builder;
  final VoidCallback? onType;
  final VoidCallback? onProgress;
  final VoidCallback? onComplete;
  @override
  State<IareteReply> createState() => _IareteReplyState();
}

class _IareteReplyState extends State<IareteReply> with WidgetsBindingObserver {
  Timer? _timer;
  late List<String> _characters;
  int _visible = 0;
  bool _reported = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _reset();
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;
    _characters = widget.text.characters.toList(growable: false);
    _visible = widget.animate ? 0 : _characters.length;
    _reported = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _start();
  }

  @override
  void didUpdateWidget(IareteReply oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.animate != widget.animate) {
      _reset();
      _start();
    }
  }

  void _start() {
    if (!widget.animate ||
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.of(context).accessibleNavigation) {
      _timer?.cancel();
      _timer = null;
      _visible = _characters.length;
      _report();
      return;
    }
    if (_visible >= _characters.length) {
      _report();
      return;
    }
    _timer ??= Timer(const Duration(milliseconds: 24), _step);
  }

  void _step() {
    _timer = null;
    if (!mounted) return;
    setState(() => _visible = (_visible + 3).clamp(0, _characters.length));
    final char = _characters[_visible - 1];
    if (char.trim().isNotEmpty) widget.onType?.call();
    widget.onProgress?.call();
    if (_visible >= _characters.length) {
      _report();
      return;
    }
    _timer = Timer(
      Duration(milliseconds: RegExp(r'[.,?!]').hasMatch(char) ? 140 : 24),
      _step,
    );
  }

  void _report() {
    if (_reported || !widget.animate) return;
    _reported = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onComplete?.call();
    });
  }

  void _finish() {
    _timer?.cancel();
    _timer = null;
    if (!mounted) return;
    setState(() => _visible = _characters.length);
    widget.onProgress?.call();
    _report();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached)
      _finish();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      widget.builder(_characters.take(_visible).join()),
      if (_visible < _characters.length || widget.reserveCompletionSpace)
        SizedBox(
          height: widget.reserveCompletionSpace ? 48 : null,
          child: _visible < _characters.length
              ? TextButton.icon(
                  onPressed: _finish,
                  icon: const Icon(Icons.fast_forward, size: 15),
                  label: const Text('Exibir resposta completa'),
                )
              : const SizedBox.shrink(),
        ),
    ],
  );
}
