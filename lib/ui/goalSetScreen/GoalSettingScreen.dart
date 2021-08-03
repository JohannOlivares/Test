import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/custom/GradientButtonSmall.dart';
import 'package:run_tracker/custom/custom_tabbarview.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Preference.dart';
import 'package:run_tracker/utils/Utils.dart';

class GoalSettingScreen extends StatefulWidget {
  @override
  _GoalSettingScreenState createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> implements TopBarClickListener{

  bool KmSelected = true;
  bool distanceSelected = false;

  //late String unit;
  int targetDistanceInKm = 0;

  double _sliderValue = 1;
  int walkTime = 150;
  int runTime = 75;

  Gradient grad = LinearGradient(colors: [Color(0XFF8A3CFF), Color(0XFFC040FF)]);


  @override
  void initState() {
    _getPreference();
    super.initState();
  }

  _getPreference(){
    distanceSelected =
        Preference.shared.getBool(Preference.IS_DISTANCE_INDICATOR_ON) ?? false;
    KmSelected =  Preference.shared.getBool(Preference.IS_KM_SELECTED) ?? true;
    double prefDistance = Preference.shared.getDouble(Preference.TARGETVALUE_FOR_DISTANCE_IN_KM)??35.0;
    if(KmSelected){
     targetDistanceInKm =  prefDistance.round()-1;
    }else{
      targetDistanceInKm =  Utils.kmToMile(prefDistance).round()-1;
    }
  }

  @override
  Widget build(BuildContext context) {
    //unit = Languages.of(context)!.txtKM;
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: fullHeight,
        width: fullWidth,
        color: Colur.common_bg_dark,
        child: Column(
          children: [
            //What is Your Gender Text
            Container(
              child: CommonTopBar(
                Languages.of(context)!.txtWeekGoalSetting,
                this,
                isShowBack: true,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: fullHeight * 0.07),
                child: _CustomTabBarView(fullHeight,fullWidth),/*CustomTabBar(
                    tab1: Languages.of(context)!.txtHeartHealth,
                    tab2: Languages.of(context)!.txtDistance,
                    forHeart: _forHeart(fullHeight, fullWidth),
                    forDistance: _forDistance(fullHeight),
                ),*/
              ),
            ),
            //Next Step Button

            _setAsMyGoalButton(fullHeight, fullWidth),
          ],
        ),
      ),
    );
  }

  _CustomTabBarView(double fullHeight, double fullWidth) {
    return  Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                      distanceSelected = false;


                    print(distanceSelected);
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Languages.of(context)!.txtHeartHealth,
                            style: TextStyle(
                                color: !distanceSelected ? Colors.white : Color(0xFF9195B6),
                                fontSize: !distanceSelected ? 20 : 16.0,
                                fontWeight: !distanceSelected ? FontWeight.bold : FontWeight.w500
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !distanceSelected,
                        child: Container(
                          height: 3,
                          width: 30,
                          decoration: BoxDecoration(
                              gradient: grad,
                              borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    distanceSelected = true;
                    print(distanceSelected);

                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Languages.of(context)!.txtDistance,
                            style: TextStyle(
                                color: distanceSelected ? Colors.white : Color(0xFF9195B6),
                                fontSize: distanceSelected ? 20 : 16.0,
                                fontWeight: distanceSelected ? FontWeight.bold : FontWeight.w500
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: distanceSelected,
                        child: Container(
                          height: 3,
                          width: 30,
                          decoration: BoxDecoration(
                              gradient: grad,
                              borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(child: distanceSelected ? _forDistance(fullHeight) : _forHeart(fullHeight,fullWidth),),
      ],
    );
  }

  _forHeart(double fullHeight, double fullWidth) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: fullHeight * 0.06),
        child: Column(
          children: [
            //Row for walking or running
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/icons/ic_yellow_gradient_circle.png",
                          height: 130,
                          width: 130,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: fullHeight*0.015),
                              child: Image.asset(
                                "assets/icons/ic_person_walk.png",
                                height: 25,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: fullHeight*0.01),
                              child: Text(
                                walkTime.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: Colur.txt_white
                                ),
                              ),
                            ),
                            Text(
                              Languages.of(context)!.txtMin.toLowerCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colur.txt_grey
                              ),
                            )
                          ],
                        ),
                      )
                    ]
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    Languages.of(context)!.txtOR.toLowerCase(),
                    style: TextStyle(
                        color: Colur.txt_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/icons/ic_red_gradient_circle.png",
                          height: 130,
                          width: 130,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: fullHeight*0.015),
                              child: Image.asset(
                                "assets/icons/ic_person_run.png",
                                height: 25,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: fullHeight*0.01),
                              child: Text(
                                runTime.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: Colur.txt_white
                                ),
                              ),
                            ),
                            Text(
                              Languages.of(context)!.txtMin.toLowerCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colur.txt_grey
                              ),
                            )
                          ],
                        ),
                      )
                    ]
                ),
              ],
            ),

            //Moderate or high intensity
            Container(
              margin: EdgeInsets.only(top: fullHeight*0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: fullWidth*0.05),
                    child: Text(
                      Languages.of(context)!.txtModerateIntensity,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colur.txt_grey
                      ),
                    ),
                  ),
                  SizedBox(),
                  Container(
                    margin: EdgeInsets.only(left: fullWidth*0.08),
                    child: Text(
                      Languages.of(context)!.txtHighIntensity,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colur.txt_grey
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Slider
            Container(
              margin: EdgeInsets.only(top: fullHeight*0.05,left: fullWidth*0.01, right: fullWidth*0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_sliderValue!= 1) {
                          _sliderValue -= 1;
                        }
                        Debug.printLog("Slider: $_sliderValue");
                      });
                      walkOrRunValue();
                    },
                    child: Container(
                      child: Image.asset(
                        "assets/icons/ic_minus.png",
                        height: 6,
                        width: 14,
                      ),
                    ),
                  ),
                  Container(
                    width: 274,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        activeTrackColor: Colur.rounded_rectangle_color,
                        inactiveTrackColor: Colur.rounded_rectangle_color,
                        inactiveTickMarkColor: Colur.white,
                        activeTickMarkColor: Colur.white,
                        thumbColor: Colur.white,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                        tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 1.5)
                        ),
                      child: Slider(
                        value: _sliderValue,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                            Debug.printLog("Slider: $_sliderValue");
                            walkOrRunValue();
                          });
                          //walkOrRunValue();
                        },
                        autofocus: true,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChangeEnd: (value) {
                          Debug.printLog("Value: $value");
                        },
                        onChangeStart: (value) {
                          Debug.printLog("Value: $value");
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_sliderValue !=5) {
                          _sliderValue += 1;
                        }
                        Debug.printLog("Slider: $_sliderValue");
                      });
                      walkOrRunValue();
                    },
                    child: Container(
                      child: Image.asset(
                        "assets/icons/ic_add.png",
                        height:15,
                        width: 15,
                      ),
                    ),
                  )
                ],
              ),
            )


          ],
        ),
      ),
    );
  }

  walkOrRunValue() {
    if(_sliderValue == 1) {
      walkTime = 150;
      runTime = 75;
    } else if(_sliderValue == 2) {
      walkTime = 225;
      runTime = 150;
    } else if(_sliderValue == 3) {
      walkTime = 300;
      runTime = 225;
    } else if(_sliderValue == 4) {
      walkTime = 375;
      runTime = 300;
    }else  {
      walkTime = 450;
      runTime = 375;
    }
  }

  _forDistance(double fullHeight){
    return Container(
      child: Column(
        children: [
          //this is for selection between KM and MILE
          _distanceUnitTab(fullHeight),
          //Curpentino picker for KM and Mile
          //Distance selector
          _curpentinoPickerDesign(fullHeight),
        ],
      ),
    );
  }

  _distanceUnitTab(double fullHeight) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight * 0.03),
      height: 60,
      width: 205,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colur.txt_grey, width: 1.5),
        color: Colur.common_bg_dark,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                KmSelected = true;
              });
              Debug.printLog("KM selected");
            },
            child: Container(
              width: 100,
              child: Center(
                child: Text(
                  Languages.of(context)!.txtKM,
                  style: TextStyle(
                      color: KmSelected ? Colors.white : Color(0xFF9195B6),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
            ),
          ),
          Container(
            height: 23,
            child: VerticalDivider(
              color: Color(0xFF9195B6),
              width: 1,
              thickness: 1,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                KmSelected = false;
                Debug.printLog("Mile selected");
              });
            },
            child: Container(
              width: 100,
              child: Center(
                child: Text(
                  Languages.of(context)!.txtMILE,
                  style: TextStyle(
                      color: !KmSelected ? Colur.white : Color(0xFF9195B6),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _setAsMyGoalButton( double fullHeight, double fullWidth) {
    return Container(
      margin: EdgeInsets.only(left: fullWidth*0.15, bottom: fullHeight*0.06, right: fullWidth*0.15),
      alignment: Alignment.bottomCenter,
      child: GradientButtonSmall(
        width: double.infinity,
        height: 60,
        radius: 50.0,
        child: Text(
          Languages.of(context)!.txtSetAsMyGoal.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colur.white, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colur.purple_gradient_color1,
            Colur.purple_gradient_color2,
          ],
        ),
        onPressed: () {
          Preference.shared
              .setBool(Preference.IS_DISTANCE_INDICATOR_ON, distanceSelected);
          Preference.shared
              .setBool(Preference.IS_KM_SELECTED, KmSelected);
          //Utils.showToast(context, "Unit IS KM?:"+KmSelected.toString());
          if(KmSelected){
            Preference.shared
                .setDouble(Preference.TARGETVALUE_FOR_DISTANCE_IN_KM, targetDistanceInKm.toDouble()+1);
            Debug.printLog("${targetDistanceInKm.toDouble()+1}");
            Utils.showToast(context, "${targetDistanceInKm.toDouble()+1} Confirmed In Kilometer");
          }
          else{
            Preference.shared
                .setDouble(Preference.TARGETVALUE_FOR_DISTANCE_IN_KM, Utils.mileToKm(targetDistanceInKm.toDouble()+1));
            Utils.showToast(context, "${Utils.mileToKm(targetDistanceInKm.toDouble()+1)} Confirmed In Mile");

          }
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/homeWizardScreen', (Route<dynamic> route) => false);
        },
      ),
    );
  }

  _curpentinoPickerDesign(double fullHeight) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Image.asset(
                "assets/icons/ic_select_pointer.png",
              ),
            ),
          ),
          Container(
            width: 125,
            height: fullHeight * 0.32,
            child: CupertinoPicker(
              backgroundColor: Colur.common_bg_dark,
              useMagnifier: true,
              magnification: 1.05,
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(background: Colur.transparent,),
              scrollController: FixedExtentScrollController(initialItem: targetDistanceInKm),
              onSelectedItemChanged: (value) {
                setState(() {
                  if (!KmSelected) {
                    //value += 1;
                    targetDistanceInKm = Utils.mileToKm(value.toDouble()).round();
                    //Debug.printLog("$targetDistanceInMile Mile selected");
                  } else {
                    //value += 1;
                    targetDistanceInKm = value;
                    //Debug.printLog("$targetDistanceInKm Km selected");
                  }
                });
              },
              itemExtent: 75,
              looping: true,
              children: !KmSelected
                  ? List.generate(300, (index) {
                index += 1;
                return Text(
                  "$index",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                );
              })
                  : List.generate(500, (index) {
                index += 1;
                return Text(
                  "$index",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                );
              }),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
    (KmSelected == true)?Languages.of(context)!.txtKM:Languages.of(context)!.txtMILE,
              style: TextStyle(
                  color: Colur.txt_white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          )

        ],
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name == Constant.STR_BACK) {
      Navigator.pop(context);
    }
  }


}
