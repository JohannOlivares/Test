import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:pedometer/pedometer.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/custom/CusttomTimer.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/countdowntimer/CountdownTimerScreen.dart';
import 'package:run_tracker/ui/home/HomeScreen.dart';
import 'package:run_tracker/ui/settings/SettingScreen.dart';
import 'package:run_tracker/ui/wellDoneScreen/WellDoneScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Utils.dart';
import 'package:toast/toast.dart';

import 'PausePopupScreen.dart';

class StartRunScreen extends StatefulWidget {
  StartRunScreen({Key key}) : super(key: key);

  @override
  _StartRunScreenState createState() => _StartRunScreenState();
}

class _StartRunScreenState extends State<StartRunScreen>
    implements TopBarClickListener {
  GoogleMapController _controller;
  Location _location = Location();

  LocationData _currentPosition;
  LocationData _currentLocation;
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double totalDistance = 0;
  double lastDistance = 0;
  int _steps;
  String _status;
  bool reset = false;
  bool setaliteEnable = false;
  bool startTrack = false;
  bool liveLocationBtn;

  StreamSubscription<StepCount> _stepCountStream;
  StreamSubscription<PedestrianStatus> _pedestrianStatusStream;

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    liveLocationBtn = false;
    super.initState();
    getLoc();
    countStep();
  }


  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 20),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var fulheight = MediaQuery
        .of(context)
        .size
        .height;
    var fullwidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: CommonTopBar(
                Languages
                    .of(context)
                    .txtRunTracker
                    .toUpperCase(),
                this,
                isShowBack: true,
                isShowSetting: true,
              ),
            ),
            _timerAndDistance(fullwidth),
            Expanded(
              child: _mapView(fulheight),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stepCountStream.cancel();
    super.dispose();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
  }

  void countStep() {
    reset = true;
    _stepCountStream = Pedometer.stepCountStream
        .listen(_onData, onError: _onError, cancelOnError: false);

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream.listen((event) {
      setState(() {
        _status = event.status;
      });
    }, onError: (error) {
      print("Pedestrian Status Error: $error");
      setState(() {
        _status = "Status not available.";
      });
    });
  }

  void _onError(error) {
    _steps = 0;
    Toast.show("Error giving in Count Steps", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    print("Error: $error");
  }

  void _onData(StepCount stepCountValue) {
    setState(() {
      /*(reset == true)?_steps = 0:*/
      _steps = stepCountValue.steps;
    });
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 0.1);

    _currentPosition = await _location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    _location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.latitude} : ${currentLocation.longitude}");
      if (currentLocation.latitude != null &&
          _currentPosition.longitude != null) {
        if (polylineCoordinates.length > 0) {
          lastDistance = calculateDistance(
              polylineCoordinates.last.latitude,
              polylineCoordinates.last.longitude,
              _currentPosition.latitude,
              _currentPosition.longitude);
          if (lastDistance >= 0.1) {
            polylineCoordinates.add(
                LatLng(currentLocation.latitude, currentLocation.longitude));
            print("added to polylines");
          }
        } else {
          print("added without");
          polylineCoordinates
              .add(LatLng(currentLocation.latitude, currentLocation.longitude));
        }
      }

      _addPolyLine();
      for (var i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += calculateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude);
      }

      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
        print(totalDistance);
      });
    });
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.pop(context);
    }
    if (name == Constant.STR_CLOSE) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SettingScreen()));
      //.then((value) => refresh());
      //Navigator.pushNamed(context, "/settingscreen");
    }
  }

  _textContainer(String text) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colur.txt_grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _timerAndDistance([double fullwidth]) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      width: fullwidth,
      color: Colur.common_bg_dark,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    child: Text(
                      "00:00:00", //TODO
                      style: TextStyle(
                          fontSize: 60,
                          color: Colur.txt_white,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  _textContainer(Languages
                      .of(context)
                      .txtMin),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Row(
              children: [
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          "0:00" ?? totalDistance.toString(), //TODO
                          style: TextStyle(
                              fontSize: 32,
                              color: Colur.txt_white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      _textContainer(Languages
                          .of(context)
                          .txtKM),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            "00:00",
                            style: TextStyle(
                                fontSize: 32,
                                color: Colur.txt_white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        _textContainer(Languages
                            .of(context)
                            .txtPaceMinPerKM),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          "0:0",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colur.txt_white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      _textContainer(Languages
                          .of(context)
                          .txtKCAL),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  _mapView([double fullheight]) {
    return Container(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
            CameraPosition(target: _initialcameraposition, zoom: 20),
            mapType:
            setaliteEnable == true ? MapType.satellite : MapType.normal,
            onMapCreated: _onMapCreated,
            buildingsEnabled: false,
            myLocationEnabled: true,
            scrollGesturesEnabled: true,

            myLocationButtonEnabled: true,
            zoomGesturesEnabled: false,
            onCameraMove: (position) {
              setState(() {
                liveLocationBtn = false;
              });
            },
            polylines: Set<Polyline>.of(polylines.values),
            padding: EdgeInsets.only(right: 10),


          ),
          Container(
            margin: EdgeInsets.only(
                left: 20, right: 20, bottom: fullheight * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*InkWell(
                  child: Visibility(
                    visible: liveLocationBtn,
                    child: Container(
                      height: 60,
                      width: 60,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: setaliteEnable == true
                              ? Colors.blue
                              : Colors.white),
                      child: Center(
                          child: Icon(
                            Icons.circle,
                            size: 35,
                          )),
                    ),
                  ),
                  onTap: () async {
                    setState(() {
                      liveLocationBtn = false;
                    });
                    _currentPosition = await _location.getLocation();
                    _initialcameraposition =
                        LatLng(_currentPosition.latitude,
                            _currentPosition.longitude);
                    _location.onLocationChanged.listen((
                        LocationData currentLocation) {
                      print("clicked:${currentLocation.latitude} : ${currentLocation
                          .longitude}");

                      _controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(currentLocation.latitude, currentLocation.longitude),
                          zoom: 20.0,
                        ),
                      ));
                    });

                  },
                ),*/
                InkWell(
                  child: Container(
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white),
                    child: Center(
                        child: Image.asset(
                          'assets/icons/ic_setalite.png', scale: 4.0,
                          color: setaliteEnable
                              ? Colur.purple_gradient_color2
                              : Colur.txt_grey,)),
                  ),
                  onTap: () {
                    setState(() {
                      setaliteEnable = !setaliteEnable;
                    });
                    Debug.printLog(
                        (setaliteEnable == true) ? "Started" : "Disabled");
                  },
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Utils.showToast(context, "LcoationPressed",duration: 1);
                          /*Navigator.of(context)
                              .pushNamedAndRemoveUntil('/wellDoneScreen', (Route<dynamic> route) => false);*/

                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => WellDoneScreen()));
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Center(
                              child:Image.asset(
                                'assets/icons/ic_location.png', scale: 4.0,
                                color: Colur.purple_gradient_color2
                                    )),
                        ),

                      ),
                      //Start Button CODe
                      Expanded(
                        child: UnconstrainedBox(
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                startTrack = !startTrack;
                              });
                              if (startTrack == true) {
                                /*Toast.show("start Track Started", context,
                                              duration: Toast.LENGTH_SHORT,
                                              gravity: Toast.BOTTOM);*/
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => CountdownTimerScreen(isGreen: false)));
                              } else {

                                final String result = await Navigator.push(
                                    context, PausePopupScreen());
                                /*Toast.show("start Track Stopped", context,
                                              duration: Toast.LENGTH_SHORT,
                                              gravity: Toast.BOTTOM);*/
                                /*  return showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text("Congratulations!!!"),
                                              content: Container(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                          "Completed Track Details:"),
                                                    ),
                                                    Container(
                                                      child: Text("Steps: " +
                                                          _steps.toString()),
                                                    ),
                                                    Container(
                                                      child: Text("Distance: " +
                                                          totalDistance.toString()),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text("okay"),
                                                ),
                                              ],
                                            ),
                                          );*/
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 160,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0.0, 15),
                                      spreadRadius: 1,
                                      blurRadius: 50,
                                      color: Colur.purple_gradient_shadow,
                                    ),
                                  ],
                                  /*color: startTrack == true
                                      ? Colors.lightGreen
                                      : Colors.redAccent.shade200,*/
                                  gradient: LinearGradient(colors: [
                                    Colur.purple_gradient_color1,
                                    Colur.purple_gradient_color2
                                  ],
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      //TODO TExtADded to Language file addd
                                      startTrack == false ? Languages
                                          .of(context)
                                          .txtStart : Languages
                                          .of(context)
                                          .txtPause,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colur.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: 25),
                                        child: Icon(
                                          startTrack?Icons.pause:Icons.play_arrow_rounded,
                                          color: Colur.white,
                                          size: 30,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//End Class
}
