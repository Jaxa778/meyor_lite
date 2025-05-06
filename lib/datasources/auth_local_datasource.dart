import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_model.dart';

class AuthLocalDatasource {
  final String _myAuthKey = "my-user-key";

  Future<void> saveAuth(AuthModel authModel) async {
    final prefs = await SharedPreferences.getInstance();
    print(authModel.token);
    final data = authModel.copyWith();
    final encodedData = jsonEncode(data.toJson());
    await prefs.setString(_myAuthKey, encodedData);
  }

  Future<AuthModel?> getAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_myAuthKey);

      if (data != null) {
        final decodedData = jsonDecode(data);
        return AuthModel.fromJson(decodedData);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
    return null;
  }

  Future<void> removeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_myAuthKey);
    } catch (e) {
      rethrow;
    }
  }
}
