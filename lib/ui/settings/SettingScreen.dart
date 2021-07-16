import 'package:flutter/material.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    implements TopBarClickListener {

  List<String> units;
  String _chosenValue;

  @override
  Widget build(BuildContext context) {

    units = [Languages.of(context).txtKM, Languages.of(context).txtMILE];
    if (_chosenValue == null) _chosenValue = units[0];

    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              //Top Bar
              Container(
                child: CommonTopBar(
                  Languages.of(context).txtSettings,
                  this,
                  isShowBack: true,
                ),
              ),
             /* Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        Languages.of(context).txtTroubleShooting,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colur.txt_white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Image.asset(
                      "assets/icons/ic_trouble_shooting.png",
                      scale: 4,
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colur.txt_grey,
                indent: 20.0,
                endIndent: 20.0,
              ),*/
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        Languages.of(context).txtMetricAndImperialUnits,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colur.txt_white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    DropdownButton<String>(
                      value: _chosenValue,
                      elevation: 2,
                      style: TextStyle(color: Colur.white),
                      iconEnabledColor: Colur.white,
                      iconDisabledColor: Colur.white,
                      dropdownColor: Colur.progress_background_color,
                      underline: Container(
                        color: Colur.transparent,
                      ),
                      isDense: true,

                      items:
                          units.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          _chosenValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    Navigator.of(context).pop();
  }
}