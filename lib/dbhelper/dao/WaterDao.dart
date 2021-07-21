import 'package:floor/floor.dart';
import 'package:run_tracker/dbhelper/datamodel/WaterData.dart';

@dao
abstract class WaterDao {
  @Query('SELECT * FROM WaterData WHERE id = :id')
  Future<WaterData?> findTaskById(int id);

  @Query('SELECT * FROM WaterData')
  Future<List<WaterData>> getAllDrinkWater();

  @Query('SELECT * FROM WaterData')
  Stream<List<WaterData>> findAllTasksAsStream();

  @insert
  Future<void> insertTasks(List<WaterData> tasks);

  @insert
  Future<void> insertDrinkWater(WaterData waterData);

  @update
  Future<void> updateTask(WaterData task);

  @update
  Future<void> updateTasks(List<WaterData> task);

  @delete
  Future<void> deleteTask(WaterData task);

  @delete
  Future<void> deleteTasks(List<WaterData> tasks);
}