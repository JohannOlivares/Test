import 'package:floor/floor.dart';

@Entity(tableName: "weight_table")
class WeightData {
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: 'id')
  final int? id;

  @ColumnInfo(name: 'weight_kg')
  final double? weightKg;

  @ColumnInfo(name: 'weight_lbs')
  final double? weightLbs;

  @ColumnInfo(name: 'date')
  final String? date;

  @ColumnInfo(name: 'time')
  final String? time;

  @ColumnInfo(name: "date_time")
  final String? dateTime;

  WeightData(
      {this.id,
      required this.weightKg,
      required this.weightLbs,
      required this.date,
      required this.time,
      required this.dateTime});
}
