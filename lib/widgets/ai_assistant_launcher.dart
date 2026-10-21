import 'package:unisinos_usp_app/services/mode_switch_routes.dart';
import 'package:unisinos_usp_app/screens/management/management_shell.dart';
import 'package:unisinos_usp_app/policies/clue_connection_policy.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/ai_assistant/ai_assistant_controller.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_panel.dart';
import 'package:unisinos_usp_app/widgets/locker_panel.dart';

class AiAssistantLauncher extends StatefulWidget {
  const AiAssistantLauncher({super.key, required this.child});
  final Widget child;
  static final RxString activeRoute = ''.obs;
  static final modeOverlayBlocked = false.obs;
  static void didNavigate(Routing? routing) {
    final route = routing?.current ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (route.isNotEmpty) activeRoute.value = route;
      modeOverlayBlocked.value =
          routing?.isDialog == true || routing?.isBottomSheet == true;
      if (Get.isRegistered<AiAssistantContextService>())
        Get.find<AiAssistantContextService>().setCurrentRoute(route);
    });
  }

  static final RxDouble _bottomOffset = 24.0.obs;
  static void useRaisedPosition() => _bottomOffset.value = 104;
  static void useDefaultPosition() => _bottomOffset.value = 24;
  @override
  State<AiAssistantLauncher> createState() => _AiAssistantLauncherState();
}

class _AiAssistantLauncherState extends State<AiAssistantLauncher> {
  final modeFocus = FocusNode();
  final modeTooltip = GlobalKey<TooltipState>();
  bool expanded = false;
  @override
  void dispose() {
    modeFocus.dispose();
    super.dispose();
  }

  Future<void>? panelFuture;
  bool changingMode = false;
  Future<void> chooseMode() async {
    modeFocus.unfocus();
    Tooltip.dismissAllToolTips();
    final previous = panelFuture;
    if (previous != null) {
      final ctx = Get.key.currentContext ?? Get.overlayContext;
      if (ctx != null) {
        Navigator.of(ctx).pop();
        await previous;
      }
    }
    if (!mounted ||
        changingMode ||
        !canSwitchModeOnRoute(AiAssistantLauncher.activeRoute.value))
      return;
    final users = Get.find<UserController>();
    if (users.user.value?.usageMode == null) {
      Get.toNamed('/choose_mode');
      return;
    }
    setState(() => changingMode = true);
    try {
      await users.chooseMode(
        users.user.value!.usageMode == 'explorer' ? 'inventor' : 'explorer',
        navigate: false,
      );
    } catch (_) {
      Get.snackbar(
        'Modo de exploração',
        'Não foi possível trocar o modo. Tente novamente.',
      );
    } finally {
      if (mounted) setState(() => changingMode = false);
    }
  }

