import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show acos, asin, cos, sin, sqrt;
import 'package:pedometer/pedometer.dart';
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';
import 'package:run_tracker/interfaces/RunningStopListener.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/countdowntimer/CountdownTimerScreen.dart';
import 'package:run_tracker/ui/mapsettings/MapSettingScreen.dart';
import 'package:run_tracker/ui/startRun/PausePopupScreen.dart';
import 'package:run_tracker/ui/wellDoneScreen/WellDoneScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Utils.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';


class StartRunScreen extends StatefulWidget {
  static RunningStopListener? runningStopListener;

  @override
  _StartRunScreenState createState() => _StartRunScreenState();
}

class _StartRunScreenState extends State<StartRunScreen> with TickerProviderStateMixin implements TopBarClickListener, RunningStopListener {
  GoogleMapController? _controller;
  Completer<GoogleMapController> _controller2 = Completer();

  Location _location = Location();

  RunningData? runningData;
  //For Marker
  BitmapDescriptor? pinLocationIcon;
  Set<Marker> markers = {};

  //For SnapShots
  Uint8List? imageBytesVar;

  LocationData? _currentPosition;
  LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinatesList = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double totalDistance = 0;
  double lastDistance = 0;
  double pace = 0;
  double calorisvalue = 0;
  int _steps = 0;
  String _status = "";
  bool reset = false;
  bool setaliteEnable = false;
  bool startTrack = false;
  String? timeValue = "";
  bool isBack = true;
  bool liveLocationBtn = false;

//THis Are Final Complete Value Holder Variables::::
  double? avaragePace;
  double? finaldistance;
  double? finalspeed;

