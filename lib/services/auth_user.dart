class AuthUser {
  static const int regularProfile = 10;
  static const int administratorProfile = 40;

  final String? usageMode;
  bool get canAuthor => usageMode == 'inventor';
  final int id;
  final String name;
  final String email;
  final String token;
  final bool isGoogleAuth;
  final int profile;

  const AuthUser({
    required this.id,
    this.usageMode,
    required this.name,
    required this.email,
    required this.token,
    this.isGoogleAuth = false,
    this.profile = 0,
  });

  bool get isAdmin => profile == administratorProfile;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? '',
      usageMode: ['explorer', 'inventor'].contains(json['usage_mode'])
          ? json['usage_mode']
          : null,
      email: json['email'] ?? '',
      token: json['token'] ?? json['plain_text_token'] ?? '',
      isGoogleAuth: json['is_google_auth'] == true,
      profile: json['profile'] is int
          ? json['profile']
          : int.tryParse(json['profile']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usage_mode': usageMode,
      'name': name,
      'email': email,
      'token': token,
      'is_google_auth': isGoogleAuth,
      'profile': profile,
    };
  }
}
