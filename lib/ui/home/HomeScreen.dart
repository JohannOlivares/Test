import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:run_tracker/dbhelper/DataBaseHelper.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/drinkWaterScreen/DrinkWaterLevelScreen.dart';
import 'package:run_tracker/ui/goalSetScreen/GoalSettingScreen.dart';
import 'package:run_tracker/ui/recentActivities/RecentActivitiesScreen.dart';
import 'package:run_tracker/ui/runhistorydetails/RunHistoryDetailScreen.dart';
import 'package:run_tracker/ui/stepsTracker/StepsTrackerScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Utils.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../common/commonTopBar/CommonTopBar.dart';
import '../../interfaces/TopBarClickListener.dart';
import '../../localization/language/languages.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    implements TopBarClickListener {
  bool homeSelected = true;
  bool profileSelected = false;
  bool recentActivityShow = false;
  List<RunningData> recentActivitiesData = [];
  int totalrecentActivity = 0;

  @override
  void initState() {
    _checkMapData();
    _getBestRecordsDataForDistance();
    _getBestRecordsDataForBestPace();
    _getBestRecordsDataForLongestDuration();
    super.initState();
  }

  RunningData? longestDistance;

  _getBestRecordsDataForDistance() async {
    longestDistance = await DataBaseHelper.getMaxDistance();
    Debug.printLog(
        "Longest Distance =====>" + longestDistance!.distance.toString());
    setState(() {});
    return longestDistance!;
  }

  RunningData? bestPace;

  _getBestRecordsDataForBestPace() async {
    bestPace = await DataBaseHelper.getMaxPace();
    Debug.printLog("Max Pace =====>" + bestPace!.speed.toString());
    setState(() {});
    return bestPace!;
  }

  RunningData? longestDuration;

  _getBestRecordsDataForLongestDuration() async {
    longestDuration = await DataBaseHelper.getLongestDuration();
    Debug.printLog(
        "Longest Duration =====>" + longestDuration!.duration.toString());
    setState(() {});
    return longestDuration!;
  }

  _checkMapData() async {
    final result = await DataBaseHelper().getRecentTasksAsStream();
    recentActivitiesData.addAll(result);

    if (result.isEmpty || result.length == 0) {
      setState(() {
        recentActivityShow = false;
      });
    } else {
      setState(() {
        recentActivityShow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    child: Column(
                      children: [
                        //Topbar
                        Container(
                          margin: EdgeInsets.only(left: fullWidth * 0.05),
                          child: CommonTopBar(
                            Languages.of(context)!.txtRunTracker,
                            this,
                            isShowSubheader: true,
                            subHeader:
                                Languages.of(context)!.txtGoFasterSmarter,
                            isInfo: true,
                          ),
                        ),

                        //Circular percent Indicator
                        Container(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: fullHeight * 0.04),
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
            ),
          ],
        ),
      ),
    );
  }

  walkOrRunCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Row(
            children: [
              Image.asset(
                "assets/icons/ic_person_walk.png",
                height: 30, //20
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                "0",
                style: TextStyle(
                    color: Colur.txt_grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 22 //18
                    ),
              ),
              Text(
                "/300min",
                style: TextStyle(
                    color: Colur.txt_grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 18 //12
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
              SizedBox(
                width: 12,
              ),
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

  percentIndicator() {
    return SfRadialGauge(
        title: GaugeTitle(
            text: Languages.of(context)!.txtHeartHealth,
            textStyle: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                color: Colur.white)),
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
                  gradient: SweepGradient(colors: [
                    Colur.purple_gradient_color1,
                    Colur.purple_gradient_color2
                  ]),
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
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Colur.txt_white),
                          ),
                          Text(
                            "This Week",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colur.txt_grey),
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
          padding: EdgeInsets.only(right: fullWidth * 0.12),
          child: IconButton(
              icon: Icon(
                Icons.home_rounded,
                size: fullHeight * 0.04,
                color: homeSelected
                    ? Colur.purple_gradient_color2
                    : Colur.txt_grey,
              ),
              onPressed: () {
                setState(() {
                  homeSelected = true;
                  profileSelected = false;
                });
                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen())); //TODO: Uncomment
              }),
        ),
        Padding(
          padding: EdgeInsets.only(left: fullWidth * 0.12),
          child: IconButton(
              icon: Icon(
                Icons.person,
                size: fullHeight * 0.04,
                color: profileSelected
                    ? Colur.purple_gradient_color2
                    : Colur.txt_grey,
              ),
              onPressed: () {
                setState(() {
                  profileSelected = true;
                  homeSelected = false;
                });
              }),
        ),
      ],
    );
  }

  bestRecords(double fullHeight, double fullWidth) {
    return Padding(
      padding: EdgeInsets.only(
          top: fullHeight * 0.001,
          left: fullWidth * 0.05,
          right: fullWidth * 0.05),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Languages.of(context)!.txtBestRecords,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colur.txt_white),
                ),
              ],
            ),
            SizedBox(
              height: 21,
            ),
            bestRecordList()
          ],
        ),
      ),
    );
  }

  bestRecordList() {
    return Container(
      child: Column(
        children: [
          bestRecordListTile(
              img: "ic_distance.webp",
              text: Languages.of(context)!.txtLongestDistance,
              value: (longestDistance != null)
                  ? longestDistance!.distance.toString()
                  : "0.0",
              unit: "mile",
              isNotDuration: true),
          bestRecordListTile(
              img: "ic_best_pace.png",
              text: Languages.of(context)!.txtBestPace,
              value: (bestPace != null) ? bestPace!.speed!.toString() : "0.0",
              unit: "min/mi",
              isNotDuration: true),
          bestRecordListTile(
              img: "ic_duration.webp",
              text: Languages.of(context)!.txtLongestDuration,
              value: (longestDuration != null)
                  ? Utils.secToString(longestDuration!.duration!)
                  : "0:0",
              isNotDuration: false),
        ],
      ),
    );
  }

  bestRecordListTile(
      {String? img,
      required String text,
      required String value,
      String? unit,
      required bool isNotDuration}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colur.progress_background_color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            children: [
              Image.asset(
                "assets/icons/$img",
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
                      text,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colur.txt_white),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: Colur.txt_purple),
                        ),
                        Visibility(
                          visible: isNotDuration,
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 5.0, bottom: 3.0),
                            child: Text(
                              isNotDuration ? unit! : "",
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.txt_purple,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                              //maxLines: 1,
                            ),
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
    );
  }

  recentActivities(double fullHeight, double fullWidth) {
    return Visibility(
      visible: recentActivityShow,
      child: Container(
        margin: EdgeInsets.only(
            top: fullHeight * 0.03,
            left: fullWidth * 0.05,
            right: fullWidth * 0.05),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Languages.of(context)!.txtRecentActivities,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colur.txt_white),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecentActivitiesScreen()));
                  },
                  child: Text(
                    Languages.of(context)!.txtMore,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colur.txt_purple),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 21,
            ),
            recentActivitiesList(fullHeight)
          ],
        ),
      ),
    );
  }

  recentActivitiesList(double fullHeight) {
    return Container(
      child: ListView.builder(
          itemCount: recentActivitiesData.length,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.05),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return _activitiesView(context, index, fullHeight);
          }),
    );
  }

  _activitiesView(BuildContext context, int index, double fullheight) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RunHistoryDetailScreen(recentActivitiesData[index])));
        //recentActivitiesData[index]
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
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
                child: Image.file(
                  recentActivitiesData[index].getImage()!,
                  errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                  ) {
                    return Image.asset(
                      "assets/icons/ic_route_map.png",
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    );
                  },
                  height: 90,
                  width: 90,
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recentActivitiesData[index].date!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colur.txt_white),
                      ),
                      Row(
                        children: [
                          Text(
                            recentActivitiesData[index].distance!.toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 21,
                                color: Colur.txt_white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 4),
                            child: Text(
                              Languages.of(context)!.txtMile,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colur.txt_white),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: fullheight * 0.01),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Utils.secToString(
                                  recentActivitiesData[index].duration!),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colur.txt_grey),
                            ),
                            Text(
                              recentActivitiesData[index].speed!.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colur.txt_grey),
                            ),
                            Row(
                              children: [
                                Text(
                                  recentActivitiesData[index].cal!.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Colur.txt_grey),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    Languages.of(context)!.txtKcal,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                        color: Colur.txt_grey),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  recentActivitiesListTile(
      {required double fullHeight,
      String? img,
      required String date,
      required String distance,
      required String time,
      required String pace,
      required String calories}) {
    return;
  }

  stepNdWaterBtns(double fullHeight, double fullWidth) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StepsTrackerScreen()));
              },
              child: Image.asset("assets/icons/ic_steps.png",
                  height: 90, width: fullWidth * 0.385)),
          SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DrinkWaterLevelScreen()));
              },
              child: Image.asset("assets/icons/ic_water.png",
                  height: 90, width: fullWidth * 0.385)),
        ],
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_INFO) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => GoalSettingScreen()));
    }
  }
}
