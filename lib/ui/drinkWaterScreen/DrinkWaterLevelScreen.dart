import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/custom/waterLevel/Liquid_progress_indicator.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/drinkWaterSettings/DrinkWaterSettingsScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Utils.dart';
import 'package:intl/intl.dart';

class DrinkWaterLevelScreen extends StatefulWidget {
  const DrinkWaterLevelScreen({Key? key}) : super(key: key);

  @override
  _DrinkWaterLevelScreenState createState() => _DrinkWaterLevelScreenState();
}

class _DrinkWaterLevelScreenState extends State<DrinkWaterLevelScreen>
    implements TopBarClickListener {
  int waterlevelvalue = 300;
  int maximumLimitOfLevel = 5000;
  int num = 1;
  int valueForIncreament = 100;

  final Color barBackgroundColor = Colur.rounded_rectangle_color;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndexForWaterChart = -1;

  var currentDate = DateTime.now();
  var currentDay = DateFormat('EEEE').format(DateTime.now());
  var startDateOfCurrentWeek;
  var endDateOfCurrentWeek;
  var formatStartDateOfCurrentWeek;
  var formatEndDateOfCurrentWeek;

  @override
  void initState() {
    startDateOfCurrentWeek =
        getDate(currentDate.subtract(Duration(days: currentDate.weekday - 1)));
    endDateOfCurrentWeek = getDate(currentDate
        .add(Duration(days: DateTime.daysPerWeek - currentDate.weekday)));
    formatStartDateOfCurrentWeek =
        DateFormat.MMMd('en_US').format(startDateOfCurrentWeek);
    formatEndDateOfCurrentWeek =
        DateFormat.MMMd('en_US').format(endDateOfCurrentWeek);

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
    super.initState();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    var fullheight = MediaQuery.of(context).size.height;
    var fullwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: CommonTopBar(
                Languages.of(context)!.txtToday,
                this,
                subHeader: Languages.of(context)!.txtDrinkWater,
                isShowSubheader: true,
                isShowBack: true,
                isShowSettingCircle: true,
              ),
            ),
            _waterProgressIndicator(fullheight, fullwidth),
            _designForWaterIncrementButton(fullheight, fullwidth),
            _designForWaterMeasureIcon(fullheight, fullwidth),
            _designWeek(fullheight, fullwidth),
            _drinkWaterWidget(context),
            _todayHistory(fullheight, fullwidth),
            _reminderHistory(fullheight, fullwidth),
            _history(fullheight, fullwidth, context),
          ],
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.pop(context);
    }
    if (name == Constant.STR_SETTING_CIRCLE) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DrinkWaterSettingsScreen()));
    }
  }

  _waterProgressIndicator(double fullheight, double fullwidth) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 250,
      width: 250,
      child: LiquidCircularProgressIndicator(
          value: waterlevelvalue / maximumLimitOfLevel,
          // Defaults to 0.5.
          valueColor: AlwaysStoppedAnimation(Colur.water_level_wave2),
          //Color(0x9000AEFF)
          // Defaults to the current Theme's accentColor.
          backgroundColor: Colur.common_bg_dark,
          // Defaults to the current Theme's backgroundColor.
          borderColor: Colur.rounded_rectangle_color,
          borderWidth: 5.0,
          direction: Axis.vertical,
          // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
          center: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 60,
                child: Image.asset(
                  'assets/icons/ic_bottle.png',
                  scale: 4.0,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      waterlevelvalue.toString(),
                      style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "/" + maximumLimitOfLevel.toString(),
                      style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                margin: EdgeInsets.only(bottom: 10),
              )
            ],
          )),
    );
  }

  _designForWaterIncrementButton(double fullheight, double fullwidth) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Image.asset(
              'assets/icons/water/ic_up_arrow.png',
              scale: 2.6,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //For Water Level Increament
              InkWell(
                onTap: () {
                  setState(() {
                    waterlevelvalue = waterlevelvalue + valueForIncreament;
                    Utils.showToast(context, waterlevelvalue.toString());
                  });
                  //Utils.showToast(context, "Increment");
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.all(24),
                  child: Image.asset(
                    'assets/icons/water/ic_plus.png',
                    scale: 2.5,
                  ),
                ),
              ),
              //For Water Level IconCode

              Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.only(left: 6),
                child: Image.asset(
                  _selectedCommonIcon(fullheight, fullwidth, num),
                  scale: 3.5,
                ),
              ),

              //For Water Level Decrement
              InkWell(
                onTap: () {
                  setState(() {
                    int newvalue = waterlevelvalue - valueForIncreament;
                    if (newvalue < 0)
                      waterlevelvalue = 0;
                    else
                      waterlevelvalue = newvalue;
                    Utils.showToast(context, waterlevelvalue.toString());
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(24),
                  margin: EdgeInsets.only(left: 10),
                  child: Image.asset(
                    'assets/icons/water/ic_minus.png',
                    scale: 2.5,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Text(
              valueForIncreament.toString() + Languages.of(context)!.txtMl,
              style: TextStyle(
                  color: Colur.txt_grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ), //TODO
          ),
        ],
      ),
    );
  }

  _designForWaterMeasureIcon(double fullheight, double fullwidth) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                num = 1;
                Debug.printLog("Value ==> $num");
              });
            },
            child: Container(
              child: Image.asset(
                (num == 1)
                    ? 'assets/icons/water/ic_fill_100.png'
                    : 'assets/icons/water/ic_empty_100.png',
                scale: 3.5,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                num = 2;
                Debug.printLog("Value ==> $num");
              });
            },
            child: Container(
              child: Image.asset(
                (num == 2)
                    ? 'assets/icons/water/ic_fill_150.png'
                    : 'assets/icons/water/ic_empty_150.png',
                scale: 3.5,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                num = 3;
                Debug.printLog("Value ==> $num");
              });
            },
            child: Container(
              child: Image.asset(
                (num == 3)
                    ? 'assets/icons/water/ic_fill_250.png'
                    : 'assets/icons/water/ic_empty_250.png',
                scale: 3.5,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                num = 4;
                Debug.printLog("Value ==> $num");
              });
            },
            child: Container(
              child: Image.asset(
                (num == 4)
                    ? 'assets/icons/water/ic_fill_500.png'
                    : 'assets/icons/water/ic_empty_500.png',
                scale: 3.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _designWeek(double fullheight, double fullwidth) {
    return Container(
      child: Column(
        children: [
          Text(
            Languages.of(context)!.txtWeek,
            style: TextStyle(
              color: Colur.txt_white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Colur.water_level_wave1,
            ),
          )
        ],
      ),
    );
  }

  _drinkWaterWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      margin: const EdgeInsets.only(top: 25.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            height: 200,
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
                  color: Colur.graph_water,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.5),
              //maxLines: 1,
            ),
          ),
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

  List<BarChartGroupData> showingDrinkWaterGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeDrinkWaterGroupData(0, 100.0,
                isTouched: i == touchedIndexForWaterChart);
          case 1:
            return makeDrinkWaterGroupData(1, 50.5,
                isTouched: i == touchedIndexForWaterChart);
          case 2:
            return makeDrinkWaterGroupData(2, 80.0,
                isTouched: i == touchedIndexForWaterChart);
          case 3:
            return makeDrinkWaterGroupData(3, 70.5,
                isTouched: i == touchedIndexForWaterChart);
          case 4:
            return makeDrinkWaterGroupData(4, 90.0,
                isTouched: i == touchedIndexForWaterChart);
          case 5:
            return makeDrinkWaterGroupData(5, 20.5,
                isTouched: i == touchedIndexForWaterChart);
          case 6:
            return makeDrinkWaterGroupData(6, 60.5,
                isTouched: i == touchedIndexForWaterChart);
          default:
            return throw Error();
        }
      });

  _todayHistory(double fullheight, double fullwidth) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 50),
      child: Row(
        children: [
          Container(
            child: Text(
              Languages.of(context)!.txtTodayRecords,
              style: TextStyle(
                color: Colur.txt_white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }

  _selectedCommonIcon(double fullheight, double fullwidth, int num) {
    switch (num) {
      case 1:
        valueForIncreament = 100;
        return 'assets/icons/water/ic_fill_100.png';
      case 2:
        valueForIncreament = 150;
        return 'assets/icons/water/ic_fill_150.png';
      case 3:
        valueForIncreament = 250;
        return 'assets/icons/water/ic_fill_250.png';
      case 4:
        valueForIncreament = 500;
        return 'assets/icons/water/ic_fill_500.png';
      default:
        return Utils.showToast(context, "Something Went Wrong in Switch");
        break;
    }
  }

  _reminderHistory(double fullheight, double fullwidth) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 50),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20),
                  height: 20,
                  width: 20,
                  child: Image.asset(
                    'assets/icons/ic_clock_reminder.png',
                    scale: 3.5,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(),
                        child: Text(
                          "${DateFormat().add_jm().format(DateTime.now()).toString()}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colur.txt_white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(),
                        child: Text(
                          Languages.of(context)!.txtNextTime,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colur.txt_grey),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(),
                  child: Text(
                    "100" + " " + Languages.of(context)!.txtMl,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colur.txt_grey),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Image.asset(
                      "assets/icons/ic_more.webp",
                      scale: 3.5,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  _history(double fullheight, double fullwidth, BuildContext context) {
    return ListView.builder(
      itemCount: 9,
      padding: EdgeInsets.only(bottom: 5),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _listTileofHistory(context, index);
      },
    );
  }

  _listTileofHistory(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 50),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20),
                  height: 20,
                  width: 20,
                  child: Image.asset(
                    'assets/icons/water/ic_fill_150.png',
                    scale: 3.5,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(),
                    child: Text(
                      "${DateFormat().add_jm().format(DateTime.now()).toString()}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colur.txt_white),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(),
                  child: Text(
                    "100" + " " + Languages.of(context)!.txtMl,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colur.txt_grey),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Image.asset(
                      "assets/icons/ic_more.webp",
                      scale: 3.5,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
