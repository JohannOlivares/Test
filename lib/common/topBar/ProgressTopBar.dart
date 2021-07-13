

import 'package:flutter/material.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';

class ProgressTopBar extends StatefulWidget {
  TopBarClickListener clickListener;

  bool isShowBack = true;
  double updateValue = 0.3;

  ProgressTopBar(this.clickListener,
      {this.isShowBack = false,
        this.updateValue = 0.3

        });

  @override
  _ProgressTopBarState createState() => _ProgressTopBarState();
}

class _ProgressTopBarState extends State<ProgressTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  widget.clickListener.onTopBarClick(Constant.STR_BACK);
                },
                child: Visibility(
                  visible: widget.isShowBack,
                  child: Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colur.rounded_rectangle_color,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colur.white,
                          ))),
                ),
        ),


              Expanded(
                child: UnconstrainedBox(
                  child:ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    child: Container(
                      width: 100,
                      child: LinearProgressIndicator(
                        backgroundColor: Colur.progress_background_color,

                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colur.purple_gradient_color2),
                        minHeight: 8,
                        value: widget.updateValue,
                      ),
                    ),),
                ),
              ),


              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  widget.updateValue.toString(),
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
