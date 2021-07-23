import 'package:floor/floor.dart';
import 'package:run_tracker/dbhelper/datamodel/WaterData.dart';

@dao
abstract class WaterDao {
  @insert
  Future<void> insertDrinkWater(WaterData waterData);

  @Query('SELECT * FROM water_table')
  Future<List<WaterData>> getAllDrinkWater();

  @Query('SELECT * FROM water_table WHERE date = :date ORDER BY id DESC')
  Future<List<WaterData>> getTodayDrinkWater(String date);

  @Query('SELECT IFNULL(SUM(ml),0) as total FROM water_table WHERE date = :date')
  Future<WaterData?> getTotalOfDrinkWater(String date);

  @Query('SELECT *, (SELECT IFNULL(SUM(ml),0) FROM water_table WHERE date = wt2.date) as total FROM water_table as wt2 WHERE date IN(:date) GROUP BY date')
  Future<List<WaterData>> getTotalDrinkWaterAllDays(List<String> date);

  @Query('SELECT *, IFNULL(SUM(ml),0) as total FROM water_table WHERE date IN(:date)')
  Future<WaterData?> getTotalDrinkWaterAverage(List<String> date);

  @delete
  Future<void> deleteTodayDrinkWater(WaterData waterData);

  /*@Query('SELECT * FROM water_table WHERE id = :id')
  Future<WaterData?> findTaskById(int id);

  @Query('SELECT * FROM water_table')
  Stream<List<WaterData>> findAllTasksAsStream();

  @insert
  Future<void> insertTasks(List<WaterData> tasks);

  @update
  Future<void> updateTask(WaterData task);

  @update
  Future<void> updateTasks(List<WaterData> task);

  @delete
  Future<void> deleteTask(WaterData task);

  @delete
  Future<void> deleteTasks(List<WaterData> tasks);*/
}