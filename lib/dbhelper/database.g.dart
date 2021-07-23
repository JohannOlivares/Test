// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  RunningDao? _runningDaoInstance;

  WaterDao? _waterDaoInstance;

  WeightDao? _weightDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RunningData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `duration` TEXT, `distance` TEXT, `speed` TEXT, `cal` TEXT, `sLat` TEXT, `sLong` TEXT, `eLat` TEXT, `eLong` TEXT, `path` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `water_table` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `ml` INTEGER, `date` TEXT, `time` TEXT, `date_time` TEXT, `total` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WeightData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `weightKg` TEXT, `weightLb` TEXT, `weightDate` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  RunningDao get runningDao {
    return _runningDaoInstance ??= _$RunningDao(database, changeListener);
  }

  @override
  WaterDao get waterDao {
    return _waterDaoInstance ??= _$WaterDao(database, changeListener);
  }

  @override
  WeightDao get weightDao {
    return _weightDaoInstance ??= _$WeightDao(database, changeListener);
  }
}

class _$RunningDao extends RunningDao {
  _$RunningDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _runningDataInsertionAdapter = InsertionAdapter(
            database,
            'RunningData',
            (RunningData item) => <String, Object?>{
                  'id': item.id,
                  'duration': item.duration,
                  'distance': item.distance,
                  'speed': item.speed,
                  'cal': item.cal,
                  'sLat': item.sLat,
                  'sLong': item.sLong,
                  'eLat': item.eLat,
                  'eLong': item.eLong,
                  'path': item.path
                },
            changeListener),
        _runningDataUpdateAdapter = UpdateAdapter(
            database,
            'RunningData',
            ['id'],
            (RunningData item) => <String, Object?>{
                  'id': item.id,
                  'duration': item.duration,
                  'distance': item.distance,
                  'speed': item.speed,
                  'cal': item.cal,
                  'sLat': item.sLat,
                  'sLong': item.sLong,
                  'eLat': item.eLat,
                  'eLong': item.eLong,
                  'path': item.path
                },
            changeListener),
        _runningDataDeletionAdapter = DeletionAdapter(
            database,
            'RunningData',
            ['id'],
            (RunningData item) => <String, Object?>{
                  'id': item.id,
                  'duration': item.duration,
                  'distance': item.distance,
                  'speed': item.speed,
                  'cal': item.cal,
                  'sLat': item.sLat,
                  'sLong': item.sLong,
                  'eLat': item.eLat,
                  'eLong': item.eLong,
                  'path': item.path
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RunningData> _runningDataInsertionAdapter;

  final UpdateAdapter<RunningData> _runningDataUpdateAdapter;

  final DeletionAdapter<RunningData> _runningDataDeletionAdapter;

  @override
  Future<RunningData?> findTaskById(int id) async {
    return _queryAdapter.query('SELECT * FROM RunningData WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RunningData(
            duration: row['duration'] as String?,
            distance: row['distance'] as String?,
            speed: row['speed'] as String?,
            cal: row['cal'] as String?,
            sLat: row['sLat'] as String?,
            eLong: row['eLong'] as String?,
            eLat: row['eLat'] as String?,
            sLong: row['sLong'] as String?,
            path: row['path'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<RunningData>> findAllTasks() async {
    return _queryAdapter.queryList('SELECT * FROM RunningData',
        mapper: (Map<String, Object?> row) => RunningData(
            duration: row['duration'] as String?,
            distance: row['distance'] as String?,
            speed: row['speed'] as String?,
            cal: row['cal'] as String?,
            sLat: row['sLat'] as String?,
            eLong: row['eLong'] as String?,
            eLat: row['eLat'] as String?,
            sLong: row['sLong'] as String?,
            path: row['path'] as String?));
  }

  @override
  Stream<List<RunningData>> findAllTasksAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM RunningData',
        mapper: (Map<String, Object?> row) => RunningData(
            duration: row['duration'] as String?,
            distance: row['distance'] as String?,
            speed: row['speed'] as String?,
            cal: row['cal'] as String?,
            sLat: row['sLat'] as String?,
            eLong: row['eLong'] as String?,
            eLat: row['eLat'] as String?,
            sLong: row['sLong'] as String?,
            path: row['path'] as String?),
        queryableName: 'RunningData',
        isView: false);
  }

  @override
  Future<void> insertTask(RunningData task) async {
    await _runningDataInsertionAdapter.insert(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTasks(List<RunningData> tasks) async {
    await _runningDataInsertionAdapter.insertList(
        tasks, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTask(RunningData task) async {
    await _runningDataUpdateAdapter.update(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTasks(List<RunningData> task) async {
    await _runningDataUpdateAdapter.updateList(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTask(RunningData task) async {
    await _runningDataDeletionAdapter.delete(task);
  }

  @override
  Future<void> deleteTasks(List<RunningData> tasks) async {
    await _runningDataDeletionAdapter.deleteList(tasks);
  }
}

class _$WaterDao extends WaterDao {
  _$WaterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _waterDataInsertionAdapter = InsertionAdapter(
            database,
            'water_table',
            (WaterData item) => <String, Object?>{
                  'id': item.id,
                  'ml': item.ml,
                  'date': item.date,
                  'time': item.time,
                  'date_time': item.dateTime,
                  'total': item.total
                }),
        _waterDataDeletionAdapter = DeletionAdapter(
            database,
            'water_table',
            ['id'],
            (WaterData item) => <String, Object?>{
                  'id': item.id,
                  'ml': item.ml,
                  'date': item.date,
                  'time': item.time,
                  'date_time': item.dateTime,
                  'total': item.total
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WaterData> _waterDataInsertionAdapter;

  final DeletionAdapter<WaterData> _waterDataDeletionAdapter;

  @override
  Future<List<WaterData>> getAllDrinkWater() async {
    return _queryAdapter.queryList('SELECT * FROM water_table',
        mapper: (Map<String, Object?> row) => WaterData(
            id: row['id'] as int?,
            ml: row['ml'] as int?,
            date: row['date'] as String?,
            time: row['time'] as String?,
            dateTime: row['date_time'] as String?,
            total: row['total'] as int?));
  }

  @override
  Future<List<WaterData>> getTodayDrinkWater(String date) async {
    return _queryAdapter.queryList(
        'SELECT * FROM water_table WHERE date = ?1 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => WaterData(
            id: row['id'] as int?,
            ml: row['ml'] as int?,
            date: row['date'] as String?,
            time: row['time'] as String?,
            dateTime: row['date_time'] as String?,
            total: row['total'] as int?),
        arguments: [date]);
  }

  @override
  Future<WaterData?> getTotalOfDrinkWater(String date) async {
    return _queryAdapter.query(
        'SELECT IFNULL(SUM(ml),0) as total FROM water_table WHERE date = ?1',
        mapper: (Map<String, Object?> row) => WaterData(
            id: row['id'] as int?,
            ml: row['ml'] as int?,
            date: row['date'] as String?,
            time: row['time'] as String?,
            dateTime: row['date_time'] as String?,
            total: row['total'] as int?),
        arguments: [date]);
  }

  @override
  Future<List<WaterData>> getTotalDrinkWaterAllDays(List<String> date) async {
    const offset = 1;
    final _sqliteVariablesForDate =
        Iterable<String>.generate(date.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT *, (SELECT IFNULL(SUM(ml),0) FROM water_table WHERE date = wt2.date) as total FROM water_table as wt2 WHERE date IN(' +
            _sqliteVariablesForDate +
            ') GROUP BY date',
        mapper: (Map<String, Object?> row) => WaterData(id: row['id'] as int?, ml: row['ml'] as int?, date: row['date'] as String?, time: row['time'] as String?, dateTime: row['date_time'] as String?, total: row['total'] as int?),
        arguments: [...date]);
  }

  @override
  Future<WaterData?> getTotalDrinkWaterAverage(List<String> date) async {
    const offset = 1;
    final _sqliteVariablesForDate =
        Iterable<String>.generate(date.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.query(
        'SELECT *, IFNULL(SUM(ml),0) as total FROM water_table WHERE date IN(' +
            _sqliteVariablesForDate +
            ')',
        mapper: (Map<String, Object?> row) => WaterData(
            id: row['id'] as int?,
            ml: row['ml'] as int?,
            date: row['date'] as String?,
            time: row['time'] as String?,
            dateTime: row['date_time'] as String?,
            total: row['total'] as int?),
        arguments: [...date]);
  }

  @override
  Future<void> insertDrinkWater(WaterData waterData) async {
    await _waterDataInsertionAdapter.insert(
        waterData, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTodayDrinkWater(WaterData waterData) async {
    await _waterDataDeletionAdapter.delete(waterData);
  }
}

class _$WeightDao extends WeightDao {
  _$WeightDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _weightDataInsertionAdapter = InsertionAdapter(
            database,
            'WeightData',
            (WeightData item) => <String, Object?>{
                  'id': item.id,
                  'weightKg': item.weightKg,
                  'weightLb': item.weightLb,
                  'weightDate': item.weightDate
                },
            changeListener),
        _weightDataUpdateAdapter = UpdateAdapter(
            database,
            'WeightData',
            ['id'],
            (WeightData item) => <String, Object?>{
                  'id': item.id,
                  'weightKg': item.weightKg,
                  'weightLb': item.weightLb,
                  'weightDate': item.weightDate
                },
            changeListener),
        _weightDataDeletionAdapter = DeletionAdapter(
            database,
            'WeightData',
            ['id'],
            (WeightData item) => <String, Object?>{
                  'id': item.id,
                  'weightKg': item.weightKg,
                  'weightLb': item.weightLb,
                  'weightDate': item.weightDate
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WeightData> _weightDataInsertionAdapter;

  final UpdateAdapter<WeightData> _weightDataUpdateAdapter;

  final DeletionAdapter<WeightData> _weightDataDeletionAdapter;

  @override
  Future<WeightData?> findTaskById(int id) async {
    return _queryAdapter.query('SELECT * FROM WeightData WHERE id = ?1',
        mapper: (Map<String, Object?> row) => WeightData(
            weightKg: row['weightKg'] as String?,
            weightLb: row['weightLb'] as String?,
            weightDate: row['weightDate'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<WeightData>> findAllTasks() async {
    return _queryAdapter.queryList('SELECT * FROM WeightData',
        mapper: (Map<String, Object?> row) => WeightData(
            weightKg: row['weightKg'] as String?,
            weightLb: row['weightLb'] as String?,
            weightDate: row['weightDate'] as String?));
  }

  @override
  Stream<List<WeightData>> findAllTasksAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM WeightData',
        mapper: (Map<String, Object?> row) => WeightData(
            weightKg: row['weightKg'] as String?,
            weightLb: row['weightLb'] as String?,
            weightDate: row['weightDate'] as String?),
        queryableName: 'WeightData',
        isView: false);
  }

  @override
  Future<void> insertTask(WeightData task) async {
    await _weightDataInsertionAdapter.insert(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTasks(List<WeightData> tasks) async {
    await _weightDataInsertionAdapter.insertList(
        tasks, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTask(WeightData task) async {
    await _weightDataUpdateAdapter.update(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTasks(List<WeightData> task) async {
    await _weightDataUpdateAdapter.updateList(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTask(WeightData task) async {
    await _weightDataDeletionAdapter.delete(task);
  }

  @override
  Future<void> deleteTasks(List<WeightData> tasks) async {
    await _weightDataDeletionAdapter.deleteList(tasks);
  }
}
