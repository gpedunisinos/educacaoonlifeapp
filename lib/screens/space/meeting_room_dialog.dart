import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unisinos_usp_app/models/meeting_room.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';

Future<void> showMeetingRoomDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) =>
      Theme(data: spaceRecordTheme(), child: const MeetingRoomDialog()),
);

class MeetingRoomDialog extends StatefulWidget {
  const MeetingRoomDialog({super.key, this.onOpen});
  final Future<bool> Function(Uri)? onOpen;
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
    try {
      // No network request before opening: this remains a direct user gesture.
      final launched =
          await (widget.onOpen?.call(room.uri) ??
              launchUrl(room.uri, webOnlyWindowName: '_blank'));
      if (!mounted) return;
      if (launched) {
        Navigator.of(context).pop();
        return;
      }
      setState(
        () => error =
            'O navegador não abriu a nova aba. Permita a abertura ou copie o link da sala.',
      );
    } catch (_) {
      if (mounted)
        setState(
          () => error =
              'Não foi possível abrir o encontro. Você pode copiar o link e tentar novamente.',
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
          const Text(
            'Abra uma sala em outra aba e continue explorando a nave durante o encontro.',
          ),
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
            'Quem organiza inicia a sala com sua conta do encontro. Convidados entram pelo convite após a chegada de quem organiza.',
            style: TextStyle(color: Color(0xFFB1C6D1), height: 1.5),
          ),
          const SizedBox(height: 8),
          const Text(
            'A conversa e a presença no encontro não são adicionadas às pistas nem à Iareté.',
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
