import 'package:hexo_app/models/credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/web_api.dart';
import 'dart:convert';

class AuthRepository {
  static const String authCredentialKey = 'auth_credential';
  static const String loginCredentialKey = 'login_credential';
  final SharedPreferences prefs;

  AuthRepository(this.prefs);

  Future<String> auth(LoginCredential credential) {
    return WebApi.auth(
        credential.url, credential.username, credential.password);
  }

  AuthCredential getAuthCredential() {
    final credential = prefs.getString(authCredentialKey);
    return credential != null
        ? AuthCredential.fromJson(jsonDecode(credential))
        : null;
  }

  Future<bool> persistAuthCredential(AuthCredential credential) {
    return prefs.setString(authCredentialKey, jsonEncode(credential.toJson()));
  }

  Future<bool> deleteAuthCredential() {
    return prefs.remove(authCredentialKey);
  }

  LoginCredential getLoginCredential() {
    final credential = prefs.getString(loginCredentialKey);
    return credential != null
        ? LoginCredential.fromJson(jsonDecode(credential))
        : null;
  }

  Future<bool> persistLoginCredential(LoginCredential credential) {
    return prefs.setString(loginCredentialKey, jsonEncode(credential.toJson()));
  }
}
