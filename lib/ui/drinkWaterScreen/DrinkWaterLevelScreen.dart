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
import 'package:charts_flutter/flutter.dart'as charts;

import 'DataModel/BarChartModel.dart';
import 'DataModel/bar_chart_graph.dart';

class DrinkWaterLevelScreen extends StatefulWidget {
  const DrinkWaterLevelScreen({Key key}) : super(key: key);

  @override
  _DrinkWaterLevelScreenState createState() => _DrinkWaterLevelScreenState();
}

class _DrinkWaterLevelScreenState extends State<DrinkWaterLevelScreen>
    implements TopBarClickListener {
  int waterlevelvalue = 300;
  int maximumLimitOfLevel = 5000;
  int num = 1;
  int valueForIncreament = 100;

  List<BarChartModel> get data => [
    BarChartModel(
      year: "2014",
      financial: 250,
      color: charts.ColorUtil.fromDartColor
        (Colur.water_level_wave2),
    ),
    BarChartModel(
      year: "2015",
      financial: 300,
      color: charts.ColorUtil.fromDartColor
        (Colur.water_level_wave2),
    ),
    BarChartModel(
      year: "2016",
      financial: 100,
      color: charts.ColorUtil.fromDartColor
        (Colur.water_level_wave2),
    ),
    BarChartModel(
      year: "2017",
      financial: 450,
      color: charts.ColorUtil.fromDartColor
        (Colur.water_level_wave2),
    ),
    BarChartModel(
      year: "2018",
      financial: 630,
      color: charts.ColorUtil.fromDartColor
        (Colur.water_level_wave2),
    ),
    BarChartModel(
      year: "2019",
      financial: 1000,
      color: charts.ColorUtil.fromDartColor
        (Colur.water_level_wave2),
    ),
    BarChartModel(
      year: "2020",
      financial: 400,
      color: charts.ColorUtil.fromDartColor
        (Colur.water_level_wave2),
    ),
  ];
  List<charts.Series<BarChartModel, String>> series;
  @override
  void initState() {
    super.initState();
  }

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
                Languages.of(context).txtToday,
                this,
                subHeader: Languages.of(context).txtDrinkWater,
                isShowSubheader: true,
                isShowBack: true,
                isShowSettingCircle: true,
              ),
            ),
            _waterProgressIndicator(fullheight, fullwidth),
            _designForWaterIncrementButton(fullheight, fullwidth),
            _designForWaterMeasureIcon(fullheight, fullwidth),
            _designWeek(fullheight, fullwidth),
            _graph(fullheight, fullwidth),
            _todayHistory(fullheight, fullwidth),
            _reminderHistory(fullheight, fullwidth),
            _history(fullheight, fullwidth,context),
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DrinkWaterSettingsScreen()));
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
              valueForIncreament.toString() + Languages.of(context).txtMl,
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
            Languages.of(context).txtWeek,
            style: TextStyle(
              color: Colur.txt_white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
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
  Widget profileScreenWidget(BuildContext context) {
    series = [
      charts.Series(
      id: "Water Level",
      data: data,
      domainFn: (BarChartModel series, _) => series.year,
      measureFn: (BarChartModel series, _) => series.financial,
      colorFn: (BarChartModel series, _) => series.color,
        /*radiusPxFn: (ChartData series, _) => 0.0,
        strokeWidthPxFn: (ChartData series, _) => 50,
        colorFn: (ChartData series, _) =>
            charts.ColorUtil.fromDartColor(Colur.primary),
        labelAccessorFn: (ChartData series, _) => '${series.points}',
        insideLabelStyleAccessorFn: (ChartData series, _) {
          final color = charts.ColorUtil.fromDartColor(Colur.txt_black);
          return new charts.TextStyleSpec(
              color: color, fontSize: 15, lineHeight: 20);
        },
        outsideLabelStyleAccessorFn: (ChartData series, _) {
          final color = charts.ColorUtil.fromDartColor(Colur.txt_black);
          return new charts.TextStyleSpec(
              color: color, fontSize: 15, lineHeight: 20);
        },*/

      ),
    ];
  }

  _graph(double fullheight, double fullwidth) {
    return Container(
      height: 300,
      margin: EdgeInsets.only(left: 10, right: 10, top: 40),
      width: fullwidth,
      child: /*charts.BarChart(
        series,
        animate: false,
        barRendererDecorator: new charts.BarLabelDecorator<String>(),
        primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(Colur.transparent)),
              labelStyle: charts.TextStyleSpec(
                fontSize: 15,
                color: charts.ColorUtil.fromDartColor(Colur.txt_black),
                fontWeight: const <int, String>{
                  4: 'FontWeight.w400',
                  5: 'FontWeight.w500',
                  6: 'FontWeight.w600',
                  7: 'FontWeight.w700',
                }[5],
                fontFamily: 'SFProDisplay',
              ),
            )),
        domainAxis: new charts.OrdinalAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(
              lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(Colur.transparent)),
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 12,
                  lineHeight: 1.5,
                  fontWeight: const <int, String>{
                    4: 'FontWeight.w400',
                    5: 'FontWeight.w500',
                    6: 'FontWeight.w600',
                    7: 'FontWeight.w700',
                  }[5],
                  fontFamily: 'SFProDisplay',
                  color: charts.ColorUtil.fromDartColor(Colur.txt_black)),
            )),
      ),*/
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        children: [
          BarChartGraph(
            data: data,
          ),

        ],
      ),

    );
  }

  _todayHistory(double fullheight, double fullwidth) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 50),
      child: Row(
        children: [
          Container(
            child: Text(
              Languages.of(context).txtTodayRecords,
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
                          Languages.of(context).txtNextTime,
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
                    "100"+" "+Languages.of(context).txtMl,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colur.txt_grey),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child:Image.asset("assets/icons/ic_more.webp",scale: 3.5,)
                ),


              ],
            ),
          )
        ],
      ),
    );
  }

  _history(double fullheight, double fullwidth,BuildContext context) {
    return ListView.builder(
        itemCount:
        9,
        padding: EdgeInsets.only(
            bottom: 5),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _listTileofHistory(context, index);
        },
    );
  }

  _listTileofHistory(BuildContext context,int index){
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
                    "100"+" "+Languages.of(context).txtMl,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colur.txt_grey),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 20),
                    child:Image.asset("assets/icons/ic_more.webp",scale: 3.5,)
                ),


              ],
            ),
          )
        ],
      ),
    );
  }


}
