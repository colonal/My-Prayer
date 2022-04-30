import 'package:sqflite/sqflite.dart';

import '../constnats/sql.dart';
import '../data/models/times_prayers.dart';
import 'db_helper.dart';

class ContatoDAO {
  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<void> insert({required TimesPrayers timesPrayers}) async {
    try {
      Database db = await _getDatabase();
      await db
          .rawInsert(ConnectionSQL.insertPrayer(timesPrayers: timesPrayers));
    } catch (error) {
      print("error insert: $error");
    }
  }

  Future<List> select() async {
    try {
      Database db = await _getDatabase();
      List<Map> linhas = await db.rawQuery(ConnectionSQL.selectAllPrayer());
      List contatos = linhas;
      return contatos;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> delete() async {
    try {
      Database db = await _getDatabase();
      int linhasAfetadas = await db.delete("prayer");
      if (linhasAfetadas > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print("error delete: $error");
      return false;
    }
  }
}
