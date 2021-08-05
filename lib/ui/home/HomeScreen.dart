import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:run_tracker/utils/Preference.dart';
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
  double targetValueForDistance = 0.0;
  bool IsDistanceIndicatorSelected = false;
  bool IsKmSelected = false;
  //Intensity Of Walking
  int walkTime = 150;
  int runTime = 75;


  @override
  void initState() {
    _checkMapData();
    _getPreference();
    _getBestRecordsDataForDistance();
    _getSumOfTotalDistance();
    _getBestRecordsDataForBestPace();
    _getBestRecordsDataForLongestDuration();
    super.initState();
  }

  _getPreference() {
    IsDistanceIndicatorSelected =
        Preference.shared.getBool(Preference.IS_DISTANCE_INDICATOR_ON) ?? false;
    IsKmSelected =
        Preference.shared.getBool(Preference.IS_KM_SELECTED) ?? false;
    targetValueForDistance = Preference.shared
            .getDouble(Preference.TARGETVALUE_FOR_DISTANCE_IN_KM) ?? 0.0;
    walkTime= Preference.shared.getInt(Preference.TARGETVALUE_FOR_WALKTIME)??150;
    runTime= Preference.shared.getInt(Preference.TARGETVALUE_FOR_RUNTIME)??75;
  }

  RunningData? longestDistance;

  _getBestRecordsDataForDistance() async {
    longestDistance = await DataBaseHelper.getMaxDistance();
    Debug.printLog(
        "Longest Distance =====>" + longestDistance!.distance.toString());
    setState(() {});
    return longestDistance!;
  }

  RunningData? SumOfDistance;

  _getSumOfTotalDistance() async {
    SumOfDistance = await DataBaseHelper.getSumOfTotalDistance();
    Debug.printLog("Total Distance =====>" + SumOfDistance!.total.toString());
    setState(() {});
    return SumOfDistance!.total!;
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
            Container(
              margin: EdgeInsets.only(left: fullWidth * 0.05),
              child: CommonTopBar(
                Languages.of(context)!.txtRunTracker,
                this,
                isShowSubheader: true,
                subHeader: Languages.of(context)!.txtGoFasterSmarter,
                isInfo: true,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    child: Column(
                      children: [
                        //Circular percent Indicator
                        Container(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: fullHeight * 0.04),
                                child: IsDistanceIndicatorSelected
                                    ? percentIndicatorForDistance()
                                    : percentIndicatorForIntensity(),
                              ),
                              IsDistanceIndicatorSelected
                                  ? weeklyGoalsDisplay()
                                  : walkOrRunCount(),
                            ],
                          ),
                        ),

                        stepsAndWaterButtons(fullHeight, fullWidth),
                        recentActivities(fullHeight, fullWidth),
                        bestRecords(fullHeight, fullWidth,IsKmSelected),
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

  weeklyGoalsDisplay() {
    Debug.printLog("targetValueForDistance :::=> $targetValueForDistance");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.txtWeekGoal +
              " " +
              (IsKmSelected
                  ? targetValueForDistance.toInt().toString()+" " +Languages.of(context)!.txtKM.toUpperCase()
                  : "${Utils.kmToMile(targetValueForDistance).ceil()}  " +
                      Languages.of(context)!.txtMile.toUpperCase()),
          style: TextStyle(
              color: Colur.txt_grey,
              fontWeight: FontWeight.w400,
              fontSize: 18 //12
              ),
        ),
      ],
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
                "0"+"/",
                style: TextStyle(
                    color: Colur.txt_grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 22 //18
                    ),
              ),
              Text(
                walkTime.toString()+Languages.of(context)!.txtMin,
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
                "0"+"/",
                style: TextStyle(
                  color: Colur.txt_grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 22, //18
                ),
              ),
              Text(
                runTime.toString()+Languages.of(context)!.txtMin,
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

  percentIndicatorForIntensity() {
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
                thickness: 0.19,
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
                  ], startAngle: 23, endAngle: 50),
                  cornerStyle: CornerStyle.bothCurve,
                  width: 0.19,
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
                            "78" + '%',
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Colur.txt_white),
                          ),
                          Text(
                            Languages.of(context)!.txtThisWeek,
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

  percentIndicatorForDistance() {
    return SfRadialGauge(
        title: GaugeTitle(
            text: Languages.of(context)!.txtDistance,
            textStyle: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                color: Colur.white)),
        axes: <RadialAxis>[
          RadialAxis(
              showTicks: false,
              showLabels: false,
              minimum: 0,
              maximum: targetValueForDistance,
              axisLineStyle: AxisLineStyle(
                thickness: 0.19,
                cornerStyle: CornerStyle.bothCurve,
                color: Colur.progress_background_color,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: <GaugePointer>[
                RangePointer(
                  value: (SumOfDistance != null && SumOfDistance!.total != null)
                      ? SumOfDistance!.total!
                      : 0.0,
                  gradient: SweepGradient(
                      colors: [Colur.blue_gredient_1, Colur.blue_gredient_2]),
                  cornerStyle: CornerStyle.bothCurve,
                  width: 0.19,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  (SumOfDistance != null &&
                                          SumOfDistance!.total != null)
                                      ? (IsKmSelected)
                                          ? SumOfDistance!.total!.toStringAsFixed(2)
                                          : Utils.kmToMile(
                                                  SumOfDistance!.total!)
                                              .toStringAsFixed(2)
                                      : "0.0",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 54,
                                      fontWeight: FontWeight.w700,
                                      color: Colur.txt_white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 9),
                                child: Text(
                                  IsKmSelected
                                      ? Languages.of(context)!.txtKM
                                      : Languages.of(context)!.txtMile,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colur.txt_white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
              ])
        ]);
  }

  bestRecords(double fullHeight, double fullWidth,bool IsKmSelected) {
    return Padding(
      padding: EdgeInsets.only(
          top: 30, left: fullWidth * 0.05, right: fullWidth * 0.05),
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
            bestRecordList(IsKmSelected)
          ],
        ),
      ),
    );
  }

  bestRecordList(bool IsKmSelected) {
    return Container(
      child: Column(
        children: [
          bestRecordListTile(
              img: "ic_distance.webp",
              text: Languages.of(context)!.txtLongestDistance,
              value:
                  (longestDistance != null && longestDistance!.distance != null)
                      ? (IsKmSelected)?longestDistance!.distance.toString():Utils.kmToMile(longestDistance!.distance!).toStringAsFixed(2)
                      : "0.0",
              unit: (IsKmSelected)?Languages.of(context)!.txtKM.toUpperCase():Languages.of(context)!.txtMile.toUpperCase(),
              isNotDuration: true),
          bestRecordListTile(
              img: "ic_best_pace.png",
              text: Languages.of(context)!.txtBestPace,
              value: (bestPace != null && bestPace!.speed != null)
                  ? (IsKmSelected)?bestPace!.speed!.toStringAsFixed(2):Utils.minPerKmToMinPerMile(bestPace!.speed!).toStringAsFixed(2)
                  : "0.0",
              unit:(IsKmSelected)?Languages.of(context)!.txtPaceMinPer.toUpperCase()+Languages.of(context)!.txtKM.toUpperCase()+")":Languages.of(context)!.txtPaceMinPer.toUpperCase()+Languages.of(context)!.txtMile.toUpperCase()+")",
              isNotDuration: true),
          bestRecordListTile(
              img: "ic_duration.webp",
              text: Languages.of(context)!.txtLongestDuration,
              value:
                  (longestDuration != null && longestDuration!.duration != null)
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
            top: 30, left: fullWidth * 0.05, right: fullWidth * 0.05),
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
            recentActivitiesList(fullHeight,IsKmSelected)
          ],
        ),
      ),
    );
  }

  recentActivitiesList(double fullHeight,bool IsKmSelected) {
    return Container(
      child: ListView.builder(
          itemCount: recentActivitiesData.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return _activitiesView(context, index, fullHeight,IsKmSelected);
          }),
    );
  }

  _activitiesView(BuildContext context, int index, double fullheight,bool IsKmSelected) {
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
                          (IsKmSelected)?recentActivitiesData[index].distance!.toString():Utils.kmToMile(recentActivitiesData[index].distance!).toStringAsFixed(2),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 21,
                                color: Colur.txt_white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 4),
                            child: Text(
                              (IsKmSelected)?Languages.of(context)!.txtKM:Languages.of(context)!.txtMile,
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
                                (IsKmSelected)?recentActivitiesData[index].speed!.toStringAsFixed(2):Utils.minPerKmToMinPerMile(recentActivitiesData[index].speed!).toStringAsFixed(2),
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

  stepsAndWaterButtons(double fullHeight, double fullWidth) {
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
