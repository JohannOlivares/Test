import 'dart:async';

import 'package:floor/floor.dart';
import 'package:run_tracker/dbhelper/dao/RunningDao.dart';
import 'package:run_tracker/dbhelper/datamodel/RunningData.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';

@Database(version: 1, entities: [RunningData])
abstract class FlutterDatabase extends FloorDatabase {
  RunningDao get runningDao;
}
