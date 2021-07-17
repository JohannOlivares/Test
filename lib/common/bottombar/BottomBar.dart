import 'package:flutter/material.dart';
import 'package:run_tracker/utils/Color.dart';

class BottomBar extends StatefulWidget {
  bool? isProfile = false;
  bool? isHome = false;

  BottomBar({this.isHome, this.isProfile});
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: new FractionalOffset(.5, -8.0),
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: 80.0,
          color: Colur.rounded_rectangle_color,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "/homeScreen");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Image.asset(
                      widget.isHome!
                          ? "assets/icons/ic_selected_home_bottombar.webp"
                          : "assets/icons/ic_unselected_home_bottombar.webp",
                      scale: 3.5,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "/profileScreen");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Image.asset(
                      widget.isProfile!
                          ? "assets/icons/ic_selected_profile_bottombar.webp"
                          : "assets/icons/ic_unselected_profile_bottombar.webp",
                      scale: 3.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: (){
          },
          child: Container(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/icons/ic_person_bottombar.webp",
              scale: 3.8,
            ),
          ),
        ),
      ],
    );
  }
}
