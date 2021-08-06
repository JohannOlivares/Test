import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory, File, Platform;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart' as geoLocator;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:path_provider/path_provider.dart';
import 'dart:math' show asin, cos, sqrt;
import 'package:run_tracker/common/commonTopBar/CommonTopBar.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';
import 'package:run_tracker/interfaces/RunningStopListener.dart';
import 'package:run_tracker/interfaces/TopBarClickListener.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/ui/countdowntimer/CountdownTimerScreen.dart';
import 'package:run_tracker/ui/mapsettings/MapSettingScreen.dart';
import 'package:run_tracker/ui/wellDoneScreen/WellDoneScreen.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Constant.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Preference.dart';
import 'package:run_tracker/utils/Utils.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'PausePopupScreen.dart';

class StartRunScreen extends StatefulWidget {
  static RunningStopListener? runningStopListener;

  @override
  _StartRunScreenState createState() => _StartRunScreenState();
}

class _StartRunScreenState extends State<StartRunScreen>
    with TickerProviderStateMixin
    implements TopBarClickListener, RunningStopListener {
  RunningData? runningData;

  //For Google Map
  GoogleMapController? _controller;
  Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  LocationData? _currentPosition;
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);


  //For Markers And PolyLines
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinatesList = [];
  BitmapDescriptor? pinLocationIcon;
  Set<Marker> markers = {};

  //For SnapShots
  Uint8List? imageBytesVar;

  double totalDistance = 0;
  double lastDistance = 0;
  double pace = 0;
  double calorisvalue = 0;
  bool setaliteEnable = false;
  bool startTrack = false;
  String? timeValue = "";
  bool isBack = true;