  StreamSubscription<StepCount>? _stepCountStream;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusStream;
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      onChange: (value) {
        //print('onChange $value');
      });

  @override
  void initState() {
    StartRunScreen.runningStopListener = this;
    liveLocationBtn = false;
    runningData = RunningData(id: null);

    super.initState();

/*    stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));*/
    //countStep();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _stepCountStream?.cancel();
    await stopWatchTimer.dispose();
  }

  void _animateToCenterofMap(){
    LatLng latLng_1 = LatLng(double.parse(runningData!.sLat!),double.parse(runningData!.sLong!));
    LatLng latLng_2 =  LatLng(double.parse(runningData!.eLat!),double.parse(runningData!.eLong!));
    LatLngBounds bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);
    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
    this._controller!.animateCamera(u2).then((void v){
      check(u2,this._controller!);
    });
  }
  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    _controller!.animateCamera(u);
    LatLngBounds l1=await c.getVisibleRegion();
    LatLngBounds l2=await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if(l1.southwest.latitude==-90 ||l2.southwest.latitude==-90)
      check(u, c);
  }

  void _onMapCreated(GoogleMapController _cntlr) {

    _controller = _cntlr;
    _controller2.complete(_cntlr);
    LatLng latLng_1 = LatLng(40.416775, -3.70379);
    _location.onLocationChanged.listen((l) {
      _controller?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var fulheight = MediaQuery.of(context).size.height;
    var fullwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: !isBack
                  ? EdgeInsets.only(left: 15)
                  : EdgeInsets.only(left: 0),
              child: CommonTopBar(
                Languages.of(context)!.txtRunTracker.toUpperCase(),
                this,
                isShowBack: isBack,
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

  _addPolyLine() {
    print("add red polyline");
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colur.purple_gradient_color2,
        points: polylineCoordinatesList,
        width: 3,
        endCap: Cap.squareCap);
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
    Utils.showToast(context, "Error giving in Count Steps");
    print("Error: $error");
  }

  void _onData(StepCount stepCountValue) {
    setState(() {
      /*(reset == true)?_steps = 0:*/
      _steps = stepCountValue.steps;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Future<void> onFinish({bool value = true}) async {
    await _snapshotImage();

    Navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 10), () async{
      final imageBytes = await _controller!.takeSnapshot();
      setState(() {
        runningData!.image = new String.fromCharCodes(imageBytes!);
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => WellDoneScreen(runningData: runningData)),
          ModalRoute.withName("/homeWizardScreen"));
    });

  }

  Future<void> _snapshotImage() async {
    double? endpinlat;
    double? endpinlon;

    if (polylineCoordinatesList.length == 1) {
      endpinlat = polylineCoordinatesList.first.latitude;
      endpinlon = polylineCoordinatesList.first.longitude;
    } else {
      endpinlat = polylineCoordinatesList.last.latitude;
      endpinlon = polylineCoordinatesList.last.longitude;
    }
    LatLng endPinPosition = LatLng(endpinlat, endpinlon);

    final Uint8List markerIcon =
    await getBytesFromAsset('assets/icons/ic_map_pin_red.png', 50);
    setState(() {
      final Marker marker = Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          markerId: MarkerId('2'),
          position: endPinPosition);
      markers.add(marker);
    });

    Utils.showToast(context, "marker added");
    Debug.printLog("marker added");

    return;
  }

  getLoc() async {
    _location.changeSettings(interval: 2000, distanceFilter: 0.1);

    _currentPosition = await _location.getLocation();
    _center =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);

    // IF Button iS in Play Position
    _location.onLocationChanged.listen((LocationData currentLocation) async {
      //print("${currentLocation.latitude} : ${currentLocation.longitude}");
      if (startTrack) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          //It Will Execute only First Time
          if (polylineCoordinatesList.isEmpty) {
            polylineCoordinatesList.add(
                LatLng(currentLocation.latitude!, currentLocation.longitude!));
            runningData!.sLat = currentLocation.latitude!.toString();
            runningData!.sLong = currentLocation.longitude!.toString();
            LatLng startPinPosition = LatLng(double.parse(runningData!.sLat!),
                double.parse(runningData!.sLong!));
            final Uint8List markerIcon = await getBytesFromAsset(
                'assets/icons/ic_map_pin_purple.png', 50);
            setState(() {
              final Marker marker = Marker(
                  icon: BitmapDescriptor.fromBytes(markerIcon),
                  markerId: MarkerId('1'),
                  position: startPinPosition);
              markers.add(marker);
            });
          }

          //After that This Part only Execute
          lastDistance = calculateDistance(
              polylineCoordinatesList.last.latitude,
              polylineCoordinatesList.last.longitude,
              currentLocation.latitude,
              currentLocation.longitude);
          pace = _countSpeed(
              polylineCoordinatesList.last.latitude,
              polylineCoordinatesList.last.longitude,
              currentLocation.latitude!,
              currentLocation.longitude!);

          double weight = 50;
          double durationInsec =120;
          calorisvalue = _countCalories(durationInsec, weight);
          double conditionDistance;
          if (Platform.isIOS) {
            conditionDistance = 0.06;
          } else {
            conditionDistance = 0.01;
          }

          setState(() {
            if (lastDistance >= conditionDistance) {
              totalDistance += calculateDistance(
                  polylineCoordinatesList.last.latitude,
                  polylineCoordinatesList.last.longitude,
                  currentLocation.latitude,
                  currentLocation.longitude);

              Debug.printLog(
                  "Greater Than 0.1: $lastDistance After adding It Became Total: $totalDistance:::Speed: $pace");
              Utils.showToast(context, "greater Than 0.1");
              /*Utils.showToast(
                  context,
                  "Greater Than 0.1: $lastDistance::: After adding It Became Total: $totalDistance\n"
                  "::::Speed: $pace :::::: Distancein Meter: $distanceInMeters::::Time:  $timeValue");*/

              polylineCoordinatesList.add(LatLng(
                  currentLocation.latitude!, currentLocation.longitude!));
              _addPolyLine();
            } else {
              Debug.printLog("Less Than 0.1: $lastDistance");
              /* Utils.showToast(context,
                  "Less Than 0.1: $lastDistance::: Without adding It Became Total: $totalDistance:::Time:  $timeValue");*/

              return;
            }
          });
        }
      }

      _currentPosition = currentLocation;
      _center =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
    });
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/homeWizardScreen', (Route<dynamic> route) => false);
    }
    if (name == Constant.STR_SETTING) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MapSettingScreen()));
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

  _timerAndDistance(double fullwidth) {
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
                    child: StreamBuilder<int>(
                      stream: stopWatchTimer.rawTime,
                      initialData: stopWatchTimer.rawTime.value,
                      builder: (context, snap) {
                        final value = snap.data;
                        final displayTime = value != null
                            ? StopWatchTimer.getDisplayTime(value,
                            hours: true,
                            minute: true,
                            second: true,
                            milliSecond: false)
                            : null;
                        timeValue = displayTime;
                        return Text(
                          displayTime ?? "00:00:00", //TODO
                          style: TextStyle(
                              fontSize: 60,
                              color: Colur.txt_white,
                              fontWeight: FontWeight.w400),
                        );
                      },
                    ),
                  ),
                  _textContainer(Languages.of(context)!.txtMin),
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
                          double.parse(totalDistance.toStringAsFixed(2))
                              .toString(),
                          style: TextStyle(
                              fontSize: 32,
                              color: Colur.txt_white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      _textContainer(Languages.of(context)!.txtKM),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            double.parse(pace.toStringAsFixed(2)).toString(),
                            style: TextStyle(
                                fontSize: 32,
                                color: Colur.txt_white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        _textContainer(Languages.of(context)!.txtPaceMinPer),
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
                          double.parse(calorisvalue.toStringAsFixed(2))
                              .toString(),
                          style: TextStyle(
                              fontSize: 24,
                              color: Colur.txt_white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      _textContainer(Languages.of(context)!.txtKCAL),
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

  _mapView(double fullheight) {
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
            markers: markers.toSet(),
            myLocationEnabled: true,
            scrollGesturesEnabled: true,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            polylines: Set<Polyline>.of(polylines.values),
            onCameraMove: (_){

            },
          ),
          Container(
            margin:
            EdgeInsets.only(left: 20, right: 20, bottom: fullheight * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*  InkWell(
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
                    final imageBytes = await _controller?.takeSnapshot();
                    setState(() {
                      _imageBytes = imageBytes;
                    });


                  },
                ),*/
                InkWell(
                  child: Container(
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Center(
                        child: Image.asset(
                          'assets/icons/ic_setalite.png',
                          scale: 4.0,
                          color: setaliteEnable
                              ? Colur.purple_gradient_color2
                              : Colur.txt_grey,
                        )),
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
                        onTap: () async {
                          _location.onLocationChanged.listen((event) {
                            _currentPosition = event;
                          });


                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Center(
                              child: Image.asset('assets/icons/ic_location.png',
                                  scale: 4.0,
                                  color: Colur.purple_gradient_color2)),
                        ),
                      ),
                      //Start Button CODe
                      Expanded(
                        child: UnconstrainedBox(
                          child: InkWell(
                            onTap: () async {
                              if (startTrack == false) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CountdownTimerScreen(
                                                isGreen: false)));
                                Future.delayed(Duration(milliseconds: 3900),
                                        () {
                                      setState(() {
                                        isBack = false;
                                        startTrack = true;
                                        getLoc();
                                        stopWatchTimer.onExecute
                                            .add(StopWatchExecute.start);
                                      });
                                    });
                              } else {
                                //IF User Pressed Pause Button then This part Will Do actions>>>>>>>>>
                                stopWatchTimer.onExecute.add(StopWatchExecute
                                    .stop); //It will pause the timer
                                startTrack = false;

                                if (polylineCoordinatesList.length > 1) {
                                  runningData!.eLat = polylineCoordinatesList.last.latitude.toString();
                                  runningData!.eLong = polylineCoordinatesList.last.longitude.toString();
                                } else if (polylineCoordinatesList.length == 1) {
                                  runningData!.eLat = polylineCoordinatesList.first.latitude.toString();
                                  runningData!.eLong = polylineCoordinatesList.first.longitude.toString();
                                } else {
                                  runningData!.eLat = "45.521563";
                                  runningData!.eLong = "-122.677433";
                                }
                                _animateToCenterofMap();

                                await calculationsForAllValues()
                                    .then((value) async {
                                  final String result = (await Navigator.push(
                                      context,
                                      PausePopupScreen(
                                          stopWatchTimer,
                                          startTrack,
                                          runningData,
                                          _controller,
                                          markers)))!;
                                  setState(() {
                                    //if User Pressed Restart then below function called
                                    if (result == "false") {
                                      stopWatchTimer.onExecute
                                          .add(StopWatchExecute.reset);
                                      isBack = true;
                                    }
                                    //if User Pressed RESUME then below function called
                                    if (result == "true") {
                                      setState(() {
                                        startTrack = true;
                                        isBack = false;
                                      });
                                    }
                                  });
                                });
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
                                  gradient: LinearGradient(
                                    colors: [
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
                                      !startTrack
                                          ? Languages.of(context)!.txtStart
                                          : Languages.of(context)!.txtPause,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colur.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: 25),
                                        child: Icon(
                                          startTrack
                                              ? Icons.pause
                                              : Icons.play_arrow_rounded,
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
                      InkWell(
                        child: Container(
                          height: 60,
                          width: 60,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colur.txt_black),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/ic_lock.png',
                              scale: 4.0,
                              color: Colur.white,
                            ),
                          ),
                        ),
                        onTap: () async {
                          AnimationController controller = AnimationController(
                              duration: const Duration(milliseconds: 400),
                              vsync: this);

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => PopUp(
                              controller: controller,
                            ),
                          );
                        },
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

  double _countSpeed(double lat1, double lon1, double lat2, double lon2) {
    // Convert degrees to radians
    double M_PI = 3.141592;
    lat1 = lat1 * M_PI / 180.0;
    lon1 = lon1 * M_PI / 180.0;

    lat2 = lat2 * M_PI / 180.0;
    lon2 = lon2 * M_PI / 180.0;

    // radius of earth in metres
    double r = 6378100;

    // P
    double rho1 = r * cos(lat1);
    double z1 = r * sin(lat1);
    double x1 = rho1 * cos(lon1);
    double y1 = rho1 * sin(lon1);

    // Q
    double rho2 = r * cos(lat2);
    double z2 = r * sin(lat2);
    double x2 = rho2 * cos(lon2);
    double y2 = rho2 * sin(lon2);

    // Dot product
    double dot = (x1 * x2 + y1 * y2 + z1 * z2);
    double cos_theta = dot / (r * r);

    double theta = acos(cos_theta);

    return r * theta;
  }

  double _countCalories(double durationInsec, double weight) {
    double METConstant = 2;
    double caloriesValue = (durationInsec * METConstant * 3.5 * weight) / 6000;
    return caloriesValue;
  }

  Future<void> calculationsForAllValues() async {
    avaragePace = 0;
    finaldistance = 0;
    finalspeed = 0;
    if (polylineCoordinatesList.isNotEmpty) {
      avaragePace = _countSpeed(
          polylineCoordinatesList.first.latitude,
          polylineCoordinatesList.first.longitude,
          polylineCoordinatesList.last.latitude,
          polylineCoordinatesList.last.longitude);
    }
/*
    finaldistance = double.parse(totalDistance.toStringAsFixed(2));
    finalspeed = double.parse(avaragePace!.toStringAsFixed(2));
    runningData!.duration = timeValue!;
    runningData!.speed = finalspeed;
    runningData!.distance = finaldistance;
    runningData!.cal = calorisvalue;
*/

/*    Utils.showToast(context,
        "Timevalue: $timeValue||distance: $finaldistance\n||speed: $finalspeed||Calories: $calorisvalue");
    Debug.printLog(
        "Timevalue: $timeValue||distance: $finaldistance\n||speed: $finalspeed||Calories: $calorisvalue");*/
  }
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

//End Class
}

class PopUp extends StatefulWidget {
  final AnimationController? controller;
  bool lockmode = false;

  PopUp({this.controller, this.lockmode = false});

  @override
  State<StatefulWidget> createState() => PopUpState();
}

class PopUpState extends State<PopUp> {
  double size = 80;

  @override
  void initState() {
    super.initState();
    widget.controller?.duration = Duration(seconds: 3);
    widget.controller?.reverseDuration = Duration(milliseconds: 500);
    widget.controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: GestureDetector(
          onTapDown: (_) {
            widget.controller?.forward();
            setState(() {
              size = 84;
            });
          },
          onTapUp: (_) {
            checkCompleted();
          },
          onVerticalDragEnd: (_) {
            checkCompleted();
          },
          onHorizontalDragEnd: (_) {
            checkCompleted();
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 0),
            child: Scaffold(
              backgroundColor: Colur.transparent,
              body: Container(
                margin: EdgeInsets.only(bottom: 120),
                alignment: Alignment.bottomCenter,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: size,
                      height: size,
                      child: CircularProgressIndicator(
                        value: 2.0,
                        strokeWidth: 7,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colur.purple_Lock_screen),
                      ),
                    ),
                    Container(
                      width: size,
                      height: size,
                      child: CircularProgressIndicator(
                        value: widget.controller?.value,
                        strokeWidth: 7,
                        valueColor: AlwaysStoppedAnimation<Color>(Colur.white),
                      ),
                    ),
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Colur.purple_gradient_color1,
                            Colur.purple_gradient_color2,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          child: Image.asset(
                            "assets/icons/ic_lock.png",
                            scale: 3.7,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 135),
                      child: Text(
                        Languages.of(context)!
                            .txtLongPressToUnlock
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colur.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkCompleted() {
    if (widget.controller?.status == AnimationStatus.forward) {
      widget.controller?.reverse();
      setState(() {
        size = 78;
      });
    }
    if (widget.controller?.status == AnimationStatus.completed) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }
}
