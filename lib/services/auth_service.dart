import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/authenticated_user.dart';
import 'api_headers.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final http.Client client;
  static const String _baseUrl = "https://dummyjson.com";

  AuthService(this.client);

  Future<AuthenticatedUser> login({
    required String username,
    required String password,
  }) async {
    final response = await client
        .post(
          Uri.parse("$_baseUrl/auth/login"),
          headers: ApiHeaders.json(),
          body: jsonEncode({
            "username": username,
            "password": password,
            "expiresInMins": 60,
          }),
        )
        .timeout(const Duration(seconds: 10));

    final body = _decodeBody(response.body);

    if (response.statusCode == 200) {
      return AuthenticatedUser.fromJson(body);
    }

    if (response.statusCode == 400 || response.statusCode == 401) {
      throw const AuthException("Usuario ou senha invalidos.");
    }

    throw AuthException(
      body["message"] ?? "Nao foi possivel realizar o login.",
    );
  }

  Future<AuthenticatedUser> getCurrentUser(String accessToken) async {
    final response = await client
        .get(
          Uri.parse("$_baseUrl/auth/me"),
          headers: ApiHeaders.withToken(accessToken),
        )
        .timeout(const Duration(seconds: 10));

    final body = _decodeBody(response.body);

    if (response.statusCode == 200) {
      return AuthenticatedUser.fromJson({...body, "accessToken": accessToken});
    }

    throw AuthException(
      body["message"] ?? "Sessao expirada. Faca login novamente.",
    );
  }

  Map<String, dynamic> _decodeBody(String responseBody) {
    final decoded = jsonDecode(responseBody);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {"message": "Resposta inesperada da API."};
  }
}
