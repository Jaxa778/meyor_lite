import 'package:flutter/material.dart';
import 'package:meyor_lite/controllers/app_controller.dart';
import 'package:meyor_lite/views/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return AppController();
          },
        ),
      ],
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      },
    );
  }
  //Ustoz hali tekshirmay turing juda chalada, Noldan behato tiklayotgan edim.
}
