import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
import 'package:unisinos_usp_app/services/participant_chat/participant_chat_service.dart';

Future<void> showParticipantChat(
  BuildContext context, {
  String? participant,
}) async {
  if (!Get.isRegistered<ParticipantChatService>()) return;
  final navigator = Navigator.maybeOf(context) ?? Get.key.currentState;
  if (navigator == null) return;
  final service = Get.find<ParticipantChatService>();
  if (service.panelOpen) return;
  service.panelOpen = true;
  if (participant != null) {
    service.inbox();
    service.openParticipant(participant);
  } else {
    service.inbox();
  }
  try {
    await showDialog<void>(
      context: navigator.context,
      barrierColor: Colors.black54,
      builder: (context) {
        final size = MediaQuery.sizeOf(context);
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: SizedBox(
            width: math.min(520, size.width - 24),
            height: size.height - 48,
            child: ParticipantChatPanel(service: service),
          ),
        );
      },
    );
  } finally {
    service.panelOpen = false;
  }
}

class ParticipantChatButton extends StatelessWidget {
  const ParticipantChatButton({super.key});
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ParticipantChatService>())
      return const SizedBox.shrink();
    final service = Get.find<ParticipantChatService>();
    return Obx(
      () => IconButton(
        tooltip: 'Conversas entre participantes',
        onPressed: () => showParticipantChat(context),
        icon: Badge(
          isLabelVisible: service.unread.value > 0,
          label: Text('${service.unread.value}'),
          child: const Icon(
            Icons.chat_bubble_outline,
            color: Color(0xFF9CE7DF),
            size: 19,
          ),
        ),
      ),
    );
  }
}

