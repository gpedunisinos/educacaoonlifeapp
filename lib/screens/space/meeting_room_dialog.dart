import 'dart:math';
import 'package:unisinos_usp_app/services/meeting_window.dart';
import 'package:unisinos_usp_app/webclients/meeting_webclient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unisinos_usp_app/models/meeting_room.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';

Future<void> showMeetingRoomDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) =>
      Theme(data: spaceRecordTheme(), child: const MeetingRoomDialog()),
);

class MeetingRoomDialog extends StatefulWidget {
  const MeetingRoomDialog({super.key, this.onOpen, this.onAuthorize});
  final Future<bool> Function(Uri)? onOpen;
  final Future<Uri> Function(MeetingRoom)? onAuthorize;
  @override
  State<MeetingRoomDialog> createState() => _MeetingRoomDialogState();
}

class _MeetingRoomDialogState extends State<MeetingRoomDialog> {
  final input = TextEditingController();
  final focus = FocusNode();
  String? error;
  bool opening = false;
  @override
  void dispose() {
    input.dispose();
    focus.dispose();
    super.dispose();
  }

  MeetingRoom? validate() {
    try {
      final room = MeetingRoom.parse(input.text);
      setState(() => error = null);
      return room;
    } on FormatException catch (failure) {
      setState(() => error = failure.message);
      return null;
    }
  }

  Future<void> open() async {
    if (opening) return;
    final room = validate();
    if (room == null) return;
    setState(() => opening = true);
    MeetingWindow? window;
    try {
      // Tests inject a launcher. In web reserve before awaiting the API.
      if (widget.onOpen == null) {
        window = MeetingWindow.reserve();
        if (window == null) {
          setState(
            () => error =
                'Não foi possível preparar a abertura do encontro. Tente novamente.',
          );
          return;
        }
      }
      final uri =
          await (widget.onAuthorize?.call(room) ??
              MeetingWebclient().authorize(room));
      if (!mounted) {
        window?.close();
        return;
      }
      final launched = widget.onOpen != null
          ? await widget.onOpen!(uri)
          : await window!.navigate(uri);
      if (!mounted) return;
      if (launched) {
        Navigator.of(context).pop();
        return;
      }
      window?.close();
      setState(
        () => error =
            'Não foi possível abrir o encontro. Tente novamente ou copie o link da sala.',
      );
    } catch (_) {
      window?.close();
      if (mounted)
        setState(
          () => error =
              'Não foi possível autorizar ou abrir o encontro. Sua sala foi preservada; tente novamente.',
        );
    } finally {
      if (mounted) setState(() => opening = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: const Row(
      children: [
        Icon(Icons.video_call_outlined, color: Color(0xFF9CE7DF)),
        SizedBox(width: 10),
        Expanded(child: Text('Encontros')),
      ],
    ),
    content: SizedBox(
      width: 480,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Conecte-se a uma sala e retorne à nave quando desejar.'),
          const SizedBox(height: 18),
          TextField(
            controller: input,
            focusNode: focus,
            autofocus: true,
            maxLength: 2000,
            enabled: !opening,
            decoration: InputDecoration(
              labelText: 'Nome da sala ou link de convite',
              hintText: 'Encontro da comunidade',
              errorText: error,
              errorMaxLines: 4,
              counterText: '',
            ),
            textInputAction: TextInputAction.go,
            onSubmitted: (_) => open(),
            onChanged: (_) {
              if (error != null) setState(() => error = null);
            },
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: opening
                ? null
                : () {
                    final random = Random.secure();
                    input.text =
                        'encontro-onlife-${List.generate(8, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join()}';
                    setState(() => error = null);
                    focus.requestFocus();
                  },
            icon: const Icon(Icons.auto_awesome_outlined, size: 17),
            label: const Text('Gerar nome de sala'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sua conta da Educação OnLIFE autoriza o início do encontro, sem outro login. Compartilhe o convite para receber outras pessoas após sua entrada.',
            style: TextStyle(color: Color(0xFFB1C6D1), height: 1.5),
          ),
          const SizedBox(height: 8),
          const Text(
            'A conversa e a presença no encontro não são adicionadas às pistas nem à IAraeté.',
            style: TextStyle(
              color: Color(0xFF91ADB9),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: opening ? null : () => Navigator.of(context).pop(),
        child: const Text('Voltar'),
      ),
      TextButton.icon(
        onPressed: opening
            ? null
            : () async {
                final room = validate();
                if (room == null) return;
                await Clipboard.setData(
                  ClipboardData(text: room.uri.toString()),
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link da sala copiado.')),
                );
              },
        icon: const Icon(Icons.copy_outlined, size: 16),
        label: const Text('Copiar link'),
      ),
      FilledButton.icon(
        onPressed: opening ? null : open,
        icon: const Icon(Icons.open_in_new, size: 17),
        label: Text(opening ? 'Abrindo…' : 'Entrar na sala'),
      ),
    ],
  );
}
