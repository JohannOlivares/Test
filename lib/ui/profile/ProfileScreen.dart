import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:run_tracker/custom/GradientButtonSmall.dart';
import 'package:run_tracker/custom/dialogs/AddWeightDialog.dart';
import 'package:run_tracker/dbhelper/DataBaseHelper.dart';
import 'package:run_tracker/dbhelper/datamodel/WaterData.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Preference.dart';

import '../../localization/language/languages.dart';
import '../../utils/Color.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int touchedIndexForWaterChart = -1;
  int touchedIndexForHartHealthChart = -1;

  var currentDate = DateTime.now();
  var currentDay = DateFormat('EEEE').format(DateTime.now());
  var startDateOfCurrentWeek;
  var endDateOfCurrentWeek;
  var formatStartDateOfCurrentWeek;
  var formatEndDateOfCurrentWeek;
  var startDateOfPreviousWeek;
  var endDateOfPreviousWeek;
  var formatStartDateOfPreviousWeek;
  var formatEndDateOfPreviousWeek;

  bool isNextWeek = false;
  bool isPreviousWeek = false;

  @override
  void initState() {
    DataBaseHelper().selectWeight();
    _getPreference();
    _getChartDataForDrinkWater();
    _getDailyDrinkWaterAverage();
    startDateOfCurrentWeek =
        getDate(currentDate.subtract(Duration(days: currentDate.weekday - 1)));
    endDateOfCurrentWeek = getDate(currentDate
        .add(Duration(days: DateTime.daysPerWeek - currentDate.weekday)));
    formatStartDateOfCurrentWeek =
        DateFormat.MMMd('en_US').format(startDateOfCurrentWeek);
    formatEndDateOfCurrentWeek =
        DateFormat.MMMd('en_US').format(endDateOfCurrentWeek);

    startDateOfPreviousWeek = getDate(
        currentDate.subtract(Duration(days: (currentDate.weekday - 1) + 7)));
    endDateOfPreviousWeek = getDate(currentDate
        .add(Duration(days: (DateTime.daysPerWeek - currentDate.weekday) - 7)));
    formatStartDateOfPreviousWeek =
        DateFormat.MMMd('en_US').format(startDateOfPreviousWeek);
    formatEndDateOfPreviousWeek =
        DateFormat.MMMd('en_US').format(endDateOfPreviousWeek);

    isPreviousWeek = true;
    isNextWeek = false;

    Debug.printLog("currentDate ==>" + currentDate.toString());
    Debug.printLog("currentDay ==>" + currentDay.toString());

    Debug.printLog(
        "startDateOfCurrentWeek ==>" + startDateOfCurrentWeek.toString());
    Debug.printLog(
        "endDateOfCurrentWeek ==>" + endDateOfCurrentWeek.toString());
    Debug.printLog("formatStartDateOfCurrentWeek ==>" +
        formatStartDateOfCurrentWeek.toString());
    Debug.printLog("formatEndDateOfCurrentWeek ==>" +
        formatEndDateOfCurrentWeek.toString());

    Debug.printLog(
        "startDateOfPreviousWeek ==>" + startDateOfPreviousWeek.toString());
    Debug.printLog(
        "endDateOfPreviousWeek ==>" + endDateOfPreviousWeek.toString());
    Debug.printLog("formatStartDateOfPreviousWeek ==>" +
        formatStartDateOfPreviousWeek.toString());
    Debug.printLog("formatEndDateOfPreviousWeek ==>" +
        formatEndDateOfPreviousWeek.toString());

    super.initState();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  var prefTargetValue;
  int? maxLimitOfDrinkWater;

  _getPreference() {
    prefTargetValue =
        Preference.shared.getString(Preference.TARGET_DRINK_WATER);
    setState(() {
      if (prefTargetValue == null) {
        maxLimitOfDrinkWater = 2000;
      } else {
        maxLimitOfDrinkWater = int.parse(prefTargetValue);
      }
    });
  }

  List<WaterData>? total;
  Map<String, int> map = {};

  _getChartDataForDrinkWater() async {
    List<String> dates = [];
    for (int i = 0; i <= 6; i++) {
      var currentWeekDates = getDate(DateTime.now()
          .subtract(Duration(days: currentDate.weekday - 1))
          .add(Duration(days: i)));
      String formatCurrentWeekDates = DateFormat.yMd().format(currentWeekDates);
      dates.add(formatCurrentWeekDates);
    }
    total = await DataBaseHelper().getTotalDrinkWaterAllDays(dates);

    for (int i = 0; i < dates.length; i++) {
      bool isMatch = false;
      total!.forEach((element) {
        if (element.date == dates[i]) {
          map.putIfAbsent(element.date!, () => element.total!);
          isMatch = true;
        }
      });
      if (!isMatch) map.putIfAbsent(dates[i], () => 0);
    }
    setState(() {});
  }

  String? drinkWaterAverage;

  _getDailyDrinkWaterAverage() async {
    List<String> dates = [];
    for (int i = 0; i <= 6; i++) {
      var currentWeekDates = getDate(DateTime.now()
          .subtract(Duration(days: currentDate.weekday - 1))
          .add(Duration(days: i)));
      String formatCurrentWeekDates = DateFormat.yMd().format(currentWeekDates);
      dates.add(formatCurrentWeekDates);
    }
    int? average = await DataBaseHelper().getTotalDrinkWaterAverage(dates);
    drinkWaterAverage = (average! ~/ 7).toString();
    setState(() {});
    Debug.printLog("drinkWaterAverage =====>" + drinkWaterAverage!);
  }

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
                    _heartHealthWidget(context),
                    _weightWidget(context),
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

  _heartHealthWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      margin: const EdgeInsets.only(top: 8.0),
      width: double.infinity,
      color: Colur.rounded_rectangle_color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Languages.of(context)!.txtHeartHealth,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isPreviousWeek)
                  InkWell(
                    onTap: () {
                      setState(() {
                        isPreviousWeek = false;
                        isNextWeek = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 16.0,
                        color: Colur.txt_purple,
                      ),
                    ),
                  ),
                Text(
                  (!isPreviousWeek && isNextWeek)
                      ? formatStartDateOfPreviousWeek.toString() +
                          " - " +
                          formatEndDateOfPreviousWeek.toString()
                      : formatStartDateOfCurrentWeek.toString() +
                          " - " +
                          formatEndDateOfCurrentWeek.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colur.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.5),
                  //maxLines: 1,
                ),
                if (isNextWeek)
                  InkWell(
                    onTap: () {
                      setState(() {
                        isPreviousWeek = true;
                        isNextWeek = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0,
                        color: Colur.txt_purple,
                      ),
                    ),
                  ),
              ],
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
                            weekDay = Languages.of(context)!.txtMonday;
                            break;
                          case 1:
                            weekDay = Languages.of(context)!.txtTuesday;
                            break;
                          case 2:
                            weekDay = Languages.of(context)!.txtWednesday;
                            break;
                          case 3:
                            weekDay = Languages.of(context)!.txtThursday;
                            break;
                          case 4:
                            weekDay = Languages.of(context)!.txtFriday;
                            break;
                          case 5:
                            weekDay = Languages.of(context)!.txtSaturday;
                            break;
                          case 6:
                            weekDay = Languages.of(context)!.txtSunday;
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
                        touchedIndexForHartHealthChart =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      } else {
                        touchedIndexForHartHealthChart = -1;
                      }
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) {
                      switch (value.toInt()) {
                        case 0:
                          return currentDay == Languages.of(context)!.txtMonday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 1:
                          return currentDay == Languages.of(context)!.txtTuesday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 2:
                          return currentDay ==
                                  Languages.of(context)!.txtWednesday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 3:
                          return currentDay ==
                                  Languages.of(context)!.txtThursday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 4:
                          return currentDay == Languages.of(context)!.txtFriday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 5:
                          return currentDay ==
                                  Languages.of(context)!.txtSaturday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 6:
                          return currentDay == Languages.of(context)!.txtSunday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        default:
                          return _unSelectedTextStyle();
                      }
                    },
                    margin: 10,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return currentDay == Languages.of(context)!.txtMonday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtMon;
                        case 1:
                          return currentDay == Languages.of(context)!.txtTuesday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtTue;
                        case 2:
                          return currentDay ==
                                  Languages.of(context)!.txtWednesday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtWed;
                        case 3:
                          return currentDay ==
                                  Languages.of(context)!.txtThursday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtThu;
                        case 4:
                          return currentDay == Languages.of(context)!.txtFriday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtFri;
                        case 5:
                          return currentDay ==
                                  Languages.of(context)!.txtSaturday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtSat;
                        case 6:
                          return currentDay == Languages.of(context)!.txtSunday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtSun;
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    margin: 5,
                    interval: 100,
                    getTextStyles: (value) => const TextStyle(
                        color: Colur.txt_grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                        bottom:
                            BorderSide(width: 1, color: Colur.gray_border))),
                barGroups: showingHeartHealthGroups(),
              ),
              swapAnimationCurve: Curves.ease,
              swapAnimationDuration: Duration(seconds: 0),
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

  BarChartGroupData makeHeartHealthGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colur.graph_health,
    double width = 32,
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
            colors: [Colur.common_bg_dark],
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingHeartHealthGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeHeartHealthGroupData(0, 100.0,
                isTouched: i == touchedIndexForHartHealthChart);
          case 1:
            return makeHeartHealthGroupData(1, 50.5,
                isTouched: i == touchedIndexForHartHealthChart);
          case 2:
            return makeHeartHealthGroupData(2, 80.0,
                isTouched: i == touchedIndexForHartHealthChart);
          case 3:
            return makeHeartHealthGroupData(3, 70.5,
                isTouched: i == touchedIndexForHartHealthChart);
          case 4:
            return makeHeartHealthGroupData(4, 90.0,
                isTouched: i == touchedIndexForHartHealthChart);
          case 5:
            return makeHeartHealthGroupData(5, 20.5,
                isTouched: i == touchedIndexForHartHealthChart);
          case 6:
            return makeHeartHealthGroupData(6, 60.5,
                isTouched: i == touchedIndexForHartHealthChart);
          default:
            return throw Error();
        }
      });

  _selectedTextStyle() {
    return const TextStyle(
        color: Colur.txt_white, fontWeight: FontWeight.w400, fontSize: 14);
  }

  _unSelectedTextStyle() {
    return const TextStyle(
        color: Colur.txt_grey, fontWeight: FontWeight.w400, fontSize: 14);
  }

  _weightWidget(BuildContext context) {
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
                  Languages.of(context)!.txtWeight,
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
              InkWell(
                onTap: (){
                  showDialog(context: context, builder: (context) => AddWeightDialog());
                },
                child: Text(
                  Languages.of(context)!.txtAdd.toUpperCase(),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colur.txt_purple,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                  //maxLines: 1,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
              0.0.toString() + Languages.of(context)!.txtKG.toLowerCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colur.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
              //maxLines: 1,
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 5.0),
            child: Text(
              Languages.of(context)!.txtLast30Days,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colur.txt_grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
              //maxLines: 1,
            ),
          ),
          Container(
            height: 200,
            margin: EdgeInsets.only(top: 20.0),
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 200,
                padding: const EdgeInsets.only(
                    bottom: 0.0, right: 10.0, left: 10.0, top: 0.0),
                width: MediaQuery.of(context).size.width * 3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
                child: LineChart(
                  mainData(),
                  swapAnimationDuration: Duration(seconds: 0),
                  swapAnimationCurve: Curves.ease,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colur.txt_grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          getTextStyles: (value) => const TextStyle(
              color: Colur.txt_grey, fontWeight: FontWeight.w500, fontSize: 14),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '1';
              case 1:
                return '2';
              case 2:
                return '3';
              case 3:
                return '4';
              case 4:
                return '5';
              case 5:
                return '6';
              case 6:
                return '7';
              case 7:
                return '8';
              case 8:
                return '9';
              case 9:
                return '10';
              case 10:
                return '11';
              case 11:
                return '12';
              case 12:
                return '13';
              case 13:
                return '14';
              case 14:
                return '15';
              case 15:
                return '16';
              case 16:
                return '17';
              case 17:
                return '18';
              case 18:
                return '19';
              case 19:
                return '20';
              case 20:
                return '21';
              case 21:
                return '22';
              case 22:
                return '23';
              case 23:
                return '24';
              case 24:
                return '25';
              case 25:
                return '26';
              case 26:
                return '27';
              case 27:
                return '28';
              case 28:
                return '29';
              case 29:
                return '30';
              case 30:
                return '31';
            }
            return '';
          },
          margin: 0,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colur.txt_grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          margin: 15.0,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '2';
              case 2:
                return '4';
              case 3:
                return '6';
            }
            return '';
          },
          reservedSize: 5,
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 31,
      minY: 0,
      maxY: 4,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 1),
            FlSpot(1, 2),
            FlSpot(2, 3),
            FlSpot(3, 3),
            FlSpot(4, 1),
            FlSpot(5, 2),
            FlSpot(6, 3),
            FlSpot(7, 1),
            FlSpot(8, 2),
            FlSpot(9, 3),
            FlSpot(10, 3),
            FlSpot(11, 1),
            FlSpot(12, 2),
            FlSpot(13, 3),
            FlSpot(14, 1),
            FlSpot(15, 2),
            FlSpot(16, 3),
            FlSpot(17, 3),
            FlSpot(18, 1),
            FlSpot(19, 2),
            FlSpot(20, 3),
            FlSpot(21, 1),
            FlSpot(22, 2),
            FlSpot(23, 3),
            FlSpot(24, 1),
            FlSpot(25, 2),
            FlSpot(26, 3),
            FlSpot(27, 3),
            FlSpot(28, 1),
            FlSpot(29, 2),
            FlSpot(30, 3),
          ],
          isCurved: false,
          colors: Colur.gradient_for_weight_colors,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
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
              formatStartDateOfCurrentWeek.toString() +
                  " - " +
                  formatEndDateOfCurrentWeek.toString(),
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
                            weekDay = Languages.of(context)!.txtMonday;
                            break;
                          case 1:
                            weekDay = Languages.of(context)!.txtTuesday;
                            break;
                          case 2:
                            weekDay = Languages.of(context)!.txtWednesday;
                            break;
                          case 3:
                            weekDay = Languages.of(context)!.txtThursday;
                            break;
                          case 4:
                            weekDay = Languages.of(context)!.txtFriday;
                            break;
                          case 5:
                            weekDay = Languages.of(context)!.txtSaturday;
                            break;
                          case 6:
                            weekDay = Languages.of(context)!.txtSunday;
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
                        touchedIndexForWaterChart =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      } else {
                        touchedIndexForWaterChart = -1;
                      }
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) {
                      switch (value.toInt()) {
                        case 0:
                          return currentDay == Languages.of(context)!.txtMonday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 1:
                          return currentDay == Languages.of(context)!.txtTuesday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 2:
                          return currentDay ==
                                  Languages.of(context)!.txtWednesday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 3:
                          return currentDay ==
                                  Languages.of(context)!.txtThursday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 4:
                          return currentDay == Languages.of(context)!.txtFriday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 5:
                          return currentDay ==
                                  Languages.of(context)!.txtSaturday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        case 6:
                          return currentDay == Languages.of(context)!.txtSunday
                              ? _selectedTextStyle()
                              : _unSelectedTextStyle();
                        default:
                          return _unSelectedTextStyle();
                      }
                    },
                    margin: 10,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return currentDay == Languages.of(context)!.txtMonday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtMon;
                        case 1:
                          return currentDay == Languages.of(context)!.txtTuesday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtTue;
                        case 2:
                          return currentDay ==
                                  Languages.of(context)!.txtWednesday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtWed;
                        case 3:
                          return currentDay ==
                                  Languages.of(context)!.txtThursday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtThu;
                        case 4:
                          return currentDay == Languages.of(context)!.txtFriday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtFri;
                        case 5:
                          return currentDay ==
                                  Languages.of(context)!.txtSaturday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtSat;
                        case 6:
                          return currentDay == Languages.of(context)!.txtSunday
                              ? Languages.of(context)!.txtToday
                              : Languages.of(context)!.txtSun;
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
                barGroups: showingDrinkWaterGroups(),
              ),
              swapAnimationCurve: Curves.ease,
              swapAnimationDuration: Duration(seconds: 0),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
              drinkWaterAverage != null
                  ? Languages.of(context)!.txtDailyAverage +
                      " : " +
                      drinkWaterAverage!
                  : Languages.of(context)!.txtDailyAverage + " :0",
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

  BarChartGroupData makeDrinkWaterGroupData(
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
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
              topLeft: Radius.circular(3.0),
              topRight: Radius.circular(3.0)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxLimitOfDrinkWater!.toDouble(),
            colors: [Colur.common_bg_dark],
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingDrinkWaterGroups() {
    List<BarChartGroupData> list = [];

    for (int i = 0; i < map.length; i++) {
      list.add(makeDrinkWaterGroupData(
          i, map.entries.toList()[i].value.toDouble(),
          isTouched: i == touchedIndexForWaterChart));
    }

    return list;
  }

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
                                    Languages.of(context)!
                                        .txtMILE
                                        .toLowerCase(),
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
          initiallyExpanded: true,
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
