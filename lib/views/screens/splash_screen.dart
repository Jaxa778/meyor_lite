import 'package:flutter/material.dart';
import 'package:meyor_lite/controllers/auth_controller.dart';
import 'package:meyor_lite/views/screens/home_screen.dart';
import 'package:meyor_lite/views/screens/login_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: context.read<AuthController>().isAuthenticated(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return snapshot.data == true
                          ? HomeScreen()
                          : LoginScreen();
                    },
                  ),
                );
              });
            }

            return FlutterLogo(size: 80);
          },
        ),
      ),
    );
  }
}
