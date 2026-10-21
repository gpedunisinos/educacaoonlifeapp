import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/chat_template_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
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
              canActivate: (user) => ChatTemplatePolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/chat_templates/chat',
        page: () => ChatTemplateChatScreen(),
        binding: ChatTemplateChatBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => ChatTemplatePolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/chat_templates/create',
        page: () => ChatTemplateCreateScreen(),
        binding: ChatTemplateCreateBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => ChatTemplatePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/chat_templates/update',
        page: () => ChatTemplateUpdateScreen(),
        binding: ChatTemplateUpdateBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => ChatTemplatePolicy(user).create()),
        ],
      ),
    ];
