import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';

class AiAssistantContextBuilder {
  static String build(AiAssistantScreenContext context) {
    final StringBuffer buffer = StringBuffer()
      ..writeln('Tela: ${context.screenName}')
      ..writeln('Rota: ${context.route}')
      ..writeln('Etapa: ${context.stage}')
      ..writeln('Objetivo: ${context.goal}');

    if (context.visibleFields.isNotEmpty) {
      buffer.writeln('Campos visíveis: ${context.visibleFields.join(', ')}');
    }

    if (context.filledFields.isNotEmpty) {
      buffer.writeln('Campos preenchidos:');
      context.filledFields.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
    }

    if (context.notes.isNotEmpty) {
      buffer.writeln('Observações relevantes:');
      for (final note in context.notes) {
        buffer.writeln('- $note');
      }
    }

    return buffer.toString().trim();
  }
}
