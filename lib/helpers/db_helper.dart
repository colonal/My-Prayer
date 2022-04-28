import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../constnats/sql.dart';

class ConnectionSQLiteService {
  ConnectionSQLiteService._();

  static ConnectionSQLiteService? _instance;

  static ConnectionSQLiteService get instance {
    _instance ??= ConnectionSQLiteService._();
    return _instance!;
  }

  /* ============================================= */

  static const databaseName = 'prayer.db';
  static const databaseVersion = 2;
  Database? _db;

  Future<Database> get db => _openDatabase();

  Future<Database> c() async {
    sqfliteFfiInit();
    String databasePath = await databaseFactoryFfi.getDatabasesPath();

    String path = join(databasePath, databaseName);
    Directory(databasePath).create(recursive: true);
    DatabaseFactory databaseFactory = databaseFactoryFfi;

    _db ??= await databaseFactory.openDatabase(path,
        options:
            OpenDatabaseOptions(onCreate: _onCreate, version: databaseVersion));
    return _db!;
  }

  FutureOr<void> _onCreate(Database db, int version) {
    print("createDatabase");
    db.transaction((reference) async {
      reference.execute(ConnectionSQL.createDatabase);
    });
  }

  Future<Database> _openDatabase() async {
    var isSqfliteCompatible =
        !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
    DatabaseFactory? original;
    // Save original for iOS & Android
    if (isSqfliteCompatible) {
      original = databaseFactory;
    }

    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // Use sqflite databases path provider (ffi implementation is lame))
    if (isSqfliteCompatible) {
      await databaseFactory
          .setDatabasesPath(await original!.getDatabasesPath());
    }
    String databasePath = await databaseFactory.getDatabasesPath();

    String path = join(databasePath, databaseName);
    // print("_db!.getVersion():");
    // print("_db!.getVersion(): ${_db!.getVersion()}");
    print("path1: $path \n_db:${_db == null}");

    try {
      _db ??= await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(
              onCreate: _onCreate, version: databaseVersion));
    } catch (e) {
      print("ERE: $e");
    }

    // await _db!.execute("DROP TABLE prayer;");
    // _onCreate(_db!, databaseVersion);
    return _db!;
  }
}
