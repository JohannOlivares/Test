import 'package:flutter/material.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen>
    implements TopBarClickListener {
  bool isRunningReminder = false;
  bool isDrinkWaterReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: CommonTopBar(
                  Languages.of(context)!.txtReminder,
                  this,
                  isShowBack: true,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          Languages.of(context)!.txtRunningReminder,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colur.txt_white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: (){

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colur.rounded_rectangle_color,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "6:30 pm",
                                  style: TextStyle(
                                      color: Colur.txt_white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                                contentPadding: EdgeInsets.all(0.0),
                                trailing: Switch(
                                  value: isRunningReminder,
                                  activeColor: Colur.purple_gradient_color2,
                                  inactiveTrackColor: Colur.txt_grey,
                                  onChanged: (bool value) {},
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  Languages.of(context)!.txtRepeat,
                                  style: TextStyle(
                                      color: Colur.txt_white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                width: double.infinity,
                                child: Text(
                                  "Sun, Mon, Sat",
                                  style: TextStyle(
                                      color: Colur.txt_purple,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 25.0, bottom: 10.0),
                        child: Text(
                          Languages.of(context)!.txtDrinkWaterReminder,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colur.txt_white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: (){

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colur.rounded_rectangle_color,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "6:30 pm",
                                  style: TextStyle(
                                      color: Colur.txt_white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                                contentPadding: EdgeInsets.all(0.0),
                                trailing: Switch(
                                  value: isRunningReminder,
                                  activeColor: Colur.purple_gradient_color2,
                                  inactiveTrackColor: Colur.txt_grey,
                                  onChanged: (bool value) {},
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  Languages.of(context)!.txtInterval,
                                  style: TextStyle(
                                      color: Colur.txt_white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                width: double.infinity,
                                child: Text(
                                  "Every day",
                                  style: TextStyle(
                                      color: Colur.txt_purple,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
    if(name == Constant.STR_BACK){
      Navigator.pop(context);
    }
  }
}
