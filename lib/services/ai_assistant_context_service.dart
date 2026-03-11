import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';

typedef AiAssistantContextProvider = AiAssistantScreenContext Function();

class AiAssistantContextService extends GetxService {
  AiAssistantContextProvider? _provider;
  String? _providerRoute;
  final RxString currentRoute = ''.obs;

  void registerProvider(String route, AiAssistantContextProvider provider) {
    _provider = provider;
    _providerRoute = route;
  }

  void unregisterProvider(String route, AiAssistantContextProvider provider) {
    if (identical(_provider, provider)) {
      _provider = null;
      _providerRoute = null;
    }
  }

  void setCurrentRoute(String route) {
    currentRoute.value = route;
  }

  AiAssistantScreenContext resolveCurrentContext() {
    final AiAssistantContextProvider? provider = _provider;
    if (provider != null &&
        (_providerRoute == currentRoute.value || _providerRoute == Get.currentRoute)) {
      return provider();
    }

    return AiAssistantScreenContext(
      screenName: 'Tela desconhecida',
      route: currentRoute.value.isEmpty ? Get.currentRoute : currentRoute.value,
      stage: 'navegação',
      goal: 'fornecer ajuda contextual ao usuário',
      notes: const <String>[
        'Nenhum contexto detalhado foi registrado para esta tela.'
      ],
    );
  }
}
