import 'package:floor/floor.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';

@dao
abstract class RunningDao {
  @Query('SELECT * FROM running WHERE id = :id')
  Future<RunningData?> findTaskById(int id);

  @Query('SELECT * FROM running')
  Future<List<RunningData>> findAllTasks();

  @Query('SELECT * FROM running')
  Stream<List<RunningData>> findAllTasksAsStream();

  @insert
  Future<void> insertTask(RunningData task);

  @insert
  Future<void> insertTasks(List<RunningData> tasks);

  @update
  Future<void> updateTask(RunningData task);

  @update
  Future<void> updateTasks(List<RunningData> task);

  @delete
  Future<void> deleteTask(RunningData task);

  @delete
  Future<void> deleteTasks(List<RunningData> tasks);
}