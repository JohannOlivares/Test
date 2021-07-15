import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:run_tracker/custom/GradientButtonSmall.dart';
import 'package:run_tracker/ui/stepsTracker/StepsPopUpMenu.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../common/commonTopBar/CommonTopBar.dart';
import '../../interfaces/TopBarClickListener.dart';
import '../../localization/language/languages.dart';
import '../../utils/Constant.dart';

class StepsTrackerScreen extends StatefulWidget {
  @override
  _StepsTrackerScreenState createState() => _StepsTrackerScreenState();
}

class _StepsTrackerScreenState extends State<StepsTrackerScreen>
    implements TopBarClickListener{

  TextEditingController stepController = TextEditingController();
  bool isPlay = true;
  bool isPause = false;

  // ScrollController _scrollController;
  //
  // @override
  // void initState() {
  //   _scrollController = ScrollController();
  // }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                //TopBar
                Container(
                  child: CommonTopBar(
                    Languages.of(context).txtSTEPSTRACKER,
                    this,
                    isShowBack: true,
                    isOptions: true,
                  ),
                ),

                //Step Indicator with pause & play button nd options
                buildStepIndiactorRow(context, fullHeight, fullWidth),

                //Circular progress indicator for each day in a week
                Container(
                  margin: EdgeInsets.only(top: fullHeight*0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildWeekCircularIndicator(fullHeight, "S", 0.3),
                      buildWeekCircularIndicator(fullHeight, "M", 0.4),
                      buildWeekCircularIndicator(fullHeight, "T", 0.5),
                      buildWeekCircularIndicator(fullHeight, "W", 0.6),
                      buildWeekCircularIndicator(fullHeight, "T", 0.7),
                      buildWeekCircularIndicator(fullHeight, "F", 0.8),
                      buildWeekCircularIndicator(fullHeight, "S", 0.9),
                    ],
                  ),
                ),

                //Duration, Calories nd Distance info
                otherInfo(fullHeight, context),

                //Weekly average steps card
                weeklyAverage(fullHeight, fullWidth, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Last 7 days steps card
  weeklyAverage(double fullHeight, double fullWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight*0.1, right: fullWidth*0.04, left: fullWidth*0.04, bottom: fullHeight*0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colur.progress_background_color,
      ),
      padding: EdgeInsets.symmetric(vertical: fullWidth*0.04, horizontal: fullWidth*0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Languages.of(context).txtLast7DaysSteps,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colur.txt_white
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: fullHeight*0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "759",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colur.txt_white
                  ),
                ),
                InkWell(
                  onTap: () {
                   // Navigator.push(context, MaterialPageRoute(builder: (context) => WeekGraphScreen()));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colur.common_bg_dark,
                        ),
                      ),
                      Image.asset(
                        "assets/icons/ic_arrow_green_gradient.png",
                        height: 12,
                        width: 7.41,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Duration, calories and miles
  otherInfo(double fullHeight, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight*0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "0h 6m",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_white
                ),
              ),
              Text(
                Languages.of(context).txtDuration,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_grey
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "6",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_white
                ),
              ),
              Text(
                Languages.of(context).txtKcal,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_grey
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "0.06",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_white
                ),
              ),
              Text(
                Languages.of(context).txtMile,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_grey
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Week circular progress indicator
  buildWeekCircularIndicator(double fullHeight, String weekDay, double value) {
    return Column(
      children: [
        CircularProgressIndicator(
          value: value,
          valueColor: AlwaysStoppedAnimation(Colur.txt_green),
          backgroundColor: Colur.progress_background_color,
        ),
        Container(
          margin: EdgeInsets.only(top: fullHeight*0.02),
          child: Text(
            weekDay,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colur.txt_white
            ),
          ),
        ),
      ],
    );
  }

  //Step Indicator with pause & play button nd options
  buildStepIndiactorRow(BuildContext context, double fullHeight, double fullWidth) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Play pause button
          InkWell(
            onTap: () {
              setState(() {
                isPlay = !isPlay;
                isPause = !isPause;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colur.progress_background_color,
                  ),
                ),
                Image.asset(
                  isPlay ? "assets/icons/ic_play.png" : "assets/icons/ic_pause.png",
                  height: 14,
                  width: 12,
                ),
              ],

            ),
          ),

          //Step Indicator
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 200,
                width: 200,
                child: stepsIndicator(),
              ),
              Text(
                Languages.of(context).txtSteps,
                style: TextStyle(
                    color: Colur.txt_green,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
              )
            ],
          ),

          //Statistics icon
          InkWell(
            onTap: () {
              //TODO
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colur.progress_background_color,
                  ),
                ),
                Image.asset(
                  "assets/icons/ic_statistics.png",
                  height: 15,
                  width: 19,
                ),
              ],

            ),
          )

        ],
      ),
    );
  }

  editTargetStepsBottomDialog(BuildContext context, double fullHeight, double fullWidth) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: false,
      backgroundColor: Colur.white,
      builder: (context){
        return Container(
          height: fullHeight*0.5,
          color: Colur.common_bg_dark,
          child: Container(
            decoration: new BoxDecoration(
              color: Colur.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32)
              )
            ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: fullHeight*0.04, horizontal: fullWidth*0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Edit target steps
                  Text(
                    Languages.of(context).txtEditTargetSteps,
                    style: TextStyle(
                        color: Colur.txt_black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700
                    ),
                  ),

                  SizedBox(height: 7),

                  //Edit steps desc
                  Text(
                    Languages.of(context).txtEditStepsTargetDesc,
                    style: TextStyle(
                        color: Colur.txt_grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w400
                    ),
                  ),

                  //Steps Textfield
                  Container(
                    margin: EdgeInsets.only(top: fullHeight*0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Languages.of(context).txtSteps,
                          style: TextStyle(
                              color: Colur.txt_black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 167,
                          decoration: BoxDecoration(
                            color: Colur.txt_grey,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: TextFormField(
                            maxLines: 1,
                            controller: stepController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colur.txt_white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700
                            ),
                            cursorColor: Colur.txt_white,
                            //controller: msgController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Cancel and save btn
                  Container(
                    margin: EdgeInsets.only(top: fullHeight*0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Cancel btn
                        Padding(
                          padding: EdgeInsets.only(left: fullWidth*0.1),
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () { Navigator.pop(context); },
                            child: Text(
                              Languages.of(context).txtCancel,
                              style: TextStyle(
                                  color: Colur.txt_black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900
                              ),
                            ),
                          ),
                        ),

                        //Save btn
                        Container(
                          width: 167,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colur.green_gradient_color1, Colur.green_gradient_color2]),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                               BoxShadow(
                                offset: Offset(0.0, 25),
                                spreadRadius: 5,
                                blurRadius: 50,
                                color: Colur.green_gradient_shadow,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colur.transparent,
                            child: InkWell(
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    Languages.of(context).txtSave,
                                    style: TextStyle(
                                        color: Colur.txt_white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900
                                    ),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },

    );
  }

  //SfRadialGauge Indicator
  stepsIndicator() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            showTicks: false,
            showLabels: false,
            minimum: 0,
            maximum: 100,
            axisLineStyle: AxisLineStyle(
              thickness: 0.13,
              cornerStyle: CornerStyle.bothCurve,
              color: Colur.progress_background_color,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: 75,
                gradient: SweepGradient(colors: [Colur.green_gradient_color1, Colur.green_gradient_color2]),
                cornerStyle: CornerStyle.bothCurve,
                width: 0.13,
                sizeUnit: GaugeSizeUnit.factor,
              )
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  positionFactor: 0.1,
                  angle: 90,
                  widget: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "149",
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colur.txt_white),
                        ),
                        Text(
                          "/2000",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colur.txt_grey
                          ),
                        ),
                      ],
                    ),
                  ))
            ])
      ]);
  }

  openPopUpMenu(fullHeight,  fullWidth) async {
    final String result = await Navigator.push(context,  StepsPopUpMenu());

    if(result == Constant.STR_EDITTARGET) {
      setState(() {
        editTargetStepsBottomDialog(context, fullHeight, fullWidth);
      });
    }

    if(result == Constant.STR_RESET) {
      setState(() {
        //TODO
      });
    }

    if(result == Constant.STR_TURNOFF) {
      setState(() {
        //TODO
      });
    }
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name == Constant.STR_BACK) {
      Navigator.of(context).pop();
    }

    if(name == Constant.STR_OPTIONS) {
      openPopUpMenu(
          MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width
      );
    }
  }
}
