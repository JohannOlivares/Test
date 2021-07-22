import 'package:floor/floor.dart';

@entity
class RunningData {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String? duration;
  String? distance;
  String? speed;
  String? cal;
  String? sLat;
  String? sLong;
  String? eLat;
  String? eLong;
  String? path;

  RunningData(
      {this.duration,
      this.distance,
        this.speed,
        this.cal,
      this.sLat,
      this.eLong,
      this.eLat,
      this.sLong,
      this.path});

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
