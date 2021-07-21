import 'package:floor/floor.dart';

@entity
class RunningData {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final int? duration;
  final int? distance;
  final String? sLat;
  final String? sLong;
  final String? eLat;
  final String? eLong;
  final String? path;

  RunningData(
      {this.duration,
      this.distance,
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
