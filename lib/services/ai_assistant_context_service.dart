import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';

typedef AiAssistantContextProvider = AiAssistantScreenContext Function();

class AiAssistantContextService extends GetxService {
  final Map<String, List<AiAssistantContextProvider>> _providers = {};
  final RxString currentRoute = ''.obs;

  String _routeKey(String route) {
    final uri = Uri.tryParse(route);
    if (uri == null) return route;
    final keys = uri.queryParametersAll.keys.toList()..sort();
    return Uri(
      path: uri.path,
      queryParameters: keys.isEmpty
          ? null
          : {for (final key in keys) key: uri.queryParametersAll[key]!},
    ).toString();
  }

  void registerProvider(String route, AiAssistantContextProvider provider) {
    final providers = _providers.putIfAbsent(_routeKey(route), () => []);
    // Rebuilding a covered screen must not promote it above an open overlay.
    if (!providers.any((item) => item == provider)) providers.add(provider);
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
    final exact = _providers[_routeKey(route)];
    // Generic screen providers may serve query variants, but a provider owned
    // by another record's query must never supply its draft or references.
    final providers = exact ?? _providers[Uri.tryParse(route)?.path ?? route];
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
