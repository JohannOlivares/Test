import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/dbhelper/DataBaseHelper.dart';
import 'package:run_tracker/dbhelper/datamodel/StepsData.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:intl/intl.dart';
import 'package:run_tracker/utils/Debug.dart';

class StepsStatisticsScreen extends StatefulWidget {
  int? currentStepCount;
  StepsStatisticsScreen({this.currentStepCount});
  @override
  _stepsTrackerStatisticsScreenState createState() =>
      _stepsTrackerStatisticsScreenState();
}

class _stepsTrackerStatisticsScreenState
    extends State<StepsStatisticsScreen> implements TopBarClickListener {
  DateTime currentDate = DateTime.now();
  var currentMonth = DateFormat('MM').format(DateTime.now());

  int? daysInMonth;
  List<StepsData>? stepsDataMonth;
  Map<String, int> mapMonth = {};

  int? totalStepsMonth = 0;
  double? avgStepsMonth = 0.0;

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);


  List<StepsData>? stepsDataWeek;

  int? totalStepsWeek = 0;
  double? avgStepsWeek = 0.0;

  var currentDay = DateFormat('EEEE').format(DateTime.now());

  int touchedIndexForStepsChart = -1;

  List<String> weekDates = [];
  Map<String, int> mapWeek = {};

  bool isMonthSelected = false;
  bool isWeekSelected = true;

  @override
  void initState() {
    //Debug.printLog("current month: $currentMonth");
    //Debug.printLog("current step count: ${widget.currentStepCount}");
    getDaysInMonth();
    getChartDataOfStepsForMonth();
    getTotalStepsMonth();

    getChartDataOfStepsForWeek();
    getTotalStepsWeek();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SafeArea(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: CommonTopBar(
                          Languages.of(context)!.txtReport,
                          this,
                          isShowBack: true,
                        ),
                      ),
                      reportWidget(fullHeight, fullWidth, context),
                    ],
                  ),
                ),
              ),
            ),
            selectMonthOrWeek(fullHeight, fullWidth)
          ],
        ),
      ),
    );
  }

  selectMonthOrWeek(double fullHeight, double fullWidth) {
    return Container(
      margin: EdgeInsets.only(bottom: fullHeight*0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isMonthSelected = false;
                isWeekSelected = true;
              });
            },
            child: Container(
              height: fullHeight*0.08,
              width: fullWidth*0.3,
              decoration: isWeekSelected ? BoxDecoration(
                gradient: LinearGradient(colors: [Colur.green_gradient_color1, Colur.green_gradient_color2]),
                borderRadius: BorderRadius.circular(50),
              ):BoxDecoration(
                color: Colur.progress_background_color,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  Languages.of(context)!.txtWeek,
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isMonthSelected = true;
                isWeekSelected = false;
              });
              },
            child: Container(
              height: fullHeight*0.08,
              width: fullWidth*0.3,
              decoration: isMonthSelected ? BoxDecoration(
                gradient: LinearGradient(colors: [Colur.green_gradient_color1, Colur.green_gradient_color2]),
                borderRadius: BorderRadius.circular(50),
              ):BoxDecoration(
                color: Colur.progress_background_color,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  Languages.of(context)!.txtMonth,
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  reportWidget(double fullHeight, double fullWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight * 0.015),
      child: Column(
        children: [
          totalAndAverage(),
          buildStatisticsContainer(fullHeight, fullWidth, context)
        ],
      ),
    );
  }

  buildStatisticsContainer(double fullHeight, double fullWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight * 0.055),
      child: Column(
        children: [
          Text(
            isMonthSelected ? displayMonth() : Languages.of(context)!.txtThisWeek,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colur.txt_grey),
          ),
          isMonthSelected? graphWidgetMonth(fullHeight, fullWidth, context) : graphWidgetWeek(fullHeight, fullWidth, context)
        ],
      ),
    );
  }

  graphWidgetMonth(double fullHeight, double fullWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: fullHeight * 0.05),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.only(
              top: fullHeight * 0.01,
              left: fullWidth * 0.03,
              right: fullWidth * 0.03
          ),
          height: fullHeight * 0.5,
          width: MediaQuery.of(context).size.width * 3,
          child: BarChart(
            BarChartData(
                barTouchData:BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colur.txt_grey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        int day = group.x + 1;
                        return BarTooltipItem(
                          "${day.toString()} ${displayMonth()}"  + '\n',
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
                        touchedIndexForStepsChart =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      } else {
                        touchedIndexForStepsChart = -1;
                      }
                    });
                  },
                ),
                titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: xAxisTitleData(),
                    leftTitles: yAxisTitleData()
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border(

                      left: BorderSide.none,
                        right: BorderSide.none,
                        bottom: BorderSide(
                            width: 1,
                            color: Colur.gray_border)
                    )
                ),
                barGroups: showingStepsGroups()
            ),
            swapAnimationCurve: Curves.ease,
            swapAnimationDuration: Duration(seconds: 0),
          ),
        ),
      ),
    );
  }

  graphWidgetWeek(double fullHeight, double fullWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: fullHeight * 0.05,
      ),
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.only(
            top: fullHeight * 0.01,
            left: fullWidth * 0.03,
            right: fullWidth * 0.03
        ),
        height: fullHeight * 0.5,
        width: MediaQuery.of(context).size.width * 3,
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
                      touchedIndexForStepsChart =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    } else {
                      touchedIndexForStepsChart = -1;
                    }
                  });
                },
              ),
              titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: xAxisTitleData(),
                  leftTitles: yAxisTitleData()
              ),
              borderData: FlBorderData(
                  show: true,
                  border: Border(
                      left: BorderSide.none,
                      top: BorderSide.none,
                      right: BorderSide.none,
                      bottom: BorderSide(
                          width: 1,
                          color: Colur.gray_border)
                  )
              ),
              barGroups: showingStepsGroups()
          ),
          swapAnimationCurve: Curves.ease,
          swapAnimationDuration: Duration(seconds: 0),
        ),
      ),
    );
  }
  
  xAxisTitleData() {
    return SideTitles(
      showTitles: true,
      margin: 20,
      getTextStyles: isMonthSelected ? (value) => _unSelectedTextStyle() : (value) {
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
      getTitles: isMonthSelected ? (value) {
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
          default:
            return '';
        }
        return '';
      } : (double value) {
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
    );
  }

  yAxisTitleData() {
    return SideTitles(
        showTitles: true,
        getTextStyles: (value) =>
        const TextStyle(
          color: Colur.txt_grey,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        margin: 15.0,
        interval: 5000
    );
  }

  getDaysInMonth() {
    if (currentMonth == "01" ||
        currentMonth == "03" ||
        currentMonth == "05" ||
        currentMonth == "07" ||
        currentMonth == "08" ||
        currentMonth == "10" ||
        currentMonth == "12") {
      daysInMonth = 31;
    } else if (currentMonth == "04" ||
        currentMonth == "06" ||
        currentMonth == "09" ||
        currentMonth == "11" ) {
      daysInMonth = 30;
    } else {
      //var year = 2024;
      var year = int.parse(DateFormat.y().format(currentDate));
      Debug.printLog("Year: $year");
      if(year%4 == 0) {
        if(year%100==0) {
          if(year%400==0) {
            daysInMonth = 29;
          } else {
            daysInMonth = 28;
          }
        } else {
          daysInMonth = 29;
        }
      } else {
        daysInMonth = 28;
      }
    }
    
    //Debug.printLog("days in month: $daysInMonth");
  }

  displayMonth () {
    switch(currentMonth) {
      case "01":
        return Languages.of(context)!.txtJanuary;
      case "02":
        return Languages.of(context)!.txtFebruary;
      case "03":
        return Languages.of(context)!.txtMarch;
      case "04":
        return Languages.of(context)!.txtApril;
      case "05":
        return Languages.of(context)!.txtMay;
      case "06":
        return Languages.of(context)!.txtJune;
      case "07":
        return Languages.of(context)!.txtJuly;
      case "08":
        return Languages.of(context)!.txtAugust;
      case "09":
        return Languages.of(context)!.txtSeptember;
      case "10":
        return Languages.of(context)!.txtNovember;
      case "11":
        return Languages.of(context)!.txtDecember;
      case "12":
        return Languages.of(context)!.txtJanuary;
    }
  }

  totalAndAverage() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                Languages.of(context)!.txtTotal,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_grey),
              ),
              Text(
                isMonthSelected ? totalStepsMonth!.toString(): totalStepsWeek!.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colur.txt_white),
              )
            ],
          ),
          Column(
            children: [
              Text(
                Languages.of(context)!.txtAverage,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_grey),
              ),
              Text(
                isMonthSelected ? avgStepsMonth!.toStringAsFixed(2): avgStepsWeek!.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colur.txt_white),
              )
            ],
          )
        ],
      ),
    );
  }

  _selectedTextStyle() {
    return const TextStyle(
        color: Colur.txt_white, fontWeight: FontWeight.w400, fontSize: 14);
  }

  _unSelectedTextStyle() {
    return const TextStyle(
        color: Colur.txt_grey, fontWeight: FontWeight.w400, fontSize: 14);
  }

  List<BarChartGroupData> showingStepsGroups() {
    List<BarChartGroupData> list = [];

    if (isWeekSelected) {
      if (mapWeek.isNotEmpty) {
        for (int i = 0; i <= mapWeek.length-1; i++) {
          list.add(makeBarChartGroupData(i, mapWeek.entries.toList()[i].value.toDouble()));
        }
      } else {
        for (int i = 0; i <= 7; i++) {
          list.add(makeBarChartGroupData(i, 0));
        }
      }
    } else {
      if (mapMonth.isNotEmpty) {
        for (int i = 0; i < mapMonth.length-1; i++) {
          list.add(makeBarChartGroupData(i, mapMonth.entries.toList()[i].value.toDouble()));
        }
      } else {
        for (int i = 0; i <= daysInMonth!; i++) {
          list.add(makeBarChartGroupData(i, 0));
        }
      }
    }
    return list;
  }

  makeBarChartGroupData(int index, double steps) {
    return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: steps+1,
            colors: [Colur.green_gradient_color1, Colur.green_gradient_color2],
            width: 45,
            borderRadius: BorderRadius.all(Radius.zero),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              y: 10000,
              colors: [Colur.common_bg_dark],
            ),
          ),
        ]
    );
  }

  getChartDataOfStepsForMonth() async{
    List<String>? monthDates = [];
    var startDateofMonth = DateTime(currentDate.year, currentDate.month, 1);

    for(int i=0; i <= daysInMonth!; i++) {
      monthDates.add(startDateofMonth.toString());
      var date = startDateofMonth.add(Duration(days: 1));
      startDateofMonth = date;
    }
    stepsDataMonth = await DataBaseHelper().getStepsForCurrentMonth();
    //Debug.printLog("size of monthDates list: ${monthDates.length}");

    for(int i = 0; i<= monthDates.length-1; i++) {
      bool isMatch = false;
      stepsDataMonth!.forEach((element) {
        if(element.stepDate == monthDates[i]) {
          isMatch = true;
          mapMonth.putIfAbsent(element.stepDate!, () => element.steps!);
        }
      });
      if(monthDates[i] == getDate(currentDate).toString()) {
        isMatch = true;
        mapMonth.putIfAbsent(monthDates[i], () => widget.currentStepCount!);
      }
      if(!isMatch) {
        mapMonth.putIfAbsent(monthDates[i], () => 0);
      }
    }
    /*for (int i = 0; i < mapMonth.length; i++) {
      Debug.printLog("Steps[$i]: ${mapMonth.entries.toList()[i].value}");
    }*/

    setState(() { });
  }

  getTotalStepsMonth() async{
    var s = await DataBaseHelper().getTotalStepsForCurrentMonth();
    totalStepsMonth = s! + widget.currentStepCount!;
    //Debug.printLog("Total Steps from current month: $totalStepsMonth");

    avgStepsMonth = (totalStepsMonth!+widget.currentStepCount!)/daysInMonth!;
    //Debug.printLog("Average Steps from current month: $avgStepsMonth");
  }

  getChartDataOfStepsForWeek() async{
    for (int i = 0; i <= 6; i++) {
      var currentWeekDates = getDate(DateTime.now()
          .subtract(Duration(days: currentDate.weekday - 1))
          .add(Duration(days: i)));
      weekDates.add(currentWeekDates.toString());
      // Debug.printLog("date[$i] : ${currentWeekDates.toString()}");
    }
    stepsDataWeek = await DataBaseHelper().getStepsForCurrentWeek();


    for (int i = 0; i < weekDates.length; i++) {
      bool isMatch = false;
      stepsDataWeek!.forEach((element) {
        if (element.stepDate == weekDates[i]) {
          isMatch = true;
          mapWeek.putIfAbsent(element.stepDate!, () => element.steps!);
          //dailySteps!.add(element.steps!);
        }
      });
      if(weekDates[i] == getDate(currentDate).toString()) {
        isMatch = true;
        mapWeek.putIfAbsent(weekDates[i], () => widget.currentStepCount!);
      }
      if(!isMatch) {
        mapWeek.putIfAbsent(weekDates[i], () => 0);
        //dailySteps!.add(0);
      }
    }

    /*for (int i = 0; i < mapWeek.length; i++) {
      Debug.printLog("Steps[$i]: ${mapWeek.entries.toList()[i].value}");
    }*/

    setState(() { });

  }

  getTotalStepsWeek() async{
    var s = await DataBaseHelper().getTotalStepsForCurrentWeek();
    totalStepsWeek = s! + widget.currentStepCount!;
    //Debug.printLog("Total Steps from current week: $totalStepsWeek");

    avgStepsWeek = (totalStepsWeek!+widget.currentStepCount!)/7;
    //Debug.printLog("Average Steps from current week: $avgStepsWeek");
  }



  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.pop(context);
    }
  }
}