//THis Are Final Complete Value Holder Variables::::
  double? avaragePace;
  double? finaldistance;
  double? finalspeed;

  //THis Variables For Weight and Kcal Calculation
  double weight = 50;

  double currentSpeed = 0.0; // speed in km/h

  int totalLowIntenseTime = 0; // in second
  int totalModerateIntenseTime = 0; // in second
  int totalHighIntenseTime = 0; // in second

  //For Timer
  late StopWatchTimer stopWatchTimer;
  //For Unit Changes
  bool kmSelected = true;

  @override
  void initState() {
    StartRunScreen.runningStopListener = this;
    runningData = RunningData();
    stopWatchTimer = StopWatchTimer(
        mode: StopWatchMode.countUp,
        onChangeRawSecond: (value) {
          //Debug.printLog("OnTime Update ::::==> ${value}");
          if(currentSpeed >=1) {
            if (currentSpeed < 4.34) {
              totalLowIntenseTime += 1;
              Debug.printLog("Intensity ::::==> Low");
            } else if (currentSpeed < 7.56) {
              totalModerateIntenseTime += 1;
              Debug.printLog("Intensity ::::==> Moderate");
            } else {
              totalHighIntenseTime += 1;
              Debug.printLog("Intensity ::::==> High");
            }
          }
        },
        onChange: (value) {
          //print('onChange $value');
        });

    _getPreferences();

    super.initState();
  }

  _getPreferences() {
    setState(() {
      kmSelected =
          Preference.shared.getBool(Preference.IS_KM_SELECTED) ?? true;
      weight =(Preference.shared.getInt(Preference.WEIGHT)??50).toDouble();
      //Utils.showToast(context, "Weight in Kg: "+weight.toString());

    });
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
    await stopWatchTimer.dispose();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _locationSubscription = _location.onLocationChanged.listen((l) {
      _controller?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 20),
        ),
      );
      _locationSubscription!.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    var fulheight = MediaQuery.of(context).size.height;
    var fullwidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: ()=> customDialog(),
      child: Scaffold(
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
                child: _mapView(fulheight, context),
              ),
            ],
          ),
        ),
      ),
    );
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
                  width: 90,
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                      (kmSelected)?totalDistance.toStringAsFixed(2):Utils.kmToMile(totalDistance).toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 32,
                              color: Colur.txt_white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      _textContainer((kmSelected)?Languages.of(context)!.txtKM.toUpperCase():Languages.of(context)!.txtMile.toUpperCase()),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            (kmSelected)?pace.toStringAsFixed(2):Utils.minPerKmToMinPerMile(pace).toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 32,
                                color: Colur.txt_white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        _textContainer((kmSelected)?Languages.of(context)!.txtPaceMinPer.toUpperCase()+Languages.of(context)!.txtKM.toUpperCase()+")":Languages.of(context)!.txtPaceMinPer.toUpperCase()+Languages.of(context)!.txtMile.toUpperCase()+")"),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 90,
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          double.parse(calorisvalue.toStringAsFixed(2))
                              .toString(),
                          style: TextStyle(
                              fontSize: 32,
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

  _mapView(double fullheight, BuildContext context) {
    return Container(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialcameraposition, zoom: 18),
            mapType:
                setaliteEnable == true ? MapType.satellite : MapType.normal,
            onMapCreated: _onMapCreated,
            buildingsEnabled: false,
            markers: markers,
            myLocationEnabled: true,
            scrollGesturesEnabled: true,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 20, right: 20, bottom: fullheight * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: !isBack,
                  child: InkWell(
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
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: !isBack,
                        child: InkWell(
                          onTap: () async {

                            moveCameraToUserLocation();
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
                      ),
                      //Start Button Code
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
                                    if (_locationSubscription != null &&
                                        _locationSubscription!.isPaused)
                                      _locationSubscription!.resume();
                                    else
                                      getLoc();
                                    stopWatchTimer.onExecute
                                        .add(StopWatchExecute.start);
                                  });
                                });
                              } else {
                                //IF User Pressed Pause Button then This part Will Do actions>>>>>>>>>
                                _locationSubscription!.pause();
                                stopWatchTimer.onExecute.add(StopWatchExecute
                                    .stop); //It will pause the timer
                                setState(() {
                                  startTrack = false;
                                });
                                if (polylineCoordinatesList.length >= 1) {
                                  runningData!.eLat = polylineCoordinatesList
                                      .last.latitude
                                      .toString();
                                  runningData!.eLong = polylineCoordinatesList
                                      .last.longitude
                                      .toString();
                                } else {
                                  Utils.showToast(context, "Discard");
                                  return showDiscardDialog();
                                }

                                await _animateToCenterofMap();

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
                                    if (_locationSubscription != null &&
                                        _locationSubscription!.isPaused)
                                      _locationSubscription!.resume();
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
                                      !startTrack
                                          ? Languages.of(context)!
                                              .txtStart
                                              .toUpperCase()
                                          : Languages.of(context)!
                                              .txtPause
                                              .toUpperCase(),
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
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isBack,
                        child: InkWell(
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

  void showDiscardDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Languages.of(context)!.txtDiscard + " ?"),
            content: Text(Languages.of(context)!.txtAlertForNoLocation),
            actions: [
              /* TextButton(
                child: Text(Languages.of(context)!.txtCancel),
                onPressed: () {

                  Navigator.pop(context);
                },
              ),*/
              TextButton(
                child: Text(Languages.of(context)!.txtDiscard),
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/homeWizardScreen', (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        });
  }

  _addPolyLine() {
    print("add red polyline");
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinatesList,
      width: 4,
    );
    polylines[id] = polyline;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Future<void> onFinish({bool value = true}) async {
    if (_locationSubscription != null && _locationSubscription!.isPaused)
      _locationSubscription!.cancel();
    await _addEndMarker();
    Navigator.pop(context);
    runningData!.polyLine = jsonEncode(polylineCoordinatesList);

    Future.delayed(const Duration(milliseconds: 50), () async {
      //1
      final imageBytes = await _controller!.takeSnapshot();
      await saveFile(imageBytes!, "${DateTime.now().millisecond}");
    });
  }

  Future<String?> _findLocalPath() async {
    final TargetPlatform plateform2 = Theme.of(context).platform;
    final directory = (plateform2 == TargetPlatform.android)
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    /* if(plateform2 == TargetPlatform.android)
      return '/storage/emulated/0';*/

    return directory?.path;
  }

  Future<bool> saveFile(Uint8List imageBytes, String filename) async {
    try {
      late String _localPath;
      _localPath =
          (await _findLocalPath())! + Platform.pathSeparator + 'Download';

      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
        Debug.printLog(savedDir.toString());
      }

      var newFile =
          await File(savedDir.path + Platform.pathSeparator + filename + ".png")
              .create(recursive: true);
      await newFile.writeAsBytes(imageBytes);
      runningData!.imageFile = newFile;
      runningData!.image = newFile.path;

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => WellDoneScreen(runningData: runningData)),
          ModalRoute.withName("/homeWizardScreen"));

      return true;
    } catch (e) {
      Debug.printLog(e.toString());
      Utils.showToast(context, e.toString());
    }
    return false;
  }

  Future<void> _addEndMarker() async {
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

    //Utils.showToast(context, "marker added");
    Debug.printLog("marker added");

    return;
  }

  getLoc() async {
    //_location.changeSettings(interval: 2000, distanceFilter: 0.1);

    //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _location.changeSettings(
      accuracy: LocationAccuracy.balanced,
    );

    geoLocator.Geolocator.getPositionStream(
            desiredAccuracy: geoLocator.LocationAccuracy.medium)
        .listen((position) {
      if (polylineCoordinatesList.length >= 2) {
        var speedInMps = position.speed;
        var speedKmpm = speedInMps * 0.06;
        currentSpeed = speedKmpm*60;
        pace = 1 / speedKmpm;
      }
      //Utils.showToast(context, speedKmpm.toString()+"/kmp");
      // this is your speed
    });

    _currentPosition = await _location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);

    // IF Button IS in Play Position
    _locationSubscription = _location.onLocationChanged
        .listen((LocationData currentLocation) async {
      print("${currentLocation.latitude} : ${currentLocation.longitude}");
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

          calorisvalue = _countCalories(weight);

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

              Utils.showToast(context, "greater Than 0.1");

              polylineCoordinatesList.add(LatLng(
                  currentLocation.latitude!, currentLocation.longitude!));
              _addPolyLine();
              _controller?.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(currentLocation.latitude!, currentLocation.longitude!), zoom: 20),
                ),
              );
            } else {
              Debug.printLog("Less Than 0.1: $lastDistance");
              return;
            }
          });
        }
      }
    });
  }

  Future<void> _animateToCenterofMap() async {
    //This IS Method For Calculation NorthEast And South West
    LatLngBounds boundsFromLatLngList(List<LatLng> list) {
      assert(list.isNotEmpty);
      double? x0;
      double? x1;
      double? y0;
      double? y1;
      for (LatLng latLng in list) {
        if (x0 == null) {
          x0 = x1 = latLng.latitude;
          y0 = y1 = latLng.longitude;
        } else {
          if (latLng.latitude > x1!) x1 = latLng.latitude;
          if (latLng.latitude < x0) x0 = latLng.latitude;
          if (latLng.longitude > y1!) y1 = latLng.longitude;
          if (latLng.longitude < y0!) y0 = latLng.longitude;
        }
      }
      return LatLngBounds(
          northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
    }

    //After adding polylines list for Calculate NorthEast And South West Positions and Animate Camera
    jsonEncode(polylineCoordinatesList);
    LatLngBounds latLngBounds = boundsFromLatLngList(polylineCoordinatesList);
    _controller!.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  Future<void> calculationsForAllValues() async {
    avaragePace = 0;
    finaldistance = 0;
    finalspeed = 0;
    /*if (polylineCoordinatesList.isNotEmpty) {
      avaragePace = _countSpeed(
          polylineCoordinatesList.first.latitude,
          polylineCoordinatesList.first.longitude,
          polylineCoordinatesList.last.latitude,
          polylineCoordinatesList.last.longitude);
    }*/
    finaldistance = double.parse(totalDistance.toStringAsFixed(2));
    finalspeed = double.parse(avaragePace!.toStringAsFixed(2));
    runningData!.date = DateFormat.yMMMd().format(DateTime.now()).toString();
    int hr = int.parse(timeValue!.split(":")[0]);
    int min = int.parse(timeValue!.split(":")[1]);
    int sec = int.parse(timeValue!.split(":")[2]);
    int totalTimeInSec = (hr * 3600) + (min * 60) + (sec);
    avaragePace = totalTimeInSec / (finaldistance! * 60);

    runningData!.duration = totalTimeInSec;
    runningData!.speed = double.parse(avaragePace!.toStringAsFixed(2));
    runningData!.distance = finaldistance;
    runningData!.cal = double.parse(calorisvalue.toStringAsFixed(2));
    runningData!.lowIntenseTime = totalLowIntenseTime;
    runningData!.moderateIntenseTime = totalModerateIntenseTime;
    runningData!.highIntenseTime = totalHighIntenseTime;
    /* Utils.showToast(context, "Hours: $hr||||Min: $min ||| Sec: $sec||durationInSec:$TotalTimeInSec");
    Debug.printLog( "Hours: $hr||||Min: $min");*/
  }

/*  double _countSpeed(double lat1, double lon1, double lat2, double lon2) {
    // Convert degrees to radians
    double mPI = 3.141592;
    lat1 = lat1 * mPI / 180.0;
    lon1 = lon1 * mPI / 180.0;
    lat2 = lat2 * mPI / 180.0;
    lon2 = lon2 * mPI / 180.0;

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
    double cosTheta = dot / (r * r);

    double theta = acos(cosTheta);

    return r * theta;
  }*/

  double _countCalories(double weight) {
    int hr = int.parse(timeValue!.split(":")[0]);
    int min = int.parse(timeValue!.split(":")[1]);
    int sec = int.parse(timeValue!.split(":")[2]);
    int sec2 = (hr * 3600) + (min * 60) + (sec);
    double mETConstant = 2;
    double caloriesValue = (sec2 * mETConstant * 3.5 * weight) / 6000;
    return caloriesValue;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/homeWizardScreen', (Route<dynamic> route) => false);
    }
    if (name == Constant.STR_SETTING) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MapSettingScreen())).then((value){

        _getPreferences();
      });
    }
  }

  Future<void> moveCameraToUserLocation() async {
    LatLng newcurrentlatLong =
        LatLng(polylineCoordinatesList.last.latitude, polylineCoordinatesList.last.longitude);
    _controller!.moveCamera(CameraUpdate.newLatLng(newcurrentlatLong));
  }

  customDialog() async {
    //IF User Pressed Pause Button then This part Will Do actions>>>>>>>>>
    _locationSubscription!.pause();
    stopWatchTimer.onExecute.add(StopWatchExecute
        .stop); //It will pause the timer
    setState(() {
      startTrack = false;
    });
    if (polylineCoordinatesList.length >= 1) {
      runningData!.eLat = polylineCoordinatesList
          .last.latitude
          .toString();
      runningData!.eLong = polylineCoordinatesList
          .last.longitude
          .toString();
    } else {
      Utils.showToast(context, "Discard");
      return showDiscardDialog();
    }

    await _animateToCenterofMap();

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
        if (_locationSubscription != null &&
            _locationSubscription!.isPaused)
          _locationSubscription!.resume();
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
//End Class
}

//=====================================================================================================

class PopUp extends StatefulWidget {
  final AnimationController? controller;
  final bool lockMode;

  PopUp({this.controller, this.lockMode = false});

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
