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

class _SettingScreenState extends State<SettingScreen> implements TopBarClickListener {
  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery
        .of(context)
        .size
        .height;
    var fullWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              //Top Bar
              Container(
                child: CommonTopBar(Languages
                    .of(context)
                    .txtSettings, this, isShowBack: true,),
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