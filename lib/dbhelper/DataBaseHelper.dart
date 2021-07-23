import 'dart:convert';

import 'package:run_tracker/dbhelper/database.dart';
import 'package:run_tracker/dbhelper/datamodel/WaterData.dart';
import 'package:run_tracker/utils/Debug.dart';

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

  Future<int?> getTotalDrinkWater(String date) async {
    final waterDao = _database!.waterDao;
    // final waterDao = await _database!.database.rawQuery('SELECT SUM(ml) as Total FROM WaterData');
    final totalDrinkWater = await waterDao.getTotalOfDrinkWater(date);
    Debug.printLog("Total DrinkWater ==> " + totalDrinkWater!.total.toString());
    return totalDrinkWater.total;
  }

  Future<List<WaterData>> getTotalDrinkWaterAllDays(List<String> date) async {
    final waterDao = _database!.waterDao;
    final totalDrinkWater = await waterDao.getTotalDrinkWaterAllDays(date);
    totalDrinkWater.forEach((element) {
      Debug.printLog("Total DrinkWater For Week Days ==> " +
          element.total.toString() + " Date ==> " + element.date.toString());
    });
    return totalDrinkWater;
  }

  Future<int?> getTotalDrinkWaterAverage(List<String> date) async {
    final waterDao = _database!.waterDao;
    final totalDrinkWater = await waterDao.getTotalDrinkWaterAverage(date);
    Debug.printLog("Daily Average DrinkWater ==> " + totalDrinkWater!.total.toString());
    return totalDrinkWater.total;
  }


  Future<WaterData> deleteTodayDrinkWater(WaterData data) async {
    final waterDao = _database!.waterDao;
    await waterDao.deleteTodayDrinkWater(data);
    Debug.printLog("Delete DrinkWater From Today History==> " + data.toString());
    return data;
  }
}
