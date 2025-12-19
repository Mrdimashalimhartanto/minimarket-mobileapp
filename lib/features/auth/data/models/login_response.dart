class LoginResponse {
  final String? accessToken;
  final bool otpRequired;

  LoginResponse({this.accessToken, required this.otpRequired});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final token = (json['access_token'] ?? json['token']) as String?;

    final otp =
        (json['requires_two_factor'] ??
            json['requires_2fa'] ??
            json['otp_required'] ??
            false) ==
        true;

    return LoginResponse(accessToken: token, otpRequired: otp);
  }
}
