import 'dart:convert';
import 'dart:io';

import 'package:floor/floor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@entity
class RunningData {
  @PrimaryKey(autoGenerate: true)
  int? id;

   int? duration;
  double? distance;
  double? speed;
  double? cal;
  String? sLat;
  String? sLong;
  String? eLat;
  String? eLong;
  String? image;
  String? polyLine;
  String? date;
  int? lowIntenseTime;
  int? moderateIntenseTime;
  int? highIntenseTime;
  double? total;

  @ignore
  File? imageFile;


  RunningData(
      {this.id,
        this.duration,
      this.distance,
        this.speed,
        this.cal,
      this.sLat,
      this.eLong,
      this.eLat,
      this.sLong,
      this.image,this.polyLine,this.date,
      this.lowIntenseTime,this.moderateIntenseTime,this.highIntenseTime,this.total});




  File? getImage(){
    File? file;
    if(image != null) {
      file = File(image!);
    }

    return file;
  }

  List<LatLng>? getPolyLineData()
  {
    List<LatLng> polylineData = [];

    List<dynamic> list = jsonDecode(polyLine!);

    list.forEach((element) {
      var lat = double.parse((element as List<dynamic>)[0].toString());
      var long = double.parse((element as List<dynamic>)[1].toString());

      polylineData.add(LatLng(lat, long));
    });

    return polylineData;
  }

/*@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RunningData &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              message == other.message;

  @override
  int get hashCode => id.hashCode ^ message.hashCode;

  @override
  String toString() {
    return 'Task{id: $id, message: $message}';
  }*/


}
