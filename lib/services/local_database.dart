import 'package:meyor_lite/models/cost_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._yagonaDarcha();

  static final _yagona = LocalDatabase._yagonaDarcha();

  factory LocalDatabase() {
    return _yagona;
  }

  final String _tableName = "costs";
  Database? _database;

  Future<void> init() async {
    _database ??= await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    final databasePath = await getApplicationDocumentsDirectory();
    final path = "${databasePath.path}/$_tableName.db";

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute("""CREATE TABLE $_tableName(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    date TEXT NOT NULL,
    cost REAL NOT NULL
    )""");
  }

  Future<List<CostModel>> getData() async {
    final data = await _database?.query(_tableName);

    List<CostModel> costs = [];

    if (data != null) {
      for (var cost in data) {
        costs.add(CostModel.fromMap(cost));
      }
    }
    return costs;
  }

  Future<int?> insert(CostModel cost) async {
    return await _database?.insert(_tableName, cost.toMap());
  }

  Future<void> update(CostModel cost) async {
    _database?.update(
      _tableName,
      cost.toMap(),
      where: "id=?",
      whereArgs: [cost.id],
    );
  }

  Future<void> delete(int id) async {
    await _database?.delete(_tableName, where: "id=?", whereArgs: [id]);
  }
}
