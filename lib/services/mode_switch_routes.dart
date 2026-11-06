/// Switching mode is safe only on consultation screens, never inside a form.
bool canSwitchModeOnRoute(String route) {
  final path = route.split('?').first;
  if (RegExp(
    r'/(create|update|connect|pre_create|type_select)(/|$)',
  ).hasMatch(path))
    return false;
  return const {
        '/home',
        '/space',
        '/space/research',
        '/space/agents',
        '/living_clues',
        '/living_clues/map',
        '/living_clues/show',
        '/nodes',
        '/nodes/graph',
        '/chat_templates/chat',
      }.contains(path) ||
      RegExp(r'^/space/(research|agents)/\d+$').hasMatch(path) ||
      RegExp(r'^/living_clues/\d+$').hasMatch(path);
}
