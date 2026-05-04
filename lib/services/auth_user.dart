class AuthUser {
  static const int regularProfile = 10;
  static const int administratorProfile = 40;

  final int id;
  final String name;
  final String email;
  final String token;
  final bool isGoogleAuth;
  final int profile;

  const AuthUser({
    required this.id,
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
      'name': name,
      'email': email,
      'token': token,
      'is_google_auth': isGoogleAuth,
      'profile': profile,
    };
  }
}
