import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
              buildTopbar(fullWidth, fullHeight, context),
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
            ListTile(
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
          ],
        )
    );
  }

  buildTopbar(double fullWidth, double fullHeight, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: fullWidth*0.03, top: fullHeight*0.00, right: fullWidth*0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: (){
             // Navigator.of(context).pop(); TODO: Uncomment
            },
            color: Colur.txt_white,
          ),
          Container(
            child: Text(
              Languages.of(context).txtSettings,
              style: TextStyle(
                  color: Colur.txt_white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }
}
