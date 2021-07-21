import 'package:floor/floor.dart';
import 'package:run_tracker/dbhelper/datamodel/WeightData.dart';

@dao
abstract class WeightDao {
  @Query('SELECT * FROM WeightData WHERE id = :id')
  Future<WeightData?> findTaskById(int id);

  @Query('SELECT * FROM WeightData')
  Future<List<WeightData>> findAllTasks();

  @Query('SELECT * FROM WeightData')
  Stream<List<WeightData>> findAllTasksAsStream();

  @insert
  Future<void> insertTask(WeightData task);

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