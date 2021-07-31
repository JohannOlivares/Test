import 'package:floor/floor.dart';
import 'package:run_tracker/dbhelper/datamodel/StepsData.dart';

@dao
abstract class StepsDao {

  @Query('SELECT * FROM steps_table WHERE id = :id')
  Future<StepsData?> findTaskById(int id);

  @Query('SELECT * FROM steps_table')
  Stream<List<StepsData>> findAllTasksAsStream();

  @insert
  Future<void> insertAllStepsData(StepsData stepsData);
  
  @insert
  Future<void> insertTasks(List<StepsData> tasks);

  @update
  Future<void> updateTask(StepsData task);

  @update
  Future<void> updateTasks(List<StepsData> task);

  @delete
  Future<void> deleteTask(StepsData task);

  @delete
  Future<void> deleteTasks(List<StepsData> tasks);

  @Query('SELECT * FROM steps_table')
  Future<List<StepsData>> getAllStepsData();

  @Query('SELECT * FROM steps_table WHERE (DATE(stepDate) >= DATE("now","weekday 1","-7 days"))')
  Future<List<StepsData>> getStepsForCurrentWeek();

  @Query('SELECT IFNULL(SUM(steps),0) as steps FROM steps_table WHERE DATE(stepDate) >= (SELECT DATE("now","-7 days"))')
  Future<StepsData?> getStepsForLast7Days();

  @Query('SELECT * FROM steps_table WHERE (DATE(stepDate) >= DATE("now","start of month"))')
  Future<List<StepsData>> getStepsForCurrentMonth();

  @Query('SELECT IFNULL(SUM(steps),0) as steps FROM steps_table WHERE (DATE(stepDate) >= DATE("now","start of month"))')
  Future<StepsData?> getTotalStepsForCurrentMonth();

  /*@Query('SELECT IFNULL(AVG(steps),0) as distance FROM steps_table WHERE (DATE(stepDate) >= DATE("now","start of month"))')
  Future<StepsData?> getAverageStepsForCurrentMonth();*/

  @Query('SELECT IFNULL(SUM(steps),0) as steps FROM steps_table WHERE (DATE(stepDate) >= DATE("now","weekday 1","-7 days"))')
  Future<StepsData?> getTotalStepsForCurrentWeek();


}