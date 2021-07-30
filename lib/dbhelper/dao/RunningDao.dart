import 'package:floor/floor.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';

@dao
abstract class RunningDao {
  @Query('SELECT * FROM RunningData WHERE id = :id')
  Future<RunningData?> findTaskById(int id);

  @Query('SELECT * FROM RunningData')
  Future<List<RunningData>> getAllHistory();

  @Query('SELECT * FROM RunningData')
  Stream<List<RunningData>> findAllTasksAsStream();

  @Query('SELECT * FROM RunningData ORDER BY id DESC LIMIT 3')
  Future<List<RunningData>> findRecentTasksAsStream();

  @Query('SELECT *,IFNULL(MAX(distance),0) FROM RunningData')
  Future<RunningData?> findLongestDistance();

  @Query('SELECT *,IFNULL(MAX(speed),0) FROM RunningData')
  Future<RunningData?> findBestPace();

  @Query('SELECT *,IFNULL(MAX(duration),0) FROM RunningData')
  Future<RunningData?> findMaxDuration();

  @insert
  Future<int> insertTask(RunningData task);

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