import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
        padding: EdgeInsets.fromLTRB(fullwidth * 0.05, fullheight * 0.01,
            fullwidth * 0.05, fullheight * 0.01),
        child: Column(
          children: [
            //Not now
            /*Container(
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
                        Languages.of(context)!.txtNotnow,
                        style: TextStyle(
                          color: Colur.txt_white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Image.asset(
                      "assets/icons/ic_map_permission.png",
                      height: 180,
                      width: 280,
                    ),
                  ),
                  Text(
                    Languages.of(context)!.txtUseYourLocation,
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontWeight: FontWeight.w700,
                        fontSize: 28),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: fullheight * 0.03),
                    child: Text(
                      Languages.of(context)!.txtLocationDesc1,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colur.txt_grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: fullheight * 0.03),
                    child: Text(
                      Languages.of(context)!.txtLocationDesc2,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colur.txt_grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            //Allow Button,
            Container(
              margin: EdgeInsets.only(bottom: fullheight * 0.04),
              child: GradientButtonSmall(
                width: 250,
                height: 60,
                radius: 30.0,
                child: Text(
                  Languages.of(context)!.txtAllow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colur.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colur.purple_gradient_color1,
                    Colur.purple_gradient_color2,
                  ],
                ),
                onPressed: () {
                  _permissionCheck();

                  /*Navigator.of(context)
                        .pushNamedAndRemoveUntil('/startrunScreen', (Route<dynamic> route) => false);*/
                },
              ),
            )
          ],
        ),
      )),
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
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return showDialog(
            context: context,
            builder: (BuildContext context) =>
                CustomOpenLocationSettingDialog(context));
      }
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartRunScreen()),
        ModalRoute.withName("/homeWizardScreen"));
  }

  Widget CustomOpenLocationSettingDialog(BuildContext context) {
    return Dialog(
      elevation: 30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Colur.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: []),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/icons/ic_close.png',
                    color: Colur.txt_black,
                    scale: 3.5,
                  )),
            ),
            Container(
                height: 200,
                child: Image.asset(
                  'assets/icons/ic_map_pin.png',
                )),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 10),
              child: Center(
                child: Text(
                  Languages.of(context)!.txtWeNeedYourLocation,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colur.txt_grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 40),
              child: Center(
                child: Text(
                  Languages.of(context)!.txtPleaseGivePermissionFromSettings,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colur.txt_black,
                      fontWeight: FontWeight.w900,
                      fontSize: 20),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                /*    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WellDoneScreen()
                    ),
                    ModalRoute.withName("/homeWizardScreen")
                );*/
                await Geolocator.openAppSettings();
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: 15.0,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colur.purple_gradient_color1,
                      Colur.purple_gradient_color2,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    Languages.of(context)!.txtGotoSettings.toUpperCase(),
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
