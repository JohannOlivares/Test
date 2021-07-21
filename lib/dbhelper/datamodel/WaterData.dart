import 'package:floor/floor.dart';

@entity
class WaterData {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final int? ml;
  final String? dateTime;

  WaterData({required this.ml,this.dateTime});
}