class ParticipantChatPanel extends StatelessWidget {
  const ParticipantChatPanel({super.key, required this.service});
  final ParticipantChatService service;
  @override
  Widget build(BuildContext context) => Theme(
    data: spaceRecordTheme(),
    child: Material(
      color: const Color(0xFF081723),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF37616F)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Obx(() {
        final c = service.active.value;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
              child: Row(
                children: [
                  if (c != null)
                    IconButton(
                      tooltip: 'Voltar às conversas',
                      onPressed: service.inbox,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF9CE7DF),
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.forum_outlined,
                        color: Color(0xFF9CE7DF),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c?.name ?? 'Conversas da expedição',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c == null
                              ? 'Encontros em texto e emojis'
                              : c.activity,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFA5C6D3),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fechar conversas',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (service.account == null)
              const Expanded(
                child: Center(
                  child: Text('Entre na plataforma para conversar.'),
                ),
              )
            else if (c != null)
              Expanded(
                child: _ParticipantConversationPane(
                  key: ValueKey('${service.account!.id}:${c.id}'),
                  service: service,
                  conversation: c,
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    if (service.error.value != null)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextButton.icon(
                          onPressed: () => service.refreshInbox(),
                          icon: const Icon(Icons.refresh),
                          label: Text(service.error.value!),
                        ),
                      ),
                    Expanded(
                      child: service.loading.value
                          ? const Center(child: CircularProgressIndicator())
                          : service.conversations.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'Suas conversas aparecem aqui. Selecione uma nave ou uma pessoa online para começar.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  service.conversations.length +
                                  (service.moreInbox ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == service.conversations.length)
                                  return TextButton(
                                    onPressed: () =>
                                        service.refreshInbox(more: true),
                                    child: const Text(
                                      'Carregar mais conversas',
                                    ),
                                  );
                                final item = service.conversations[index];
                                return ListTile(
                                  onTap: () => service.select(item),
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF163544),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: item.online
                                          ? const Color(0xFF9CE7DF)
                                          : const Color(0xFF92A5B4),
                                    ),
                                  ),
                                  title: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    item.preview.isEmpty
                                        ? item.activity
                                        : item.preview,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: item.unread > 0
                                      ? Badge(label: Text('${item.unread}'))
                                      : null,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    ),
  );
}

class _ParticipantConversationPane extends StatefulWidget {
  const _ParticipantConversationPane({
    super.key,
    required this.service,
    required this.conversation,
  });
  final ParticipantChatService service;
  final ParticipantConversation conversation;
  @override
  State<_ParticipantConversationPane> createState() =>
      _ParticipantConversationPaneState();
}

class _ParticipantConversationPaneState
    extends State<_ParticipantConversationPane> {
  late final epoch = widget.service.accountGeneration;
  late final text = TextEditingController(
    text: widget.service.drafts[widget.conversation.id] ?? '',
  );
  final focus = FocusNode();
  bool emojis = false;
  @override
  void dispose() {
    text.dispose();
    focus.dispose();
    super.dispose();
  }

  Future<void> send() async {
    final original = text.text;
    if (original.trim().isEmpty) return;
    if (original.runes.length > 2000) {
      widget.service.messageError.value =
          'Use até 2.000 caracteres de texto ou emojis.';
      return;
    }
    final sent = await widget.service.send(original);
    if (!mounted || epoch != widget.service.accountGeneration) return;
    if (sent && text.text == original) {
      text.clear();
      widget.service.drafts.remove(widget.conversation.id);
    }
    focus.requestFocus();
  }

  void emoji(String value) {
    final selection = text.selection;
    final start = selection.isValid ? selection.start : text.text.length;
    final end = selection.isValid ? selection.end : start;
    text.value = TextEditingValue(
      text: text.text.replaceRange(start, end, value),
      selection: TextSelection.collapsed(offset: start + value.length),
    );
    widget.service.drafts[widget.conversation.id] = text.text;
    focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) => Obx(
    () => Column(
      children: [
        Expanded(
          child: widget.service.loadingMessages.value
              ? const Center(child: CircularProgressIndicator())
              : widget.service.texts.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Comece com uma mensagem. Esta conversa é entre vocês.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      widget.service.texts.length +
                      (widget.service.moreMessages ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == widget.service.texts.length)
                      return TextButton(
                        onPressed: () =>
                            widget.service.loadMessages(older: true),
                        child: const Text('Carregar mensagens anteriores'),
                      );
                    final message = widget
                        .service
                        .texts[widget.service.texts.length - 1 - index];
                    final at = message.createdAt;
                    return Align(
                      alignment: message.own
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * .72,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: message.own
                              ? const Color(0xFF164B50)
                              : const Color(0xFF132B3A),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: message.own
                                ? const Color(0xFF568D8D)
                                : const Color(0xFF284B60),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Semantics(
                              container: true,
                              label:
                                  '${message.own ? 'Você' : widget.conversation.name}: ${message.text}',
                              child: ExcludeSemantics(
                                child: SelectableText(
                                  message.text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ),
                            if (at != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  '${at.day.toString().padLeft(2, '0')}/${at.month.toString().padLeft(2, '0')} · ${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFAAC5CB),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (widget.service.messageError.value != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.service.messageError.value!,
                    style: const TextStyle(
                      color: Color(0xFFFFC5B5),
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Atualizar mensagens',
                  onPressed: () => widget.service.loadMessages(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        if (emojis)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              spacing: 2,
              children: [
                for (final value in [
                  '😊',
                  '👍',
                  '✨',
                  '🚀',
                  '🌱',
                  '💡',
                  '❤️',
                  '🤝',
                  '🌍',
                  '🎉',
                  '🙏',
                  '👀',
                ])
                  TextButton(
                    onPressed: () => emoji(value),
                    child: Text(value, style: const TextStyle(fontSize: 23)),
                  ),
              ],
            ),
          ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'Escolher emoji',
                onPressed: () => setState(() => emojis = !emojis),
                icon: const Icon(
                  Icons.emoji_emotions_outlined,
                  color: Color(0xFF9CE7DF),
                ),
              ),
              Expanded(
                child: CallbackShortcuts(
                  bindings: {
                    const SingleActivator(LogicalKeyboardKey.enter): send,
                  },
                  child: TextField(
                    controller: text,
                    focusNode: focus,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: 2000,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => send(),
                    onChanged: (value) {
                      if (epoch == widget.service.accountGeneration)
                        widget.service.drafts[widget.conversation.id] = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Escreva uma mensagem…',
                      counterStyle: TextStyle(fontSize: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Enviar mensagem',
                onPressed: widget.service.sending.value ? null : send,
                icon: widget.service.sending.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
