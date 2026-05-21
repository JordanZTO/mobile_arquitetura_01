import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/authenticated_user.dart';
import 'auth_service.dart';

class SessionManager extends ChangeNotifier {
  static const String _accessTokenKey = "dummyjson_access_token";
  static const String _refreshTokenKey = "dummyjson_refresh_token";

  final AuthService _authService;

  AuthenticatedUser? _currentUser;

  SessionManager(this._authService);

  AuthenticatedUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser?.accessToken.isNotEmpty ?? false;
  String? get accessToken => _currentUser?.accessToken;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);

    if (token == null || token.isEmpty) {
      _currentUser = null;
      notifyListeners();
      return;
    }

    try {
      final user = await _authService.getCurrentUser(token);
      _currentUser = user.copyWith(
        accessToken: token,
        refreshToken: prefs.getString(_refreshTokenKey),
      );
      notifyListeners();
    } catch (_) {
      await clearSession();
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final user = await _authService.login(
      username: username,
      password: password,
    );

    _currentUser = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, user.accessToken);
    if (user.refreshToken != null && user.refreshToken!.isNotEmpty) {
      await prefs.setString(_refreshTokenKey, user.refreshToken!);
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await clearSession();
  }

  Future<void> clearSession() async {
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);

    notifyListeners();
  }
}
