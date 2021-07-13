

import 'package:flutter/material.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/wellDoneScreen/WellDoneScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';

class PausePopupScreen extends ModalRoute<String> {


  PausePopupScreen();

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
    var fullheight = MediaQuery.of(context).size.height;
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: _buildOverlayContent(context,fullheight),
    );
  }


  Widget _buildOverlayContent(BuildContext context,var fullheight) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom:fullheight*0.10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){
                  //Utils.showToast(context, "Skip");
                  /*Navigator.pop(context, Constant.STR_STOP);*/
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => WellDoneScreen()));

                },
                child: Container(
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
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(Languages
                    .of(context)
                    .txtStop, style: TextStyle(fontSize: 16,
                    color: Colur.txt_white,
                    fontWeight: FontWeight.w600),),
              ),
            ],
          ),

          InkWell(
            onTap: () {
              //Utils.showToast(context, "Back");
              Navigator.pop(context, Constant.STR_BACK);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Colur.light_green_play_gredient1,
                        Colur.light_green_play_gredient2,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      child: Image.asset(
                        "assets/icons/ic_play.png",
                        scale: 3.7,
                        color: Colur.txt_white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(Languages
                      .of(context)
                      .txtResume, style: TextStyle(fontSize: 16,
                      color: Colur.txt_white,
                      fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}