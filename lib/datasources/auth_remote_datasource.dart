import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_model.dart';

class AuthRemoteDatasource {
  final String _myApiKey = "AIzaSyB6HtcoZa3Rd_5jHxZhnGNT_SpNffIi6_E";

  Future<AuthModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_myApiKey",
      );

      final data = {
        "email": email,
        "password": password,
        "returnSecureToken": true,
      };

      final response = await http.post(url, body: jsonEncode(data));

      final decodedData = jsonDecode(response.body);

      if (decodedData["error"] != null) {
        throw decodedData["error"]["message"];
      }

      final authModel = AuthModel.fromJson(decodedData);

      return authModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_myApiKey",
      );

      final data = {
        "email": email,
        "password": password,
        "returnSecureToken": true,
      };

      final response = await http.post(url, body: jsonEncode(data));

      final decodedData = jsonDecode(response.body);

      if (decodedData["error"] != null) {
        throw decodedData["error"]["message"];
      }

      final authModel = AuthModel.fromJson(decodedData);

      return authModel;
    } catch (e) {
      print(e);

      rethrow;
    }
  }
}
