import 'package:unisinos_usp_app/utils/ai_chat_error.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/ai_assistant_message_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/webclients/ai_assistant_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

class AiAssistantController extends GetxController {
  final AiAssistantWebclient _webclient = AiAssistantWebclient();
  final AiAssistantContextService _contextService =
      Get.find<AiAssistantContextService>();

  final RxList<AiAssistantMessageModel> messages =
      <AiAssistantMessageModel>[].obs;
  final RxBool isLoadingHistory = false.obs;
  final RxBool isSending = false.obs;
  final RxBool hasLoadedHistory = false.obs;
  final RxnString errorMessage = RxnString();

  // Kept for callers opening the panel; form values must never be logged.
  void logCurrentContext() {}

  Future<void> ensureHistoryLoaded() async {
    if (hasLoadedHistory.value || isLoadingHistory.value) return;
    await loadHistory();
  }

  Future<void> loadHistory({bool force = false}) async {
    if (isLoadingHistory.value) return;
    if (hasLoadedHistory.value && !force) return;

    try {
      isLoadingHistory.value = true;
      errorMessage.value = null;
      final List<AiAssistantMessageModel> history = await _webclient
          .fetchHistory(limit: 100, offset: 0);
      messages.assignAll(history);
      hasLoadedHistory.value = true;
    } catch (_) {
      errorMessage.value =
          'Não foi possível carregar o histórico do assistente.';
      Get.customSnackbar(
        'Erro',
        'Não foi possível carregar o histórico do assistente.',
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> sendMessage(String value) async {
    final String message = value.trim();
    if (message.isEmpty || isSending.value) return;

    messages.add(
      AiAssistantMessageModel(
        role: 'user',
        content: message,
        createdAt: DateTime.now(),
      ),
    );

    try {
      isSending.value = true;
      errorMessage.value = null;
      final contextData = _contextService.resolveCurrentContext();
      final List<AiAssistantMessageModel> returnedMessages = await _webclient
          .sendMessage(
            message: message,
            context: '',
            screenContext: contextData,
          );

      if (returnedMessages.isEmpty) return;

      for (final item in returnedMessages) {
        final bool alreadyPresent =
            item.id != null && messages.any((msg) => msg.id == item.id);
        if (!alreadyPresent && !item.isUser) {
          messages.add(item);
        }
      }
      hasLoadedHistory.value = true;
    } catch (error) {
      errorMessage.value = aiChatError(error);
      Get.customSnackbar('Erro', errorMessage.value!);
    } finally {
      isSending.value = false;
    }
  }
}
