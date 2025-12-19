class AuthSession {
  final String accessToken;
  final String tokenType;

  const AuthSession({required this.accessToken, required this.tokenType});

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    // Laravel response: { success, data: { access_token, token_type, user } }
    final data = (json['data'] is Map)
        ? Map<String, dynamic>.from(json['data'])
        : <String, dynamic>{};

    return AuthSession(
      accessToken: (data['access_token'] ?? '').toString(),
      tokenType: (data['token_type'] ?? 'Bearer').toString(),
    );
  }
}
