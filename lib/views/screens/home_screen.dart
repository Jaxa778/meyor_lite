import 'package:flutter/material.dart';
import 'package:meyor_lite/controllers/app_controller.dart';
import 'package:meyor_lite/views/screens/setting_screen.dart';
import 'package:meyor_lite/views/widgets/alert_dialog_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios)),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text("Umumiy xarajatlar"), Text("100,000 so`m")],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 600,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.edit, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                "10000000 so`m",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "100 %",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 10 / 100,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Consumer<AppController>(
                
                builder: (context, value, child) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final cost = value.wallets[index];
                      return ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.amber),
                        title: Text(cost.costName),
                        subtitle: Text(cost.costDate.toString()),
                        trailing: Text(
                          "${cost.costPrice.toStringAsFixed(1)} som",
                        ),
                      );
                    },
                    itemCount: value.wallets.length,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialogWidget();
                },
              );
            },
            child: Icon(Icons.add),
          ),
          FloatingActionButton.small(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingScreen();
                  },
                ),
              );
            },
            child: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
  // Future<void> _manageWallet([dynamic wallet]) async {
  //   try {
  //     final result = await showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (ctx) => AlertDialogWidget(oldCost: wallet),
  //     );

  //     // if (result == true) {
  //     //   _calculateCosts();
  //     //   setState(() {});
  //     // }
  //   } catch (e, s) {
  //     debugPrint('$e');
  //     debugPrint('$s');
  //   }
  // }
}
