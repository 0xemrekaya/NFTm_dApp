import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'main_screen_v2.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  final String title = "NFTm dApp";
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white);
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      body: Center(
        child: AnimatedTextKit(
          totalRepeatCount: 1,
          onFinished: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
          animatedTexts: [
            WavyAnimatedText(
              title,
              textStyle: textStyle,
              speed: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
