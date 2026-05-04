import 'package:unisinos_usp_app/services/auth_user.dart';

enum AppModule {
  biomes,
  territories,
  categories,
  livingClues,
  clueConnections,
  connectionTypes,
  nodes,
  nodeLinks,
  nodeTypes,
  chatTemplates,
  users,
}

enum AppPermissionAction { view, manage }

class AppAccessPolicy {
  static bool isAdmin(AuthUser? user) => user?.isAdmin ?? false;

  static bool canViewModule(AuthUser? user, AppModule module) {
    if (user == null) return false;
    if (isAdmin(user)) return true;

    switch (module) {
      case AppModule.biomes:
      case AppModule.territories:
      case AppModule.categories:
      case AppModule.connectionTypes:
      case AppModule.nodeTypes:
      case AppModule.chatTemplates:
      case AppModule.livingClues:
      case AppModule.clueConnections:
      case AppModule.nodes:
      case AppModule.nodeLinks:
        return true;
      case AppModule.users:
        return false;
    }
  }

  static bool canManageModule(AuthUser? user, AppModule module) {
    if (user == null) return false;
    if (isAdmin(user)) return true;

    switch (module) {
      case AppModule.livingClues:
      case AppModule.clueConnections:
      case AppModule.nodes:
      case AppModule.nodeLinks:
        return true;
      case AppModule.biomes:
      case AppModule.territories:
      case AppModule.categories:
      case AppModule.connectionTypes:
      case AppModule.nodeTypes:
      case AppModule.chatTemplates:
      case AppModule.users:
        return false;
    }
  }

  static bool can(
      AuthUser? user, AppModule module, AppPermissionAction action) {
    switch (action) {
      case AppPermissionAction.view:
        return canViewModule(user, module);
      case AppPermissionAction.manage:
        return canManageModule(user, module);
    }
  }
}
