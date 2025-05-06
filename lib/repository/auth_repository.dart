import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final AuthLocalDatasource authLocalDatasource;

  AuthRepository({
    required this.authRemoteDatasource,
    required this.authLocalDatasource,
  });

  Future<AuthModel?> getAuth() async {
    final user = await authLocalDatasource.getAuth();
    print(user);
    return user;
  }

  Future<AuthModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final authModel = await authRemoteDatasource.register(
        email: email,
        password: password,
      );
      // local saqlash kerak
      await authLocalDatasource.saveAuth(authModel);

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
      final authModel = await authRemoteDatasource.login(
        email: email,
        password: password,
      );
      // local saqlash kerak
      await authLocalDatasource.saveAuth(authModel);

      return authModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await authLocalDatasource.removeAuth();
  }
}
