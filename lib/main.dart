import 'package:flutter/material.dart';
import 'package:meyor_lite/controllers/app_controller.dart';
import 'package:meyor_lite/controllers/auth_controller.dart';
import 'package:meyor_lite/datasources/auth_remote_datasource.dart';
import 'package:meyor_lite/repository/auth_repository.dart';
import 'package:meyor_lite/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'datasources/auth_local_datasource.dart';

final myAppnavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    final authRemoteDatasource = AuthRemoteDatasource();
    final authLocalDatasource = AuthLocalDatasource();
    final authRepository = AuthRepository(
      authRemoteDatasource: authRemoteDatasource,
      authLocalDatasource: authLocalDatasource,
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return AuthController(authRepository: authRepository);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return AppController();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: myAppnavigatorKey,
        home: SplashScreen(),
      ),
    );
  }
}
