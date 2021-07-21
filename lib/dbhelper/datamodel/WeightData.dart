import 'package:floor/floor.dart';

@entity
class WeightData {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String? weightKg;
  final String? weightLb;
  final String? weightDate;

  WeightData({required this.weightKg,this.weightLb,this.weightDate});
}