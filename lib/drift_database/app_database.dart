import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_ws/drift_database/converters.dart';
import 'package:flutter_ws/drift_database/videos_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [VideosTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase({Future<Object> Function()? databaseDir, QueryExecutor? executor})
      : super(executor ?? _openConnection(databaseDir));

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(Future<Object> Function()? databaseDir) {
    return driftDatabase(
      name: 'mv_database',
      native: DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: databaseDir,
      ),
    );
  }
}
