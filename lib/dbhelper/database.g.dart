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
            'CREATE TABLE IF NOT EXISTS `RunningData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `duration` INTEGER, `distance` INTEGER, `sLat` TEXT, `sLong` TEXT, `eLat` TEXT, `eLong` TEXT, `path` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  RunningDao get runningDao {
    return _runningDaoInstance ??= _$RunningDao(database, changeListener);
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
    return _queryAdapter.query('SELECT * FROM running WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            RunningData(id: row['id'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<RunningData>> findAllTasks() async {
    return _queryAdapter.queryList('SELECT * FROM running',
        mapper: (Map<String, Object?> row) =>
            RunningData(id: row['id'] as int?));
  }

  @override
  Stream<List<RunningData>> findAllTasksAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM running',
        mapper: (Map<String, Object?> row) =>
            RunningData(id: row['id'] as int?),
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
