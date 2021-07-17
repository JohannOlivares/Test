import 'package:flutter/material.dart';

import 'localization/language/languages.dart';
import 'localization/language_data.dart';
import 'localization/locale_constant.dart';

class LoadingButton extends StatefulWidget {
  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTapDown: (_) => controller!.forward(),
          onTapUp: (_) {
            if (controller?.status == AnimationStatus.forward) {
              controller?.reverse();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                value: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
              CircularProgressIndicator(
                value: controller?.value,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              Icon(Icons.add)
            ],
          ),
        ),
      ),
    );
  }
}