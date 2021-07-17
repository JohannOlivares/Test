import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:run_tracker/custom/GradientButtonSmall.dart';
import 'package:run_tracker/utils/Debug.dart';

import '../../localization/language/languages.dart';
import '../../utils/Color.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color barBackgroundColor = Colur.common_bg_dark;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  var currentDate = DateTime.now();
  var currentDay = DateFormat('EEEE').format(DateTime.now());
  var startDateOfWeek;
  var endDateOfWeek;
  var formatStartDateOfWeek;
  var formatEndDateOfWeek;

  @override
  void initState() {
    startDateOfWeek =
        getDate(currentDate.subtract(Duration(days: currentDate.weekday - 1)));
    endDateOfWeek = getDate(currentDate
        .add(Duration(days: DateTime.daysPerWeek - currentDate.weekday)));
    formatStartDateOfWeek = DateFormat.MMMd('en_US').format(startDateOfWeek);
    formatEndDateOfWeek = DateFormat.MMMd('en_US').format(endDateOfWeek);
    Debug.printLog("currentDate ==>" + currentDate.toString());
    Debug.printLog("currentDay ==>" + currentDay.toString());
    Debug.printLog("startDateOfWeek ==>" + startDateOfWeek.toString());
    Debug.printLog("endDateOfWeek ==>" + endDateOfWeek.toString());
    Debug.printLog(
        "formatStartDateOfWeek ==>" + formatStartDateOfWeek.toString());
    Debug.printLog("formatEndDateOfWeek ==>" + formatEndDateOfWeek.toString());
    super.initState();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _runTrackerWidget(context),
                    _progressWidget(context),
                    _drinkWaterWidget(context),
                    _bestRecordWidget(context),
                    _fastestTimeWidget(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _runTrackerWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colur.rounded_rectangle_color,
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            Languages.of(context)!.txtRunTracker,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colur.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 25),
                            //maxLines: 1,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colur.grad_yellow_light,
                                      Colur.grad_yellow_dark,
                                    ]),
                                borderRadius: BorderRadius.circular(3.0)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.5, horizontal: 5.0),
                            child: Text(
                              Languages.of(context)!.txtPro.toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colur.txt_black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                              //maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          Languages.of(context)!.txtGoFasterSmarter,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.txt_grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          //maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colur.gray_border,
                      width: 1,
                    ),
                  ),
                  child: Image.asset(
                    "assets/icons/ic_setting_round.png",
                    scale: 4,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    "assets/icons/ic_round_true.webp",
                    scale: 4.2,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      Languages.of(context)!.txtRemoveAddForever,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      //maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    "assets/icons/ic_round_true.webp",
                    scale: 4.2,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      Languages.of(context)!.txtUnlockAllTrainingPlans,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      //maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    "assets/icons/ic_round_true.webp",
                    scale: 4.2,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      Languages.of(context)!.txtDeeperAnalysis,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colur.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      //maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: GradientButtonSmall(
                width: double.infinity,
                height: 50.0,
                radius: 50.0,
                child: Text(
                  Languages.of(context)!.txtStart.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colur.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colur.purple_gradient_color1,
                    Colur.purple_gradient_color2,
                  ],
                ),
                isShadow: false,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  _progressWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      margin: const EdgeInsets.only(top: 8.0),
      width: double.infinity,
      color: Colur.rounded_rectangle_color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Languages.of(context)!.txtMyProgress,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colur.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                  //maxLines: 1,
                ),
              ),
              Text(
                Languages.of(context)!.txtMore.toUpperCase(),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colur.txt_purple,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                //maxLines: 1,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Text(
              "0.00",
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colur.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 50.0),
              //maxLines: 1,
            ),
          ),
          Text(
            Languages.of(context)!.txtTotalKM.toUpperCase(),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colur.white, fontWeight: FontWeight.w500, fontSize: 14),
            //maxLines: 1,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "0.01",
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colur.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 40.0),
                        //maxLines: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        Languages.of(context)!.txtTotalHours.toUpperCase(),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colur.txt_grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                        //maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "4.9",
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colur.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 40.0),
                        //maxLines: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        Languages.of(context)!.txtTotalKCAL.toUpperCase(),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colur.txt_grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                        //maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "0:00",
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colur.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 40.0),
                        //maxLines: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        Languages.of(context)!.txtAvgPace.toUpperCase(),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colur.txt_grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                        //maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _drinkWaterWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      margin: const EdgeInsets.only(top: 8.0),
      width: double.infinity,
      color: Colur.rounded_rectangle_color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Languages.of(context)!.txtDrinkWater,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colur.white, fontWeight: FontWeight.w700, fontSize: 18),
            //maxLines: 1,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
              formatStartDateOfWeek.toString() +
                  " - " +
                  formatEndDateOfWeek.toString(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colur.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.5),
              //maxLines: 1,
            ),
          ),
          Container(
            height: 220,
            margin: EdgeInsets.only(top: 30.0),
            width: double.infinity,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colur.txt_grey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String weekDay;
                        switch (group.x.toInt()) {
                          case 0:
                            weekDay = 'Monday';
                            break;
                          case 1:
                            weekDay = 'Tuesday';
                            break;
                          case 2:
                            weekDay = 'Wednesday';
                            break;
                          case 3:
                            weekDay = 'Thursday';
                            break;
                          case 4:
                            weekDay = 'Friday';
                            break;
                          case 5:
                            weekDay = 'Saturday';
                            break;
                          case 6:
                            weekDay = 'Sunday';
                            break;
                          default:
                            throw Error();
                        }
                        return BarTooltipItem(
                          weekDay + '\n',
                          TextStyle(
                            color: Colur.txt_white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: (rod.y.toInt() - 1).toString(),
                              style: TextStyle(
                                color: Colur.txt_white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }),
                  touchCallback: (barTouchResponse) {
                    setState(() {
                      if (barTouchResponse.spot != null &&
                          barTouchResponse.touchInput is! PointerUpEvent &&
                          barTouchResponse.touchInput is! PointerExitEvent) {
                        touchedIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      } else {
                        touchedIndex = -1;
                      }
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) => const TextStyle(
                        color: Colur.txt_grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    margin: 10,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return currentDay == 'Monday' ? 'Today' : 'Mon';
                        case 1:
                          return currentDay == 'Tuesday' ? 'Today' : 'Tue';
                        case 2:
                          return currentDay == 'Wednesday' ? 'Today' : 'Wed';
                        case 3:
                          return currentDay == 'Thursday' ? 'Today' : 'Thu';
                        case 4:
                          return currentDay == 'Friday' ? 'Today' : 'Fri';
                        case 5:
                          return currentDay == 'Saturday' ? 'Today' : 'Sat';
                        case 6:
                          return currentDay == 'Sunday' ? 'Today' : 'Sun';
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: showingGroups(),
              ),
              swapAnimationDuration: animDuration,
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
              Languages.of(context)!.txtDailyAverage + " : " + "2,000",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colur.txt_purple,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.5),
              //maxLines: 1,
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
              Languages.of(context)!.txtWeek,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colur.txt_white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
              //maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colur.graph_water,
    double width = 40,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colur.white] : [barColor],
          width: width,
          borderRadius: BorderRadius.all(Radius.zero),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 200.0,
            colors: [barBackgroundColor],
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 100.0, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 50.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 80.0, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 70.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 90.0, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 20.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 60.5, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  _bestRecordWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      margin: const EdgeInsets.only(top: 8.0),
      width: double.infinity,
      color: Colur.rounded_rectangle_color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Languages.of(context)!.txtBestRecords,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colur.white, fontWeight: FontWeight.w700, fontSize: 18),
            //maxLines: 1,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colur.common_bg_dark,
                borderRadius: BorderRadius.circular(10.0)),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            margin: const EdgeInsets.only(top: 30.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/ic_distance_light.webp",
                  scale: 3.5,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Languages.of(context)!.txtLongestDistance,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "0",
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colur.txt_purple,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22),
                                //maxLines: 1,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, bottom: 3.0),
                                  child: Text(
                                    Languages.of(context)!.txtMILE.toLowerCase(),
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
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5.0, bottom: 3.0),
                                child: Text(
                                  "Jul 3 09:24",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colur.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                  //maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colur.common_bg_dark,
                borderRadius: BorderRadius.circular(10.0)),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            margin: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/ic_best_pace_light.webp",
                  scale: 3.5,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Languages.of(context)!.txtBestPace,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "0",
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colur.txt_purple,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22),
                                //maxLines: 1,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5.0, bottom: 3.0),
                                child: Text(
                                  Languages.of(context)!.txtMinMi.toLowerCase(),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colur.common_bg_dark,
                borderRadius: BorderRadius.circular(10.0)),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/ic_duration_light.webp",
                  scale: 3.5,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Languages.of(context)!.txtLongestDuration,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  "00.00",
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colur.txt_purple,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22),
                                  //maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5.0, bottom: 3.0),
                                child: Text(
                                  "Jul 3 09:24",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colur.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                  //maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  _fastestTimeWidget(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 50, top: 20),
      child: Theme(
        data: ThemeData(
          accentColor: Colur.txt_purple,
          unselectedWidgetColor: Colur.white,
        ),
        child: ExpansionTile(
          title: Text(
            Languages.of(context)!.txtFastestTime,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colur.white, fontWeight: FontWeight.w700, fontSize: 18),
          ),
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.only(left: 5.0, right: 5.0),
          children: [
            ListView.builder(
              itemCount: 20,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colur.rounded_rectangle_color,
                      borderRadius: BorderRadius.circular(10.0)),
                  margin: EdgeInsets.only(bottom: 20.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/ic_star_blue.png",
                        scale: 3.5,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            Languages.of(context)!.txtBest.toUpperCase() +
                                " 400M",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colur.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      Text(
                        "--",
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colur.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
