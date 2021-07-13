import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CountdownTimerScreen extends StatefulWidget {
  bool isGreen = false;

  CountdownTimerScreen({@required this.isGreen});

  @override
  _CountdownTimerScreenState createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.isGreen
                ? "assets/images/bg_countdown_timer_green.webp"
                : "assets/images/bg_countdown_timer_blue.webp",
            fit: BoxFit.cover,
          ),
          Lottie.asset(
            widget.isGreen
                ? 'assets/animation/countdown_green.json'
                : 'assets/animation/countdown_blue.json',
            width: 100,
            height: 150,
            repeat: false,
          )
        ],
      ),
    );
  }
}
