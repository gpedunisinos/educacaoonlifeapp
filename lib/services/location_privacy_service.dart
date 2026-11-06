import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPrivacyService {
  static const String acknowledgementKey =
      'living_clue_location_privacy_acknowledged';

  static Future<bool> ensureAcknowledged(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getBool(acknowledgementKey) ?? false) {
      return true;
    }

    if (!context.mounted) return false;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.privacy_tip_outlined, size: 36),
        title: const Text('Proteja sua localização'),
        content: const Text(
          'Não marque sua casa ou sua localização exata. Prefira um ponto '
          'público, conhecido ou aproximado que represente o local da pista '
          'sem expor dados pessoais.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Entendi, continuar'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await preferences.setBool(acknowledgementKey, true);
      return true;
    }

    return false;
  }
}
