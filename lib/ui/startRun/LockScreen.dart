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
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
  Animation<double>? opacityAnimation;
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






/*

class LockScreen extends ModalRoute<String> {


  var progress = 0.0;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;


  @override
  Widget buildPage(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,) {
    var fullheight = MediaQuery
        .of(context)
        .size
        .height;
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: _buildOverlayContent(context, fullheight),
    );
  }

  Widget _buildOverlayContent(BuildContext context, var fullheight) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: fullheight * 0.10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onLongPressStart: (value){
              setState(() {
                progress = progress + 0.1;
              });
              Navigator.pop(context);
            },
            child: Column(
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colur.txt_grey,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colur.water_level_wave2),
                  value:progress,
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Colur.light_red_stop_gredient1,
                        Colur.light_red_stop_gredient2,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      child: Image.asset(
                        "assets/icons/ic_square.png",
                        scale: 3.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

}

*/

