import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';

import '../../common/commonTopBar/CommonTopBar.dart';
import '../../interfaces/TopBarClickListener.dart';
import '../../utils/Constant.dart';

class DrinkWaterReminderScreen extends StatefulWidget {
  @override
  _DrinkWaterReminderScreenState createState() => _DrinkWaterReminderScreenState();
}

class _DrinkWaterReminderScreenState extends State<DrinkWaterReminderScreen> implements TopBarClickListener{
  bool isNotification = true;
  List<String> startList =["10:00", "11:00"];
  List<String> endList =["10:00", "11:00"];
  List<String> intervalList =["Every hour", "Everyday", "Every week"];
  var startValue;
  var endValue;
  var intervalValue;
  final TextEditingController msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                //Top Bar
                Container(
                  child: CommonTopBar(Languages.of(context)!.txtDrinkWaterReminder, this, isShowBack: true),
                ),
                buildListView(context, fullWidth, fullHeight),
              ],
            ),
          ),

        ),
      ),
    );
  }

  buildListView(BuildContext context, double fullWidth, double fullHeight) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Notification
              buildListTile(title: Languages.of(context)!.txtNotifications, isDropdown: false),
              buildDivider(fullWidth),
              //Schedule
              buildTitleText(fullWidth, fullHeight, context, Languages.of(context)!.txtSchedule),
              //Start
              buildListTile(
                title: Languages.of(context)!.txtStart,
                list: startList,
                dropDownValue: startValue,
                isTime: true,
                unit: Languages.of(context)!.txtAM,
                isDropdown: true
              ),
              buildDivider(fullWidth),
              //End
              buildListTile(
                title: Languages.of(context)!.txtEnd,
                list: endList,
                dropDownValue: endValue,
                isTime: true,
                unit: Languages.of(context)!.txtPM,
                isDropdown: true
              ),
              buildDivider(fullWidth),
              //Interval
              buildListTile(
                title: Languages.of(context)!.txtInterval,
                list: intervalList,
                dropDownValue: intervalValue,
                isTime: false,
                isDropdown: true
              ),
              buildDivider(fullWidth),
              //Sound
              buildTitleText(fullWidth, fullHeight, context, Languages.of(context)!.txtMessage),
              //Message
              msgTextField(fullWidth, fullHeight),
              //Sound
              buildTitleText(fullWidth, fullHeight, context, Languages.of(context)!.txtSound),
              //Ringtone
              ringtone(fullWidth, fullHeight, context)
            ],
          ),
        )
    );
  }

  ringtone(double fullWidth, double fullHeight, BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        margin: EdgeInsets.only(left: fullWidth*0.04, right: fullWidth*0.04, top: fullHeight*0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Languages.of(context)!.txtRingtone,
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  "Default",
                  style: TextStyle(
                      color: Colur.txt_grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colur.txt_grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  msgTextField(double fullWidth, double fullHeight) {
    return Container(
      margin: EdgeInsets.only(left: fullWidth*0.04, top: fullHeight*0.02),
      child: TextFormField(
        initialValue: "It's time to drink water.",
        maxLines: 1,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: TextStyle(
            color: Colur.txt_white,
            fontSize: 18,
            fontWeight: FontWeight.w500
        ),
        cursorColor: Colur.txt_grey,
        //controller: msgController,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
  
  buildTitleText(double fullWidth, double fullHeight, BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.only(left: fullWidth*0.04, top: fullHeight*0.02),
      child: Text(
        title,
        style: TextStyle(
            color: Colur.txt_grey,
            fontWeight: FontWeight.w400,
            fontSize: 14
        ),
      ),
    );
  }

  buildDivider(double fullWidth) {
    return Divider(
      color: Colur.txt_grey,
      indent: fullWidth*0.04,
      endIndent: fullWidth*0.04,
    );
  }

  buildListTile({
    required String title,
    List<String>? list,
    String? dropDownValue,
    String? unit,
    bool? isTime,
    required isDropdown,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            color: Colur.txt_white,
            fontSize: 18,
            fontWeight: FontWeight.w500
        ),
      ),
      trailing: isDropdown ? buildDropdownButton(
        list: list!,
        isTime: isTime, 
        unit: unit, 
        dropDownValue: dropDownValue
      ) : buildSwitch(),
    );
  }

  buildSwitch() {
    return Switch(
      onChanged: (bool value) {
        if(isNotification == false) {
          setState(() {
            isNotification = true;
          });
        } else {
          setState(() {
            isNotification = false;
          });
        }
      },
      value: isNotification,
      activeColor: Colur.purple_gradient_color2,
      inactiveTrackColor: Colur.txt_grey,
    );
  }

  buildDropdownButton({required List<String> list, bool? isTime, String? unit, String? dropDownValue}) {
    return DropdownButton(
      dropdownColor: Colur.progress_background_color,
      underline: Container(
        color: Colur.transparent,
      ),
      value: list[0],
      iconEnabledColor: Colur.white,
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            isTime! ? "$value $unit" : "$value",
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
          dropDownValue = value;
        });
      },
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name == Constant.STR_BACK){
      Navigator.of(context).pop();
    }
  }
}
