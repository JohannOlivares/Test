import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';

import '../../common/commonTopBar/CommonTopBar.dart';
import '../../interfaces/TopBarClickListener.dart';
import '../../localization/language/languages.dart';
import '../../utils/Constant.dart';
import '../waterReminder/DrinkWaterReminderScreen.dart';

class DrinkWaterSettingsScreen extends StatefulWidget {
  @override
  _DrinkWaterSettingsScreenState createState() => _DrinkWaterSettingsScreenState();
}

class _DrinkWaterSettingsScreenState extends State<DrinkWaterSettingsScreen> implements TopBarClickListener{
  var capacityUnits = '10';
  var targetValue = '500';
  bool isReminder = true;
  List<String> capacityList = ['50','60','70','80','90','100','110','120','130','140','150'];
  List<String> targetList = ['500','1000','1500','2000','2500','3000','3500','4000','4500','5000'];
  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              //Top Bar
              Container(
                child: CommonTopBar(Languages.of(context).txtSettings, this, isShowBack: true,),
              ),

              buildListView(context, fullWidth),
            ],
          ),
        ),

      ),
    );
  }

  buildListView(BuildContext context, double fullWidth) {
    return Container(
      margin: EdgeInsets.only(top: 20),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              title: Text(
                Languages.of(context).txtCupCapacityUnits,
                style: TextStyle(
                    color: Colur.txt_white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
              ),
              trailing: DropdownButton(
                dropdownColor: Colur.progress_background_color,
                underline: Container(
                  color: Colur.transparent,
                ),
                value: capacityList[0],//capacityUnits,
                iconEnabledColor: Colur.white,
                items: capacityList.map<DropdownMenuItem<String>>((String value) {
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
                onChanged: (value) {
                  setState(() {
                    capacityUnits = value;
                  });
                },
              ),
            ),
            Divider(
              color: Colur.txt_grey,
              indent: fullWidth*0.04,
              endIndent: fullWidth*0.04,
            ),
            ListTile(
              title: Text(
                Languages.of(context).txtTarget,
                style: TextStyle(
                    color: Colur.txt_white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
              ),
              subtitle: Text(
                Languages.of(context).txtTargetDesc,
                style: TextStyle(
                    color: Colur.txt_grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
              ),
              trailing: DropdownButton(
                dropdownColor: Colur.progress_background_color,
                underline: Container(
                  color: Colur.transparent,
                ),
                value: targetList[0],//targetValue,
                iconEnabledColor: Colur.white,
                items: targetList.map<DropdownMenuItem<String>>((String value) {
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
                onChanged: (value) {
                  setState(() {
                    targetValue = value;
                  });
                },
              ),
            ),
            Divider(
              color: Colur.txt_grey,
              indent: fullWidth*0.04,
              endIndent: fullWidth*0.04,
            ),
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DrinkWaterReminderScreen())),
              child: ListTile(
                title: Text(
                  Languages.of(context).txtReminder,
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
                trailing: Switch(
                  onChanged: (bool value) {
                    if(isReminder == false) {
                      setState(() {
                        isReminder = true;
                      });
                    } else {
                      setState(() {
                        isReminder = false;
                      });
                    }
                    },
                  value: isReminder,
                  activeColor: Colur.purple_gradient_color2,
                  inactiveTrackColor: Colur.txt_grey,

                ),
              ),
            ),
          ],
        )
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name == Constant.STR_BACK) {
      Navigator.of(context).pop();
    }
  }
}
