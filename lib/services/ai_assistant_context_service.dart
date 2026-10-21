import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';

typedef AiAssistantContextProvider = AiAssistantScreenContext Function();

class AiAssistantContextService extends GetxService {
  final Map<String, List<AiAssistantContextProvider>> _providers = {};
  final RxString currentRoute = ''.obs;

  String _routeKey(String route) => Uri.tryParse(route)?.path ?? route;

  void registerProvider(String route, AiAssistantContextProvider provider) {
    final providers = _providers.putIfAbsent(_routeKey(route), () => []);
    providers.removeWhere((item) => item == provider);
    providers.add(provider);
  }

  void unregisterProvider(String route, AiAssistantContextProvider provider) {
    final key = _routeKey(route);
    final providers = _providers[key];
    providers?.removeWhere((item) => item == provider);
    if (providers?.isEmpty == true) _providers.remove(key);
  }

  void setCurrentRoute(String route) {
    // Dialogs and sheets retain the originating route and its live provider.
    if (route.isNotEmpty) currentRoute.value = route;
  }

  AiAssistantScreenContext resolveCurrentContext() {
    final route = currentRoute.value.isEmpty
        ? Get.currentRoute
        : currentRoute.value;
    final providers = _providers[_routeKey(route)];
    if (providers != null && providers.isNotEmpty) return providers.last();

    return AiAssistantScreenContext(
      screenName: 'Tela desconhecida',
      route: currentRoute.value.isEmpty ? Get.currentRoute : currentRoute.value,
      stage: 'navegação',
      goal: 'fornecer ajuda contextual ao usuário',
      notes: const <String>[
        'Nenhum contexto detalhado foi registrado para esta tela.',
      ],
    );
  }
}
