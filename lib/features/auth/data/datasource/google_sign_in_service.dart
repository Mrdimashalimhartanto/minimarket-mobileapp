import 'package:google_sign_in/google_sign_in.dart' as g;

class GoogleSignInService {
  final g.GoogleSignIn _googleSignIn;

  GoogleSignInService({required String webClientId})
    : _googleSignIn = g.GoogleSignIn(
        serverClientId: webClientId, // WEB CLIENT ID
        scopes: const ['email', 'profile'],
      );

  Future<String?> getIdToken() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;

    final auth = await account.authentication;
    return auth.idToken;
  }

  Future<void> signOut() => _googleSignIn.signOut();
}
