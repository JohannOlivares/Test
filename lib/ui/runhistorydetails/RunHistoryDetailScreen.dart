import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:run_tracker/dbhelper/DataBaseHelper.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';
import 'package:run_tracker/localization/language/languages.dart';
import 'package:run_tracker/utils/Color.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Utils.dart';
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
  Map<PolylineId, Polyline> polylines = {};
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

    //this is For add Markers in Map
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

    Debug.printLog(widget.recentActivitiesData.polyLine!);
    //Utils.showToast(context, "PolyLines Added");
    _drawPolyLines();

  }

  _drawPolyLines(){
    _polylineList = widget.recentActivitiesData.getPolyLineData()!;
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id, color: Colors.black, points: _polylineList,width: 4,);
    polylines[id] = polyline;

    _animateCameraToPosition(_controller);

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
    _animateCameraToPosition(_controller);
  }

  _animateCameraToPosition(GoogleMapController? _controller){
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
      return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
    }

    //After adding polylines list for Calculate NorthEast And South West Positions and Animate Camera
    Future.delayed(Duration(milliseconds: 10)).then((value) {
      jsonEncode(_polylineList);
      LatLngBounds latLngBounds = boundsFromLatLngList(_polylineList);
      _controller!.animateCamera(CameraUpdate.newLatLngBounds(
          latLngBounds,
          100
      ));
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
            polylines:Set<Polyline>.of(polylines.values),
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
            color: Colors.lightGreen,
            margin:
            EdgeInsets.only(left: 15, right: 15, top: fullheight * 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               /////
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 55.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
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
                        //DELETE

                        _showDeleteDialog(context);
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
                InkWell(
                  child: Container(
                    height: 44,
                    width: 44,
                    margin: EdgeInsets.only(right: 15.0,top: 5),
                    decoration: BoxDecoration(
                        color: Colur.txt_white,

                        borderRadius:
                        BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/icons/ic_setalite.png',
                        color: setaliteEnable
                            ? Colur.purple_gradient_color2
                            : Colur.txt_grey,
                      ),
                    ),
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
            alignment: Alignment.bottomCenter,
            child: _bottomSheetDialog(context),
          ),
        ],
      ),
    );
  }

  _showDeleteDialog(BuildContext context){
    return  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Languages.of(context)!.txtDeleteHitory),
          content: Text(Languages.of(context)!.txtDeleteConfirmationMessage),
          actions: [
            FlatButton(
              child: Text(Languages.of(context)!.txtCancel),
              onPressed: () async {
                Navigator.pop(context);

              },
            ),
        FlatButton(
        child: Text(Languages.of(context)!.txtDelete.toUpperCase()),
        onPressed: () async {
          await DataBaseHelper.deleteRunningData(widget.recentActivitiesData).then((value) => Navigator.of(context)
              .pushNamedAndRemoveUntil('/homeWizardScreen', (Route<dynamic> route) => false));

        },
        ),

          ],
        );
      },
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
                              widget.recentActivitiesData.duration.toString(),
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
                              widget.recentActivitiesData.speed.toString(), //widget.runningData!.speed.toString(),
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
                              widget.recentActivitiesData.cal.toString(), //widget.runningData!.cal.toString(),
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
                    widget.recentActivitiesData.distance.toString(),//widget.runningData!.distance.toString(),
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
