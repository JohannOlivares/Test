import 'package:run_tracker/dbhelper/database.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';
import 'package:run_tracker/dbhelper/datamodel/WaterData.dart';
import 'package:run_tracker/dbhelper/datamodel/WeightData.dart';
import 'package:run_tracker/utils/Debug.dart';
import 'package:run_tracker/utils/Utils.dart';

class DataBaseHelper {
  static final DataBaseHelper _dataBaseHelper = DataBaseHelper._internal();

  factory DataBaseHelper() {
    return _dataBaseHelper;
  }

  DataBaseHelper._internal();

  static FlutterDatabase? _database;

  Future<FlutterDatabase?> initialize() async {
    _database =
        await $FloorFlutterDatabase.databaseBuilder('running_app.db').build();
    return _database;
  }

  //<!----------------------------- Water Table Operations ---------------------------------------------------!>

  Future<WaterData> insertDrinkWater(WaterData data) async {
    final waterDao = _database!.waterDao;
    await waterDao.insertDrinkWater(data);
    Debug.printLog("Insert DrinkWater Data Successfully  ==> " +
        data.ml.toString() +
        " CurrentTime ==> " +
        data.dateTime.toString() +
        " Date ==> " +
        data.date.toString() +
        " Time ==> " +
        data.time.toString());
    return data;
  }

  Future<List<WaterData>> selectDrinkWater() async {
    final waterDao = _database!.waterDao;
    final List<WaterData> result = await waterDao.getAllDrinkWater();
    result.forEach((element) {
      Debug.printLog("Select DrinkWater Data Successfully  ==> Id =>" +
          element.id.toString() +
          " Ml =>" +
          element.ml.toString() +
          " Date ==> " +
          element.date.toString() +
          " Time ==> " +
          element.time.toString() +
          " DateTime => " +
          element.dateTime.toString());
    });
    return result;
  }

  Future<List<WaterData>> selectTodayDrinkWater(String date) async {
    final waterDao = _database!.waterDao;
    final List<WaterData> result = await waterDao.getTodayDrinkWater(date);
    result.forEach((element) {
      Debug.printLog("Select Today DrinkWater Data Successfully  ==> Id =>" +
          element.id.toString() +
          " Ml =>" +
          element.ml.toString() +
          " Date ==> " +
          element.date.toString() +
          " Time ==> " +
          element.time.toString() +
          " DateTime => " +
          element.dateTime.toString());
    });
    return result;
  }

  Future<List<RunningData>> selectMapHistory() async {
    final runningDao = _database!.runningDao;
    final result = await runningDao.getAllHistory();
    return result;
  }

  Future<List<RunningData>> getRecentTasksAsStream() async {
    final runningDao = _database!.runningDao;
    final result = await runningDao.findRecentTasksAsStream();
    return result;
  }

  static Future<void> insertRunningData(RunningData data) async {
    final runningDao = _database!.runningDao;
    int id  = await runningDao.insertTask(data);
    Debug.printLog("insertRunningData Data Successfully  ==> " + id.toString());
    return;
  }

  static Future<void> deleteRunningData(RunningData data) async {
    final runningDao = _database!.runningDao;
    await runningDao.deleteTask(data);
    Debug.printLog(
        "Delete RunningData History==> " + data.toString());
  }

  static Future<RunningData?> getMaxDistance()async{
     final runningDao = _database!.runningDao;
     final maxDistance = await runningDao.findLongestDistance();
     Debug.printLog(maxDistance.toString());
     return maxDistance!;
  }

  static Future<RunningData?> getMaxPace()async{
    final runningDao = _database!.runningDao;
    final maxPace = await runningDao.findBestPace();
    Debug.printLog(maxPace.toString());
    return maxPace!;
  }

  static Future<RunningData?> getLongestDuration()async{
    final runningDao = _database!.runningDao;
    final longestDuration = await runningDao.findMaxDuration();
    Debug.printLog(longestDuration.toString());
    return longestDuration!;
  }

  //======================================

  static Future<int?> getTotalDrinkWater(String date) async {
    final waterDao = _database!.waterDao;
    // final waterDao = await _database!.database.rawQuery('SELECT SUM(ml) as Total FROM WaterData');
    final totalDrinkWater = await waterDao.getTotalOfDrinkWater(date);
    Debug.printLog("Total DrinkWater ==> " + totalDrinkWater!.total.toString());
    return totalDrinkWater.total;
  }

  static Future<List<WaterData>> getTotalDrinkWaterAllDays(List<String> date) async {
    final waterDao = _database!.waterDao;
    final totalDrinkWater = await waterDao.getTotalDrinkWaterAllDays(date);
    totalDrinkWater.forEach((element) {
      Debug.printLog("Total DrinkWater For Week Days ==> " +
          element.total.toString() +
          " Date ==> " +
          element.date.toString());
    });
    return totalDrinkWater;
  }

  static Future<int?> getTotalDrinkWaterAverage(List<String> date) async {
    final waterDao = _database!.waterDao;
    final totalDrinkWater = await waterDao.getTotalDrinkWaterAverage(date);
    Debug.printLog(
        "Daily Average DrinkWater ==> " + totalDrinkWater!.total.toString());
    return totalDrinkWater.total;
  }

 static Future<WaterData> deleteTodayDrinkWater(WaterData data) async {
    final waterDao = _database!.waterDao;
    await waterDao.deleteTodayDrinkWater(data);
    Debug.printLog(
        "Delete DrinkWater From Today History==> " + data.toString());
    return data;
  }

  //<!----------------------------- Weight Table Operations ---------------------------------------------------!>

  Future<WeightData> insertWeight(WeightData data) async {
    final weightDao = _database!.weightDao;
    await weightDao.insertWeight(data);
    Debug.printLog("Insert Weight Data Successfully  ==> " +
        " Id ==> " +
        data.id.toString() +
        " Weight Kg ==> " +
        data.weightKg.toString() +
        " Weight Lbs ==> " +
        data.weightLbs.toString() +
        " Date ==> " +
        data.date.toString() +
        " Time ==> " +
        data.time.toString() +
        " Date Time ==> " +
        data.dateTime.toString());
    return data;
  }

  Future<List<WeightData>> selectWeight() async {
    final weightDao = _database!.weightDao;
    final List<WeightData> result = await weightDao.selectAllWeight();
    result.forEach((element) {
      Debug.printLog("Select Weight Data Successfully  ==>" +
          " Id ==> " +
          element.id.toString() +
          " Weight Kg ==> " +
          element.weightKg.toString() +
          " Weight Lbs ==> " +
          element.weightLbs.toString() +
          " Date ==> " +
          element.date.toString() +
          " Time ==> " +
          element.time.toString() +
          " Date Time ==> " +
          element.dateTime.toString());
    });
    return result;
  }


}
