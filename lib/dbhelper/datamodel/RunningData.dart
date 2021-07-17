import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

@entity
class RunningData {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  int? duration;
  int? distance;
  String? sLat;
  String? sLong;
  String? eLat;
  String? eLong;
  String? path;

  RunningData({required this.id});

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