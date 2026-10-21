import 'package:unisinos_usp_app/services/ship_audio_preferences.dart';
import 'package:unisinos_usp_app/services/iarete_audio/typing_audio.dart';
import 'package:unisinos_usp_app/widgets/iarete_reply.dart';
import 'package:unisinos_usp_app/widgets/space_conversation.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:unisinos_usp_app/utils/ai_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/ai_assistant/ai_assistant_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_message_model.dart';

class AiAssistantPanel extends StatefulWidget {
  const AiAssistantPanel({super.key});

  @override
  State<AiAssistantPanel> createState() => _AiAssistantPanelState();
}

class _AiAssistantPanelState extends State<AiAssistantPanel> {
  final AiAssistantController _controller = Get.find<AiAssistantController>();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  late final Worker _worker;
  final _typingAudio = TypingAudio();
  bool _historyReady = false;
  final Set<Object> _seenReplies = {};
  Object _messageKey(AiAssistantMessageModel message) => message.id ?? message;
  AiAssistantMessageModel? _revealing;

  @override
  void initState() {
    super.initState();
    _worker = ever<List<AiAssistantMessageModel>>(_controller.messages, (
      messages,
    ) {
      if (_historyReady &&
          messages.isNotEmpty &&
          !messages.last.isUser &&
          !_seenReplies.contains(_messageKey(messages.last))) {
        setState(() => _revealing = messages.last);
      }
      _seenReplies.addAll(messages.map(_messageKey));
      _scrollToBottom();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePanel();
    });
  }

