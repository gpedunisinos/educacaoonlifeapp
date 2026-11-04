import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/webclients/econectiva_webclient.dart';

/// Sends moderation requests to the authenticated backend; see docs/moderacao.md.
class ModerationActions {
  static Future<void> report(
    BuildContext context, {
    required String conversationId,
    EconectivaApi? api,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Denunciar conversa?'),
        content: const Text('A conversa será enviada para análise.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Denunciar conversa'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await (api ?? EconectivaApi()).write(
        'POST',
        '/me/conversations/${Uri.encodeComponent(conversationId)}/report',
        {},
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Denúncia enviada para análise.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível enviar a denúncia. Tente novamente.',
            ),
          ),
        );
      }
    }
  }

  static Future<bool> block(
    BuildContext context, {
    required String conversationId,
    bool unblock = false,
    EconectivaApi? api,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(unblock ? 'Desbloquear conversa?' : 'Bloquear conversa?'),
        content: Text(
          unblock
              ? 'Vocês poderão voltar a enviar mensagens.'
              : 'Nenhum dos participantes poderá enviar mensagens nesta conversa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(unblock ? 'Desbloquear' : 'Bloquear'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return false;
    try {
      final client = api ?? EconectivaApi();
      final path =
          '/me/conversations/${Uri.encodeComponent(conversationId)}/block';
      if (unblock) {
        await client.write('DELETE', path);
      } else {
        await client.postEmpty(path);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              unblock ? 'Conversa desbloqueada.' : 'Conversa bloqueada.',
            ),
          ),
        );
      }
      return true;
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              unblock
                  ? 'Não foi possível desbloquear a conversa. Tente novamente.'
                  : 'Não foi possível bloquear a conversa. Tente novamente.',
            ),
          ),
        );
      }
      return false;
    }
  }
}
