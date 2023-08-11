import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static String id = "Main Screen";
  final String title = "Create a Web3 Wallet for App.";

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              title,
              style: textStyle,
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Generate a wallet"))
        ],
      ),
    );
  }
}
