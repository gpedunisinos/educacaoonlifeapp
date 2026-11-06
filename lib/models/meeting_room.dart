/// The meeting URL is independent from clue URLs and contains no platform token.
class MeetingRoom {
  MeetingRoom._(this.uri);
  final Uri uri;

  static const publicUrl = String.fromEnvironment(
    'JITSI_PUBLIC_URL',
    defaultValue: 'https://meet.spotec.app',
  );
  // Every authenticated platform account may organize a meeting.
  static const enabled = bool.fromEnvironment(
    'JITSI_ENABLED',
    defaultValue: true,
  );

  /// Credentials stay in memory and are never included in the shareable invite.
  Uri authorizedUri(Map<String, dynamic> data) {
    final jwt = data['jwt'];
    final expires = data['expires_at'];
    if (data['room'] != uri.pathSegments.single ||
        jwt is! String ||
        jwt.isEmpty ||
        !RegExp(
          r'^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+$',
        ).hasMatch(jwt) ||
        expires is! int ||
        expires <= DateTime.now().millisecondsSinceEpoch ~/ 1000 + 15 ||
        data['public_url'] != uri.toString()) {
      throw const FormatException(
        'A autorização do encontro não está disponível. Tente novamente.',
      );
    }
    return uri.replace(queryParameters: {'jwt': jwt});
  }

  static Uri _base(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.port != 443 ||
        !['', '/'].contains(uri.path) ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw const FormatException(
        'O endereço dos encontros não está configurado corretamente.',
      );
    }
    return uri;
  }

  static bool get configured {
    try {
      _base(publicUrl);
      return true;
    } on FormatException {
      return false;
    }
  }

  factory MeetingRoom.parse(String input, {String baseUrl = publicUrl}) {
    final base = _base(baseUrl);
    var value = input.trim();
    if (value.isEmpty || value.length > 2000)
      throw const FormatException(
        'Informe o nome da sala ou um link de convite.',
      );
    if (value.toLowerCase().startsWith('${base.host.toLowerCase()}/'))
      value = 'https://$value';
    String room;
    if (value.contains('://')) {
      final uri = Uri.tryParse(value);
      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host.toLowerCase() != base.host.toLowerCase() ||
          uri.port != 443 ||
          uri.userInfo.isNotEmpty) {
        throw const FormatException(
          'Use um convite do servidor de encontros da plataforma.',
        );
      }
      if (uri.pathSegments.length != 1 || uri.pathSegments.first.isEmpty)
        throw const FormatException('O convite precisa identificar uma sala.');
      if (uri.queryParameters.keys.any(
            (key) => RegExp(
              r'jwt|password|senha|token|secret|auth|key',
              caseSensitive: false,
            ).hasMatch(key),
          ) ||
          RegExp(
            r'(jwt|password|senha|token|secret|auth|key)[=:]',
            caseSensitive: false,
          ).hasMatch(uri.fragment)) {
        throw const FormatException(
          'Não inclua senhas ou credenciais no link. Use apenas o endereço da sala.',
        );
      }
      room = uri.pathSegments.first;
    } else {
      room = value;
    }
    room = room.trim().replaceAll(RegExp(r'\s+'), '-').toLowerCase();
    if (room.runes.length > 120 ||
        !RegExp(r'^[\p{L}\p{N}_-]+$', unicode: true).hasMatch(room) ||
        {
          'http-bind',
          'xmpp-websocket',
          'colibri-ws',
          'static',
          'libs',
          'images',
          'css',
          'login',
          'logout',
          'api',
        }.contains(room)) {
      throw const FormatException(
        'Use um nome de sala com letras, números, espaços ou hífens.',
      );
    }
    return MeetingRoom._(
      base.replace(pathSegments: [room], query: null, fragment: null),
    );
  }
}
