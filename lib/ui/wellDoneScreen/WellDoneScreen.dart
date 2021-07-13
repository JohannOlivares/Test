import 'package:flutter/material.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Utils.dart';

class WellDoneScreen extends StatefulWidget {
  const WellDoneScreen({Key key}) : super(key: key);

  @override
  _WellDoneScreenState createState() => _WellDoneScreenState();
}

class _WellDoneScreenState extends State<WellDoneScreen>
    implements TopBarClickListener {
  @override
  Widget build(BuildContext context) {
    var fullheight = MediaQuery.of(context).size.height;
    var fullwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colur.common_bg_dark,
        body: Container(
          child: Column(
            children: [
              Container(
                child: CommonTopBar(
                  "",
                  this,
                  isClose: true,
                  isDelete: true,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: fullheight*0.2),
                child: Text(
                  Languages.of(context).txtWellDone.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colur.txt_white,
                      fontSize: 30),
                ),
              ),

              _mapScreenShot(fullheight,fullwidth),
            ],
          ),
        ));
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_DELETE) {
      Utils.showToast(context, "Delete Data");
    }
    if (name == Constant.STR_CLOSE) {
      Navigator.pop(context);
    }
  }

  _mapScreenShot(double fullheight, double fullwidth) {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
      child: Image.asset('assets/images/dummy_map.png'),
    );
  }
}
