import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:run_tracker/custom/GradientButtonSmall.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/startRun/StartRunScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Utils.dart';

class UseLocationScreen extends StatefulWidget {
  @override
  _UseLocationScreenState createState() => _UseLocationScreenState();
}

class _UseLocationScreenState extends State<UseLocationScreen> {

  Location _location = Location();

  @override
  Widget build(BuildContext context) {
    double fullheight = MediaQuery.of(context).size.height;
    double fullwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(fullwidth*0.05,fullheight * 0.01,fullwidth*0.05,fullheight * 0.01),
          child: Column(
            children: [
              //Not now
              Container(
                height: fullheight*0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {

                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/homeWizardScreen', (Route<dynamic> route) => false);
                      },
                      child: Text(
                        Languages.of(context).txtNotnow,
                        style: TextStyle(
                          color: Colur.txt_white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Map image
              Container(
                margin:  EdgeInsets.only(top: fullheight*0.015, bottom: fullheight*0.04),
                child: Image.asset(
                  "assets/icons/ic_map_permission.png",
                  height: 180,
                  width: 280,
                ),
              ),
              //Description
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        Languages.of(context).txtUseYourLocation,
                        style: TextStyle(
                          color: Colur.txt_white,
                          fontWeight: FontWeight.w700,
                          fontSize: 28
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: fullheight*0.03),
                        child: Text(
                          Languages.of(context).txtLocationDesc1,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colur.txt_grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 18
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: fullheight*0.03),
                        child: Text(
                          Languages.of(context).txtLocationDesc2,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colur.txt_grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 18
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //Allow Button,
              Container(
                margin:  EdgeInsets.only(bottom: fullheight*0.04),
                child: GradientButtonSmall(
                  width: 250,
                  height: 60,
                  radius: 30.0,
                  child: Text(
                    Languages.of(context).txtAllow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colur.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0
                    ),
                  ),
                  gradient: LinearGradient(colors: [Colur.purple_gradient_color1, Colur.purple_gradient_color2,],),
                  onPressed: () {

                    _permissionCheck();

                    /*Navigator.of(context)
                        .pushNamedAndRemoveUntil('/startrunScreen', (Route<dynamic> route) => false);*/



                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  Future<void> _permissionCheck() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        Utils.showToast(context, "not enabled Service");
        return ;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return ;
      }
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => StartRunScreen()
        ),
        ModalRoute.withName("/homeWizardScreen")
    );

  }
}
