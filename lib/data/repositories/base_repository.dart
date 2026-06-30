import 'package:sqflite/sqflite.dart';
import '../../core/services/DatabaseService.dart';

abstract class BaseRepository {
  final DatabaseService databaseService;

  BaseRepository(this.databaseService);

  Future<Database> get db async => await databaseService.database;

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final client = await db;
    return await client.insert(table, row);
  }

  Future<int> update(String table, Map<String, dynamic> row, String where, List<dynamic> whereArgs) async {
    final client = await db;
    return await client.update(table, row, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs}) async {
    final client = await db;
    return await client.query(table, where: where, whereArgs: whereArgs);
  }
}
