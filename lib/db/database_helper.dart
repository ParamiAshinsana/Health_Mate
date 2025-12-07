import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Database name and version
  static const String _databaseName = 'health_mate.db';
  static const int _databaseVersion = 1;

  // Table name
  static const String tableHealthRecords = 'health_records';

  // Column names
  static const String columnId = 'id';
  static const String columnDate = 'date';
  static const String columnSteps = 'steps';
  static const String columnCalories = 'calories';
  static const String columnWater = 'water';

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
    );
  }

  // Create tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableHealthRecords (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDate TEXT NOT NULL,
        $columnSteps INTEGER NOT NULL,
        $columnCalories INTEGER NOT NULL,
        $columnWater INTEGER NOT NULL
      )
    ''');
    // No dummy data - only real user data will be stored
  }

  // Close database
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

