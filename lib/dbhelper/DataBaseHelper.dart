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
    _database = await $FloorFlutterDatabase
        .databaseBuilder('flutter_database.db')
        .build();
    return _database;
  }

  Future<WaterData> insertDrinkWater(WaterData data) async {
    final waterDao = _database!.waterDao;
    await waterDao.insertDrinkWater(data);
    Debug.printLog("Insert Data Successfully  ==> " + data.ml.toString() + " CurrentTime ==> " + data.dateTime.toString());
    return data;
  }

  selectDrinkWater() async {
    final waterDao = _database!.waterDao;
    final result = await waterDao.getAllDrinkWater();
    Debug.printLog("Selected Data Successfully  ==> " + result[1].ml.toString() + result[1].dateTime.toString());
    return result;
  }

}
