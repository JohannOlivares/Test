import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class RunHistoryDetailScreen extends StatefulWidget {
  RunningData recentActivitiesData;
 RunHistoryDetailScreen(this.recentActivitiesData, {Key? key}) : super(key: key);

  @override
  _RunHistoryDetailScreenState createState() => _RunHistoryDetailScreenState();
}

class _RunHistoryDetailScreenState extends State<RunHistoryDetailScreen> {

  SolidController _solidController = SolidController();
  //For Google Map
  bool setaliteEnable = false;
  GoogleMapController? _controller;
  Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  LatLng? _startLatLong;
  LatLng? _EndLatLong;
  final Set<Polyline>_polyline={};
  List<LatLng> _polylineList = [];
  BitmapDescriptor? pinLocationIcon;
  Set<Marker> markers = {};


  @override
  void initState() {
    super.initState();
    _getPointsAndDrawPolyLines();
  }
  _getPointsAndDrawPolyLines() async {
    _startLatLong = LatLng(double.parse(widget.recentActivitiesData.sLat!),double.parse(widget.recentActivitiesData.sLong!));
    _EndLatLong = LatLng(double.parse(widget.recentActivitiesData.eLat!),double.parse(widget.recentActivitiesData.eLong!));

    final Uint8List markerIcon1 =
        await getBytesFromAsset('assets/icons/ic_map_pin_purple.png', 50);
    final Uint8List markerIcon2 =
        await getBytesFromAsset('assets/icons/ic_map_pin_red.png', 50);
    setState(() {
      final Marker marker1 = Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon1),
          markerId: MarkerId('1'),
          position: _startLatLong!);
      final Marker marker2 = Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon2),
          markerId: MarkerId('2'),
          position: _EndLatLong!);
      markers.add(marker1);
      markers.add(marker2);
    });

  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    var fulheight = MediaQuery.of(context).size.height;
    var fullwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colur.common_bg_dark,
      body: Container(
        width: fullwidth,
        height: fulheight,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: Colur.txt_grey,
                child: _mapView(fulheight,context),
              ),
            ),

          ],
        ),
      ),
    );
  }
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _locationSubscription = _location.onLocationChanged.listen((l) {
      _controller?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
      _locationSubscription!.cancel();
    });
  }

  _mapView(double fullheight,BuildContext context) {
    return Container(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
            CameraPosition(target: _startLatLong!, zoom: 15),
            mapType:
            setaliteEnable == true ? MapType.satellite : MapType.normal,
            onMapCreated: _onMapCreated,
            markers: markers,
            polylines:_polyline,
            buildingsEnabled: false,
            myLocationEnabled: true,
            scrollGesturesEnabled: true,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            onTap: (LatLng latLng){
              _solidController.hide();
            },
          ),
          Container(
            margin:
            EdgeInsets.only(left: 20, right: 20, bottom: fullheight * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 55.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {

                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0,bottom: 5),
                    padding: const EdgeInsets.all(12.0),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colur.txt_white,
                        borderRadius:
                        BorderRadius.all(Radius.circular(15))),
                    child: Image.asset(
                      'assets/icons/ic_back_white.png',color: Colur.txt_grey,
                      scale: 3.7,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 15.0,bottom: 5),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colur.txt_white,

                        borderRadius:
                        BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset('assets/icons/ic_delete.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: _bottomSheetDialog(context),
          ),
        ],
      ),
    );
  }

  _bottomSheetDialog(BuildContext context) {
    return SolidBottomSheet(
      controller: _solidController,
        draggableBody: true,
        canUserSwipe: true,
        toggleVisibilityOnTap: true,
        maxHeight: MediaQuery.of(context).size.height * 0.25,
        headerBar: Container(
          padding: EdgeInsets.only(top: 20.0, right: 25.0, left: 25.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colur.common_bg_dark,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 8,
                width: 40,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Colur.txt_grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "00:00",
                              //widget.runningData!.duration.toString(),
                              style: TextStyle(
                                  color: Colur.txt_white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24),
                            ),
                          ),
                          Container(
                            child: Text(
                              Languages.of(context)!.txtTime.toUpperCase() +
                                  " (${Languages.of(context)!.txtMin.toUpperCase()})",
                              style: TextStyle(
                                  color: Colur.txt_grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "00:20", //widget.runningData!.speed.toString(),
                              style: TextStyle(
                                  color: Colur.txt_white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24),
                            ),
                          ),
                          Container(
                            child: Text(
                              Languages.of(context)!.txtPaceMinPerKM,
                              style: TextStyle(
                                  color: Colur.txt_grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "6.0", //widget.runningData!.cal.toString(),
                              style: TextStyle(
                                  color: Colur.txt_white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24),
                            ),
                          ),
                          Container(
                            child: Text(
                              Languages.of(context)!.txtKCAL,
                              style: TextStyle(
                                  color: Colur.txt_grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
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
        ),
        // Your header here
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
            color: Colur.common_bg_dark,
            child: Column(
              children: [
                Container(
                  child: Text(
                    "0.45",//widget.runningData!.distance.toString(),
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontWeight: FontWeight.w600,
                        fontSize: 60),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 2, bottom: 7),
                  child: Text(
                    Languages.of(context)!.txtDistanceKM.toUpperCase(),
                    style: TextStyle(
                        color: Colur.txt_grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ) // Your body here
        );
  }

}
