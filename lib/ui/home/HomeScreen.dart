import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool homeSelected = true;
  bool profileSelected = false;

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
                //Top bar
                buildTopBar(fullWidth, fullHeight),
                //Circular percent Indicator
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: fullHeight*0.04),
                        child: percentIndicator(),
                      ),
                      walkOrRunCount()
                    ],
                  ),
                ),
                // Steps and Water Buttons
                stepNdWaterBtns(fullHeight, fullWidth),
                //Recent Activities
                recentActivities(fullHeight, fullWidth),
                //Best Records
                bestRecords(fullHeight, fullWidth)

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          onPressed: () {  },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colur.purple_gradient_color1, Colur.purple_gradient_color2,]),
              shape: BoxShape.circle
            ),
            child: Center(
              child: Image.asset(
                "assets/icons/ic_person_bottombar.png",
                height: 45,
                width: 45,
                //fit: BoxFit.cover,
              ),
            ),
          ),
              //params
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colur.progress_background_color,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: fullHeight*0.1,
          child: bottomBarIcons(fullWidth, fullHeight),
        ),
      )
    );
  }

  Row walkOrRunCount() {
    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/ic_person_walk.png",
                                height: 30,//20
                              ),
                              SizedBox(width: 12,),
                              Text(
                                "0",
                                style: TextStyle(
                                  color: Colur.txt_grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22//18
                                ),
                              ),
                              Text(
                                "/300min",
                                style: TextStyle(
                                    color: Colur.txt_grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18//12
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 40),
                        Container(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/ic_person_run.png",
                                height: 30, //20
                              ),
                              SizedBox(width: 12,),
                              Text(
                                "0",
                                style: TextStyle(
                                    color: Colur.txt_grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22, //18
                                ),
                              ),
                              Text(
                                "/150min",
                                style: TextStyle(
                                    color: Colur.txt_grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18, //12
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
  }

  SfRadialGauge percentIndicator() {
    return SfRadialGauge(
                          title: GaugeTitle(
                              text: 'Heart Health',
                              textStyle: const TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              )
                          ),
                          axes: <RadialAxis>[
                            RadialAxis(
                                showTicks: false,
                                showLabels: false,
                                minimum: 0,
                                maximum: 100,
                                axisLineStyle: AxisLineStyle(
                                  thickness: 0.13,
                                  cornerStyle: CornerStyle.bothCurve,
                                  color: Color(0XFF1B2153),
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                                pointers: <GaugePointer>[
                                  RangePointer(
                                    value: 75,
                                    gradient: SweepGradient(colors: [Color(0xff8A3CFF), Color(0xffC040FF)]),
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
                                              "75" + '%',
                                              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.white),
                                            ),
                                            Text(
                                              "This Week",
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff9195B6)),
                                            ),
                                          ],
                                        ),
                                      ))
                                ])
                          ]);
  }

  bottomBarIcons(double fullWidth, double fullHeight) {
    return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding:  EdgeInsets.only(right: fullWidth*0.12),
              child: IconButton(
                icon: Icon(
                  Icons.home_rounded,
                  size: fullHeight * 0.04,
                  color: homeSelected ? Colur.purple_gradient_color2 : Colur.txt_grey,
                ),
                onPressed: () {
                  setState(() {
                    homeSelected = true;
                    profileSelected = false;
                  });
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.only( left: fullWidth*0.12),
              child: IconButton(
                icon: Icon(
                  Icons.person,
                  size: fullHeight * 0.04,
                  color: profileSelected ? Colur.purple_gradient_color2 : Colur.txt_grey,
                ),
                onPressed: () {
                  setState(() {
                    profileSelected = true;
                    homeSelected = false;
                  });
                }
              ),
            ),
          ],
        );
  }

  bestRecords(double fullHeight, double fullWidth) {
    return Padding(
      padding: EdgeInsets.only(top: fullHeight*0.037, left: fullWidth*0.05, right: fullWidth*0.05),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Best Records",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colur.txt_white
                  ),
                ),
              ],
            ),
            SizedBox(height: 21,),
            bestRecordList()
          ],
        ),
      ),
    );
  }

  bestRecordList() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            height:97,
            width: 340,
            decoration: BoxDecoration(
              color: Colur.progress_background_color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/ic_distance.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LONGEST DISTANCE",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colur.txt_white
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "0",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  color: Colur.txt_purple
                              ),
                            ),
                            SizedBox(width: 7,),
                            Text(
                              "mile",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colur.txt_purple
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            height:97,
            width: 340,
            decoration: BoxDecoration(
              color: Colur.progress_background_color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/ic_best_pace.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BEST PACE",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colur.txt_white
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "0",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  color: Colur.txt_purple
                              ),
                            ),
                            SizedBox(width: 7,),
                            Text(
                              "min/mi",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colur.txt_purple
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            height:97,
            width: 340,
            decoration: BoxDecoration(
              color: Colur.progress_background_color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/ic_duration.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LONGEST DURATION",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colur.txt_white
                          ),
                        ),
                        Text(
                          "00:00",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: Colur.txt_purple
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  recentActivities(double fullHeight, double fullWidth) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight*0.03, left: fullWidth*0.05,right: fullWidth*0.05),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Activities",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_white
                ),
              ),
              InkWell(
                onTap: () {
                  //TODO
                },
                child: Text(
                  "More",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colur.txt_purple
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 21,),
          recentActivitiesList(fullHeight)
        ],
      ),
    );
  }

  recentActivitiesList(double fullHeight) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding:  EdgeInsets.only(bottom: fullHeight*0.015),
          child: Container(
            height:120,
            width: 340,
            decoration: BoxDecoration(
              color: Colur.progress_background_color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(13.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: Image.asset(
                      "assets/icons/ic_route_map.png",
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  Expanded(
                    child: Padding(
                      padding:  EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jun 3",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colur.txt_white
                            ),
                          ),
                          Text(
                            "0.00 mile",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Colur.txt_white
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top: fullHeight*0.01),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "00:00:00",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Colur.txt_grey
                                  ),
                                ),
                                Text(
                                  "00:00 min/mi",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Colur.txt_grey
                                  ),
                                ),
                                Text(
                                  "1 Kcal",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Colur.txt_grey
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(bottom: fullHeight*0.015),
          child: Container(
            height:120,
            width: 340,
            decoration: BoxDecoration(
              color: Colur.progress_background_color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: Image.asset(
                      "assets/icons/ic_route_map.png",
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jun 3",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colur.txt_white
                            ),
                          ),
                          Text(
                            "0.00 mile",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Colur.txt_white
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top: fullHeight*0.01),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "00:00:00",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Colur.txt_grey
                                  ),
                                ),
                                Text(
                                  "00:00 min/mi",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Colur.txt_grey
                                  ),
                                ),
                                Text(
                                  "1 Kcal",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Colur.txt_grey
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: fullHeight*0.015),
          child: Container(
            height:120,
            width: 340,
            decoration: BoxDecoration(
              color: Colur.progress_background_color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      "assets/icons/ic_route_map.png",
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jun 3",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colur.txt_white
                            ),
                          ),
                          Text(
                            "0.00 mile",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Colur.txt_white
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: fullHeight*0.01),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "00:00:00",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Colur.txt_grey
                                  ),
                                ),
                                Text(
                                  "00:00 min/mi",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Colur.txt_grey
                                  ),
                                ),
                                Text(
                                  "1 Kcal",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: Colur.txt_grey
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  stepNdWaterBtns(double fullHeight, double fullWidth) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight*0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                //TODO
              },
              child: Image.asset(
                  "assets/icons/ic_steps.png",
                  height: 90,
                  width: fullWidth*0.385
              )
          ),
          SizedBox(width: 20,),
          InkWell(
              onTap: () {
                //TODO
              },
              child: Image.asset(
                  "assets/icons/ic_water.png",
                  height: 90,
                  width: fullWidth*0.385
              )
          ),
        ],
      ),
    );
  }

  buildTopBar(double fullWidth, double fullHeight) {
    return Container(
      margin: EdgeInsets.only(left: fullWidth*0.05, top: fullHeight*0.03, right: fullWidth*0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Languages.of(context).txtRunTracker,
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900
                  ),
                ),
                Text(
                  Languages.of(context).txtGoFasterSmarter,
                  style: TextStyle(
                      color: Colur.txt_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colur.progress_background_color)
              ),
              child: IconButton(
                icon: Icon(Icons.info_outline_rounded),
                onPressed: (){},
                color: Colur.txt_white,
              )
          )
        ],
      ),
    );
  }
}
