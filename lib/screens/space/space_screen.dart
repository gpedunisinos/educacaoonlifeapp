import 'package:unisinos_usp_app/widgets/participant_chat_panel.dart';
import 'package:unisinos_usp_app/services/participant_chat/participant_chat_service.dart';
import 'package:unisinos_usp_app/services/presence/presence_service.dart';
import 'package:unisinos_usp_app/services/ship_audio_preferences.dart';
import 'package:unisinos_usp_app/models/meeting_room.dart';
import 'package:unisinos_usp_app/screens/space/meeting_room_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/screens/space/space_account_panel.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/controllers/ai_assistant/ai_assistant_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_panel.dart';
import 'package:unisinos_usp_app/screens/space/space_view.dart';

class SpaceScreen extends StatefulWidget {
  const SpaceScreen({super.key});
  @override
  State<SpaceScreen> createState() => _SpaceScreenState();
}

class _SpaceScreenState extends State<SpaceScreen> with WidgetsBindingObserver {
  final commands = StreamController<Map<String, dynamic>>.broadcast();
  final contextService = Get.find<AiAssistantContextService>();
  Worker? presenceWatch;
  Worker? chatWatch;
  bool opening = false;
  bool changingMode = false;
  String destination = 'Terra';
  // Keep the exact callback identity for unregisterProvider.
  late final AiAssistantContextProvider contextProvider = buildContext;
  AiAssistantScreenContext buildContext() => AiAssistantScreenContext(
    screenName: 'Cockpit Educação OnLIFE',
    route: '/space',
    stage: 'exploração espacial',
    goal: 'navegar pelos territórios e módulos com a orientação da Iareté',
    filledFields: {
      'destino selecionado': destination,
      'modo': Get.find<UserController>().user.value?.usageMode == 'inventor'
          ? 'Inventor'
          : 'Explorador',
    },
    notes: [
      'A Terra abre o Mapa de Pistas em tela cheia. A Lua permite pesquisar pistas, o Observatório explorar problemáticas e o Campo de Inteligências selecionar agentes.',
      'Ações autorizadas nesta conta: ${destinations.keys.join(', ')}. O seletor Explorador/Inventor preserva a rota.',
      if (MeetingRoom.enabled)
        'Encontros abre uma sala em outra aba; a Iareté não acompanha seu conteúdo nem a presença.',
    ],
  );
  Map<String, String> get destinations {
    final user = Get.find<UserController>().user.value;
    return {
      if (LivingCluePolicy(user).viewAny()) 'earth': '/living_clues/map',
      if (LivingCluePolicy(user).viewAny()) 'research': '/space/research',
      if (NodePolicy(user).viewAny()) 'observatory': '/nodes/graph',
      if (ChatTemplatePolicy(user).viewAny()) 'agents': '/space/agents',
    };
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Get.isRegistered<PresenceService>()) {
      final presence = Get.find<PresenceService>();
      presenceWatch = everAll([
        presence.available,
        presence.participants,
      ], (_) => send('presence', presence.sceneState));
    }
    if (Get.isRegistered<ParticipantChatService>()) {
      final chats = Get.find<ParticipantChatService>();
      chatWatch = ever(
        chats.unread,
        (_) => send('chat-state', {'unread': chats.unread.value}),
      );
    }
    contextService.registerProvider('/space', contextProvider);
  }

  void send(String type, [Map<String, dynamic> extra = const {}]) {
    if (!commands.isClosed) commands.add({'type': type, ...extra});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The iframe handles document.visibilitychange itself on web. Flutter's
    // focus lifecycle also fires when focus enters a platform view.
    if (kIsWeb || state == AppLifecycleState.inactive) return;
    if (state != AppLifecycleState.resumed) {
      send('pause');
    } else if (!opening) {
      send('resume');
    }
  }

  String get tutorialKey =>
      'space_tutorial_v1_${Get.find<UserController>().user.value?.id}';

  Future<void> onMessage(Map<String, dynamic> data) async {
    if (!mounted) return;
    if (data['type'] == 'presence-location') {
      final region = data['destination'];
      if (region is String && Get.isRegistered<PresenceService>()) {
        Get.find<PresenceService>().cockpitLocation(region);
      }
      return;
    }
    if (data['type'] == 'presence-interaction') {
      if (Get.isRegistered<PresenceService>())
        Get.find<PresenceService>().interact();
      return;
    }
    if (data['type'] == 'participant-chat' || data['type'] == 'conversations') {
      if (opening) return;
      final participant = data['type'] == 'participant-chat'
          ? data['participant']
          : null;
      if (participant != null &&
          (participant is! String ||
              !Get.find<PresenceService>().participants.any(
                (p) =>
                    p.id == participant &&
                    p.id != Get.find<PresenceService>().self,
              )))
        return;
      opening = true;
      send('pause', {'cover': true});
      try {
        await showParticipantChat(context, participant: participant as String?);
      } finally {
        opening = false;
        if (mounted)
          send('resume', {'audioEnabled': ShipAudioPreferences.enabled.value});
      }
      return;
    }
    if (data['type'] == 'audio-state' && data['enabled'] is bool) {
      await ShipAudioPreferences.setEnabled(data['enabled'] as bool);
      return;
    }
    if (data['type'] == 'ready') {
      await ShipAudioPreferences.restore();
      var tutorialSeen = false;
      try {
        tutorialSeen =
            (await SharedPreferences.getInstance()).getBool(tutorialKey) ??
            false;
      } catch (_) {
        /* First-flight guidance remains available without storage. */
      }
      if (!mounted) return;
      if (Get.isRegistered<PresenceService>())
        send('presence', Get.find<PresenceService>().sceneState);
      if (Get.isRegistered<ParticipantChatService>())
        send('chat-state', {
          'unread': Get.find<ParticipantChatService>().unread.value,
        });
      send('configure', {
        'tutorialSeen': tutorialSeen,
        'audioEnabled': ShipAudioPreferences.enabled.value,
        'meetings': MeetingRoom.enabled && MeetingRoom.configured,
        'mode': Get.find<UserController>().user.value?.usageMode,
        'destinations': destinations.keys.toList(),
        'management': ClueConnectionPolicy(
          Get.find<UserController>().user.value,
        ).viewAny(),
      });
      return;
    }
    if (data['type'] == 'change-mode') {
      final mode = data['mode'];
      if (changingMode || opening || !['explorer', 'inventor'].contains(mode))
        return;
      final users = Get.find<UserController>();
      final userId = users.user.value?.id;
      if (userId == null) return;
      changingMode = true;
      String? error;
      try {
        if (users.user.value?.usageMode != mode) {
          await users.chooseMode(mode as String, navigate: false);
        }
      } catch (_) {
        error = 'Não foi possível salvar o modo. Tente novamente.';
      } finally {
        changingMode = false;
        if (mounted && users.user.value?.id == userId) {
          send('mode-state', {
            'mode': users.user.value?.usageMode,
            'error': error,
            'announce': error == null,
          });
        }
      }
      return;
    }
    if (data['type'] == 'tutorial-complete' && data['version'] == 1) {
      try {
        await (await SharedPreferences.getInstance()).setBool(
          tutorialKey,
          true,
        );
      } catch (_) {
        /* Replay remains available if preferences are unavailable. */
      }
      return;
    }
    if (data['type'] == 'select' && data['name'] is String) {
      destination = data['name'] as String;
      return;
    }
    if (opening) return;
    if (data['type'] == 'exit') {
      await openAccount();
      return;
    }
    final meetings =
        data['type'] == 'meetings' &&
        MeetingRoom.enabled &&
        MeetingRoom.configured;
    final management =
        data['type'] == 'management' &&
        ClueConnectionPolicy(Get.find<UserController>().user.value).viewAny();
    final route = management
        ? '/management'
        : destinations[data['destination']];
    if (!management &&
        !meetings &&
        data['type'] != 'assistant' &&
        (data['type'] != 'open' || route == null)) {
      return;
    }
    opening = true;
    send('pause', {'cover': true});
    try {
      if (meetings) {
        await showMeetingRoomDialog(context);
      } else if (data['type'] == 'assistant') {
        final controller = Get.find<AiAssistantController>();
        controller.ensureHistoryLoaded();
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          constraints: const BoxConstraints(maxWidth: 1000),
          backgroundColor: Colors.transparent,
          builder: (_) => const AiAssistantPanel(),
        );
      } else {
        await Get.toNamed(route!, arguments: const {'fromSpace': true});
      }
    } finally {
      opening = false;
      if (mounted) {
        contextService.registerProvider('/space', contextProvider);
        send('resume', {
          'returned': true,
          'audioEnabled': ShipAudioPreferences.enabled.value,
        });
      }
    }
  }

  Future<void> openAccount() async {
    if (opening) return;
    opening = true;
    send('pause', {'cover': true});
    try {
      final action = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const SpaceAccountPanel(),
      );
      if (!mounted) return;
      if (action == 'mode') {
        send('focus-mode');
      } else if (action == 'logout') {
        await Get.find<UserController>().logout();
      }
    } finally {
      opening = false;
      if (mounted)
        send('resume', {
          'returned': true,
          'audioEnabled': ShipAudioPreferences.enabled.value,
        });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    contextService.unregisterProvider('/space', contextProvider);
    presenceWatch?.dispose();
    chatWatch?.dispose();
    commands.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF030914),
    body: SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: SpaceView(onMessage: onMessage, commands: commands.stream),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: IconButton.filledTonal(
              tooltip: 'Conta e modo de navegação',
              onPressed: openAccount,
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF10232D),
                foregroundColor: const Color(0xFFA3EFD9),
              ),
              icon: const Icon(Icons.person_outline),
            ),
          ),
        ],
      ),
    ),
  );
}