  Future<void> open(bool locker) async {
    setState(() => expanded = false);
    final ctx = Get.key.currentContext ?? Get.overlayContext;
    if (ctx == null) return;
    final previous = panelFuture;
    if (previous != null) {
      Navigator.of(ctx).pop();
      await previous;
    }
    if (!mounted) return;
    late Future<void> next;
    if (locker) {
      next = showGeneralDialog<void>(
        context: ctx,
        barrierDismissible: true,
        barrierLabel: 'Fechar Locker',
        barrierColor: Colors.black54,
        pageBuilder: (context, _, __) {
          final size = MediaQuery.sizeOf(context);
          return Align(
            alignment: size.width >= 800
                ? Alignment.centerRight
                : Alignment.center,
            child: SizedBox(
              width: math.min(size.width - 24, 460),
              height: size.height - 32,
              child: Theme(
                data: ThemeData.dark(useMaterial3: true),
                child: const LockerPanel(),
              ),
            ),
          );
        },
      );
    } else {
      final c = Get.find<AiAssistantController>();
      c.logCurrentContext();
      next = showModalBottomSheet<void>(
        context: ctx,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 1000),
        backgroundColor: Colors.transparent,
        builder: (_) => const AiAssistantPanel(),
      );
      c.ensureHistoryLoaded();
    }
    setState(() {
      panelFuture = next;
    });
    await next;
    if (identical(panelFuture, next)) {
      if (mounted) {
        setState(() {
          panelFuture = null;
        });
      } else {
        panelFuture = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    final u = Get.find<UserController>().user.value;
    final route = AiAssistantLauncher.activeRoute.value;

    final show = u != null && route != '/splash' && route != '/space';
    final showMode =
        show &&
        canSwitchModeOnRoute(route) &&
        !AiAssistantLauncher.modeOverlayBlocked.value;
    final explorer = u?.usageMode == 'explorer';
    final accent = explorer ? const Color(0xFF65DFD2) : const Color(0xFFB5A0FF);
    return Material(
      color: const Color(0xFF0A1123),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: show ? 48 : 0),
            child: widget.child,
          ),
          if (show)
            const Positioned(
              left: 16,
              top: 14,
              child: Text(
                'Educação OnLIFE',
                style: TextStyle(
                  color: Color(0xFF9DC6D8),
                  letterSpacing: 0.2,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (show &&
              !route.startsWith('/management') &&
              !isManagementRecordRoute(route) &&
              ClueConnectionPolicy(u).viewAny())
            Positioned(
              right: 146,
              top: MediaQuery.paddingOf(context).top + 4,
              child: IconButton(
                tooltip: 'Central de Gestão',
                icon: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF9DC6D8),
                  size: 19,
                ),
                onPressed: () => Get.toNamed('/management'),
              ),
            ),
          if (show) ...[
            if (showMode)
              Positioned(
                right: 12,
                top: MediaQuery.paddingOf(context).top + 4,
                child: Material(
                  color: const Color(0xFF111A32),
                  borderRadius: BorderRadius.circular(24),
                  elevation: 4,
                  child: Tooltip(
                    key: modeTooltip,
                    message: u.usageMode == null
                        ? 'Escolha como utilizar a plataforma.'
                        : '${explorer ? 'Explorador: explore pistas e referências' : 'Inventor: crie e organize vivências'}. Toque para trocar de modo.',
                    triggerMode: TooltipTriggerMode.longPress,
                    child: TextButton.icon(
                      focusNode: modeFocus,
                      onFocusChange: (focused) {
                        if (!focused) {
                          Tooltip.dismissAllToolTips();
                          return;
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && modeFocus.hasFocus)
                            modeTooltip.currentState?.ensureTooltipVisible();
                        });
                      },
                      onPressed: changingMode ? null : chooseMode,
                      icon: Icon(
                        explorer
                            ? Icons.rocket_launch_outlined
                            : Icons.handyman_outlined,
                        color: accent,
                        size: 18,
                      ),
                      label: Text(
                        changingMode
                            ? 'Alterando…'
                            : u.usageMode == null
                            ? 'Escolher modo'
                            : explorer
                            ? 'Explorador'
                            : 'Inventor',
                        style: TextStyle(color: accent),
                      ),
                    ),
                  ),
                ),
              ),
            if (panelFuture == null && !route.startsWith('/space/agents/'))
              Positioned(
                right: 16,
                bottom:
                    AiAssistantLauncher._bottomOffset.value +
                    MediaQuery.viewInsetsOf(context).bottom +
                    MediaQuery.paddingOf(context).bottom,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (expanded) ...[
                      FloatingActionButton.extended(
                        heroTag: 'locker-shortcut',
                        onPressed: () => open(true),
                        backgroundColor: const Color(0xFF153B45),
                        foregroundColor: Colors.white,
                        icon: const Icon(Icons.bookmarks_outlined),
                        label: const Text('Locker'),
                      ),
                      const SizedBox(height: 12),
                      FloatingActionButton.extended(
                        heroTag: 'ia-shortcut',
                        onPressed: () => open(false),
                        backgroundColor: const Color(0xFF282346),
                        foregroundColor: Colors.white,
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Iareté'),
                      ),
                      const SizedBox(height: 12),
                    ],
                    FloatingActionButton(
                      heroTag: 'global-shortcuts',
                      tooltip: expanded
                          ? 'Recolher atalhos'
                          : 'Abrir Iareté e Locker',
                      backgroundColor: const Color(0xFF111A32),
                      foregroundColor: accent,
                      onPressed: () => setState(() => expanded = !expanded),
                      child: Icon(expanded ? Icons.close : Icons.apps_rounded),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  });
}
