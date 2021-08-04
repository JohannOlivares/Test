import 'package:floor/floor.dart';
import 'package:run_tracker/dbhelper/datamodel/WeightData.dart';

@dao
abstract class WeightDao {
  @Query('SELECT * FROM weight_table WHERE id = :id')
  Future<WeightData?> selectWeightById(int id);

  @Query('SELECT * FROM weight_table')
  Future<List<WeightData>> selectAllWeight();

  @Query('SELECT * FROM weight_table')
  Stream<List<WeightData>> selectAllWeightAsStream();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWeight(WeightData task);

  @Query('SELECT AVG(weight_kg) as average FROM (SELECT * FROM weight_table ORDER BY id DESC LIMIT 30)')
  Future<WeightData?> selectLast30DaysWeightAverage();

  @insert
  Future<void> insertTasks(List<WeightData> tasks);

  @update
  Future<void> updateTask(WeightData task);

  @update
  Future<void> updateTasks(List<WeightData> task);

  @delete
  Future<void> deleteTask(WeightData task);

  @delete
  Future<void> deleteTasks(List<WeightData> tasks);
}