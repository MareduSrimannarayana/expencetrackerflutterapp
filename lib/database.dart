
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._internal();
  final String expenceTable = "Expence";
  final String tableIdColumnName = "ID";
  final String titleColumnName = "Title";
  final String amountColumnName = "Amount";
  final String dateColumnName = "Date";
  final String dropDownColumnName = "DropDown";

  DataBaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databaseDirectoryPath = await getDatabasesPath();
    final databasePath = join(databaseDirectoryPath, "master_db.db");

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $expenceTable (
            $tableIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $titleColumnName TEXT NOT NULL,
            $amountColumnName REAL NOT NULL,
            $dateColumnName TEXT NOT NULL,
            $dropDownColumnName TEXT NOT NULL)''',
        );
      },
    );
  }

  Future<void> addExpense(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(expenceTable, data);
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete(
      expenceTable,
      where: '$tableIdColumnName = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getExpenses(ref) async {
    final db = await database;
    final d = await db.query(expenceTable);
    // ref.refresh(expensesProvider);
    return d;
  }

  Future<Map<String, double>> getCategorySums() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT DropDown, SUM(Amount) AS total
      FROM Expence
      GROUP BY DropDown
    ''');

    Map<String, double> categorySums = {};
    for (var row in results) {
      categorySums[row['DropDown']] = row['total'] as double;
    }
    return categorySums;
  }

  Future<void> updateExpence(int id, Map<String, dynamic> data) async {
    final db = await database;
    await db.update(expenceTable, data,
        where: '$tableIdColumnName=?', whereArgs: [id]);
    print(" updateexpence ======${data}");
  }
}