  @override
  void dispose() {
    _worker.dispose();
    _typingAudio.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Theme(
      data: spaceRecordTheme(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, bottomInset + 12),
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 760),
              child: SpaceConversationSurface(
                child: Column(
                  children: [
                    SpaceConversationHeader(
                      title: const Text('Iareté'),
                      eyebrow: 'EC–01 / INTELIGÊNCIA DE BORDO',
                      iarete: true,
                      subtitle: Obx(
                        () => Semantics(
                          liveRegion: true,
                          child: Text(
                            _controller.isSending.value
                                ? 'Elaborando uma resposta…'
                                : 'Sua inteligência de bordo para explorar a Educação OnLIFE.',
                          ),
                        ),
                      ),
                      actions: [
                        ValueListenableBuilder<bool>(
                          valueListenable: ShipAudioPreferences.enabled,
                          builder: (_, enabled, _) => IconButton(
                            tooltip: enabled
                                ? 'Silenciar Iareté'
                                : 'Ativar som da Iareté',
                            icon: Icon(
                              enabled
                                  ? Icons.volume_up_outlined
                                  : Icons.volume_off_outlined,
                            ),
                            onPressed: () {
                              ShipAudioPreferences.setEnabled(!enabled);
                              if (!enabled) _typingAudio.prepare();
                            },
                          ),
                        ),
                        IconButton(
                          tooltip: 'Fechar Iareté',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: spaceChatMuted),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Obx(() {
                        if (_controller.isLoadingHistory.value &&
                            _controller.messages.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: spaceChatAccent,
                            ),
                          );
                        }
                        if (_controller.messages.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(28),
                              child: Text(
                                _controller.errorMessage.value ??
                                    'Olá, sou a Iareté, sua inteligência de bordo. O que vamos explorar juntos?',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: spaceChatMuted,
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                          itemCount: _controller.messages.length,
                          itemBuilder: (_, index) {
                            final message = _controller.messages[index];
                            return _MessageBubble(
                              message: message,
                              animate: identical(_revealing, message),
                              onType: () {
                                if (ShipAudioPreferences.enabled.value)
                                  _typingAudio.tick();
                              },
                              onProgress: _followReply,
                              onComplete: () {
                                if (mounted && identical(_revealing, message)) {
                                  setState(() => _revealing = null);
                                }
                              },
                            );
                          },
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                        decoration: spaceChatComposer(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Focus(
                                onKeyEvent: (node, event) {
                                  if (event is KeyDownEvent &&
                                      event.logicalKey ==
                                          LogicalKeyboardKey.enter &&
                                      !HardwareKeyboard
                                          .instance
                                          .isShiftPressed) {
                                    _submit();
                                    return KeyEventResult.handled;
                                  }
                                  return KeyEventResult.ignored;
                                },
                                child: TextField(
                                  focusNode: _inputFocusNode,
                                  controller: _textController,
                                  minLines: 1,
                                  maxLines: 4,
                                  textInputAction: TextInputAction.send,
                                  style: const TextStyle(
                                    color: spaceChatText,
                                    height: 1.45,
                                  ),
                                  cursorColor: spaceChatAccent,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Pergunte algo sobre a tela atual...',
                                    hintStyle: TextStyle(color: spaceChatMuted),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    filled: false,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                  onSubmitted: (_) => _submit(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: spaceChatAccent,
                                  foregroundColor: const Color(0xFF06202A),
                                  minimumSize: const Size(64, 44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _controller.isSending.value
                                    ? null
                                    : _submit,
                                child: _controller.isSending.value
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: spaceChatAccent,
                                          semanticsLabel: 'Enviando mensagem',
                                        ),
                                      )
                                    : const Text('Enviar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final String value = _textController.text.trim();
    if (value.isEmpty || _controller.isSending.value) return;
    if (ShipAudioPreferences.enabled.value) _typingAudio.prepare();
    setState(() => _revealing = null);
    _textController.clear();
    _controller.sendMessage(value);
  }

  Future<void> _initializePanel() async {
    await ShipAudioPreferences.restore();
    await _controller.ensureHistoryLoaded();
    if (!mounted) return;
    _seenReplies.addAll(_controller.messages.map(_messageKey));
    _historyReady = true;
    _scrollToBottom(animated: false);
  }

  void _followReply() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _scrollController.hasClients &&
          _scrollController.position.extentAfter < 160) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final double offset = _scrollController.position.maxScrollExtent;
      if (animated) {
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
        return;
      }
      _scrollController.jumpTo(offset);
    });
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    this.animate = false,
    this.onType,
    this.onProgress,
    this.onComplete,
  });
  final bool animate;
  final VoidCallback? onType, onProgress, onComplete;

  final AiAssistantMessageModel message;

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: DecoratedBox(
              decoration: spaceChatBubble(isUser),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUser ? 'VOCÊ' : 'IARETÉ',
                      style: const TextStyle(
                        color: spaceChatAccent,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isUser)
                      Text(
                        message.content,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.35,
                        ),
                      )
                    else
                      IareteReply(
                        text: message.content,
                        animate: animate,
                        onType: onType,
                        onProgress: onProgress,
                        onComplete: onComplete,
                        builder: (visibleText) => Semantics(
                          label: visibleText,
                          child: MarkdownBody(
                            data: visibleText,
                            selectable: true,
                            styleSheet:
                                MarkdownStyleSheet.fromTheme(
                                  Theme.of(context),
                                ).copyWith(
                                  p: const TextStyle(
                                    color: Colors.white,
                                    height: 1.45,
                                  ),
                                  code: const TextStyle(
                                    color: Color(0xFFD9F5F2),
                                    backgroundColor: Color(0xFF152E38),
                                    fontFamily: 'monospace',
                                  ),
                                  listBullet: const TextStyle(
                                    color: Color(0xFF9CE7DF),
                                  ),
                                  a: const TextStyle(
                                    color: Color(0xFF9CE7DF),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                            sizedImageBuilder: (_) => const Text(
                              '[Imagem externa — abra a referência para visualizar]',
                            ),
                            onTapLink: (_, href, _) => openAiReference(
                              href,
                              beforeNavigate: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(color: spaceChatMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final String hour = local.hour.toString().padLeft(2, '0');
    final String minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
