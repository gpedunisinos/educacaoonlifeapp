import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/models/file_model.dart';
import 'package:unisinos_usp_app/services/attachment_window.dart';
import 'package:unisinos_usp_app/webclients/file_webclient.dart';
import 'package:url_launcher/url_launcher.dart';

/// Requests a fresh download link on every click, never persisting signed URLs.
class ClueAttachmentTile extends StatefulWidget {
  const ClueAttachmentTile({
    super.key,
    required this.file,
    this.onRemove,
    this.client,
  });
  final FileModel file;
  final VoidCallback? onRemove;
  final FileWebclient? client;
  @override
  State<ClueAttachmentTile> createState() => _ClueAttachmentTileState();
}

class _ClueAttachmentTileState extends State<ClueAttachmentTile> {
  bool opening = false;
  Future<void> open() async {
    if (opening) return;
    final window = AttachmentWindow.reserve();
    setState(() => opening = true);
    try {
      final uri = await (widget.client ?? FileWebclient()).access(
        widget.file.id,
      );
      if (window?.navigate(uri) != true &&
          !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw const AttachmentException(
          'Não foi possível abrir o arquivo. Verifique o bloqueio de novas janelas.',
        );
      }
    } catch (error) {
      window?.close();
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is AttachmentException
                  ? error.message
                  : 'Não foi possível acessar o arquivo. Tente novamente.',
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.file;
    final size = file.size;
    final sizeLabel = size == null || size <= 0
        ? null
        : size < 1024
        ? '$size bytes'
        : size < 1024 * 1024
        ? '${(size / 1024).toStringAsFixed(1)} KB'
        : '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
    return ListTile(
      leading: Icon(
        file.extension == 'link'
            ? Icons.link
            : Icons.insert_drive_file_outlined,
        color: const Color(0xFF9CE7DF),
      ),
      title: Text(
        file.name ?? 'Arquivo da pista',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        sizeLabel != null
            ? '${file.extension.toUpperCase()} · $sizeLabel'
            : file.extension.toUpperCase(),
      ),
      onTap: opening ? null : open,
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (opening)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              tooltip: 'Acessar arquivo',
              onPressed: open,
              icon: const Icon(Icons.open_in_new),
            ),
          if (widget.onRemove != null)
            IconButton(
              tooltip: 'Remover arquivo',
              onPressed: opening ? null : widget.onRemove,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
    );
  }
}
