import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:unisinos_usp_app/models/chat_message_model.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:widgets_spo/services/services.dart';

class ChatAgentWebClient extends WebClientBase {
  ChatAgentWebClient._();

  static final ChatAgentWebClient _instance = ChatAgentWebClient._();
  static ChatAgentWebClient get instance => _instance;

  @override
  String get host => 'agent.uniusp.gpedu.com.br';

  @override
  String get basePath => '';
}

class ChatWebclient {
  final ChatAgentWebClient _webClient = ChatAgentWebClient.instance;

  Future<String> sendMessage({
    required String message,
    AuthUser? user,
    String? fileUrl,
  }) async {
    final Map<String, dynamic> payload = {
      'message': message,
      if (fileUrl != null && fileUrl.isNotEmpty) 'file_url': fileUrl,
      if (user != null) ...{
        'user_id': user.id,
        'user_name': user.name,
        'user_global_name': user.email,
      },
    };

    final Response response = await _webClient.post(
      '/platform/chat',
      jsonEncode(payload),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
    );

    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    final String? reply = responseBody['reply']?.toString();
    if (reply == null || reply.isEmpty) {
      throw Exception('Resposta inválida do chat.');
    }

    return reply;
  }

  Future<List<ChatMessageModel>> fetchHistory({int limit = 50}) async {
    final Response response = await _webClient.get(
      '/platform/chat/history',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
      {
        'limit': limit.toString(),
      },
    );

    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    final List<dynamic> items = responseBody['messages'] as List<dynamic>? ?? [];
    return items.map((item) => ChatMessageModel.fromHistoryJson(item as Map<String, dynamic>)).toList();
  }
}
