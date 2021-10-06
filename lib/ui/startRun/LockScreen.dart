import 'package:flutter/material.dart';

class LockScreen extends StatefulWidget {

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> with SingleTickerProviderStateMixin{

  void showPopup() {
    AnimationController controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    showDialog(
      context: context,
      builder: (_) => PopUp(
        controller: controller,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPopup,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
class PopUp extends StatefulWidget {
  final AnimationController? controller;

  PopUp({this.controller});

  @override
  State<StatefulWidget> createState() => PopUpState();
}

class PopUpState extends State<PopUp> {
  Tween<double> opacityTween = Tween<double>(begin: 0.0, end: 1.0);
  Tween<double> marginTopTween = Tween<double>(begin: 600, end: 200);
  Animation<double>? marginTopAnimation;
  AnimationStatus? animationStatus;

  @override
  void initState() {
    super.initState();

    marginTopAnimation = marginTopTween.animate(widget.controller!)
      ..addListener(() {
        animationStatus = widget.controller?.status;

        if (animationStatus == AnimationStatus.dismissed) {
          Navigator.of(context).pop();
        }

        if(this.mounted) {
          setState(() {

          });
        }
      });
    widget.controller?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityTween.animate(widget.controller!),
      child: GestureDetector(
        onTap: () {
          widget.controller?.reverse();
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.only(
              top: marginTopAnimation!.value,
            ),
            color: Colors.red,
            child: Text("Container"),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller!.dispose();
    super.dispose();
  }
}




