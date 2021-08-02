import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/drinkWaterReminder/DrinkWaterReminderScreen.dart';
import 'package:run_tracker/ui/drinkWaterScreen/DrinkWaterLevelScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Preference.dart';

import '../../common/commonTopBar/CommonTopBar.dart';
import '../../interfaces/TopBarClickListener.dart';
import '../../localization/language/languages.dart';
import '../../utils/Constant.dart';

class DrinkWaterSettingsScreen extends StatefulWidget {
  @override
  _DrinkWaterSettingsScreenState createState() =>
      _DrinkWaterSettingsScreenState();
}

class _DrinkWaterSettingsScreenState extends State<DrinkWaterSettingsScreen>
    implements TopBarClickListener {
  String? targetValue;
  bool isReminder = false;
  late List<String> targetList;
  var fullHeight;
  var fullWidth;
  var prefTargetValue;

  @override
  void initState() {
    targetList = [
      '500',
      '1000',
      '1500',
      '2000',
      '2500',
      '3000',
      '3500',
      '4000',
      '4500',
      '5000'
    ];
    _getPreferences();
    super.initState();
  }

  _getPreferences() {
    prefTargetValue =
        Preference.shared.getString(Preference.TARGET_DRINK_WATER);
    if (targetValue == null && prefTargetValue == null) {
      targetValue = targetList[3];
    } else {
      targetValue = prefTargetValue;
    }
    isReminder = Preference.shared.getBool(Preference.IS_REMINDER_ON) ?? false;
  }

  _onRefresh() {
    setState(() {});
    _getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    fullHeight = MediaQuery.of(context).size.height;
    fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              //Top Bar
              Container(
                child: CommonTopBar(
                  Languages.of(context)!.txtSettings,
                  this,
                  isShowBack: true,
                ),
              ),

              buildListView(context),
            ],
          ),
        ),
      ),
    );
  }

  buildListView(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Container(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  Languages.of(context)!.txtTarget,
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  Languages.of(context)!.txtTargetDesc,
                  style: TextStyle(
                      color: Colur.txt_grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                trailing: DropdownButton(
                  dropdownColor: Colur.progress_background_color,
                  underline: Container(
                    color: Colur.transparent,
                  ),
                  value: targetValue,
                  //targetValue,
                  iconEnabledColor: Colur.white,
                  items:
                      targetList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        "$value ml",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colur.txt_white,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      Preference.clearTargetDrinkWater();
                      targetValue = value;
                      Preference.shared.setString(Preference.TARGET_DRINK_WATER,
                          targetValue.toString());
                    });
                  },
                ),
              ),
              Divider(
                color: Colur.txt_grey,
                indent: fullWidth * 0.04,
                endIndent: fullWidth * 0.04,
              ),
              InkWell(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => DrinkWaterReminderScreen()))
                    .then((value) => _onRefresh()),
                child: ListTile(
                  title: Text(
                    Languages.of(context)!.txtReminder,
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: Switch(
                    onChanged: (bool value) {
                      if (isReminder == false) {
                        setState(() {
                          isReminder = true;
                        });
                      } else {
                        setState(() {
                          isReminder = false;
                        });
                      }
                      Preference.shared
                          .setBool(Preference.IS_REMINDER_ON, isReminder);
                    },
                    value: isReminder,
                    activeColor: Colur.purple_gradient_color2,
                    inactiveTrackColor: Colur.txt_grey,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.of(context).pop();
    }
  }
}
