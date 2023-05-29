import 'package:flutter/material.dart';
import 'package:flutterbutter/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FlutterButter")),
      drawer: const AppDrawer(),
      body: const Center(child: Text("FlutterButter")),
    );
  }
}
