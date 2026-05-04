import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/chat_template_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/app_access_policy.dart';
import 'package:unisinos_usp_app/screens/chat_template/chat_template_chat_screen.dart';
import 'package:unisinos_usp_app/screens/chat_template/chat_template_create_screen.dart';
import 'package:unisinos_usp_app/screens/chat_template/chat_template_index_screen.dart';
import 'package:unisinos_usp_app/screens/chat_template/chat_template_update_screen.dart';

List<GetPage> chatTemplateRoutes() => [
      GetPage(
        name: '/chat_templates',
        page: () => ChatTemplateIndexScreen(),
        binding: ChatTemplateIndexBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.chatTemplates,
              action: AppPermissionAction.view),
        ],
      ),
      GetPage(
        name: '/chat_templates/chat',
        page: () => const ChatTemplateChatScreen(),
        binding: ChatTemplateChatBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.chatTemplates,
              action: AppPermissionAction.view),
        ],
      ),
      GetPage(
        name: '/chat_templates/create',
        page: () => const ChatTemplateCreateScreen(),
        binding: ChatTemplateCreateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.chatTemplates,
              action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/chat_templates/update',
        page: () => const ChatTemplateUpdateScreen(),
        binding: ChatTemplateUpdateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.chatTemplates,
              action: AppPermissionAction.manage),
        ],
      ),
    ];
