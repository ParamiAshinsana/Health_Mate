import 'package:course_work_1a/db/database_helper.dart';
import 'package:course_work_1a/features/health_entries/health_entries_model.dart';

class HealthEntriesDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // CREATE - Insert a new health record
  Future<int> insertHealthRecord(HealthRecord record) async {
    final db = await _dbHelper.database;
    
    // Remove id from map since it's auto-incremented
    final map = record.toMap();
    map.remove(DatabaseHelper.columnId);
    
    return await db.insert(
      DatabaseHelper.tableHealthRecords,
      map,
    );
  }

  // READ - Get all health records
  Future<List<HealthRecord>> getAllHealthRecords() async {
    final db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableHealthRecords,
      orderBy: '${DatabaseHelper.columnDate} DESC',
    );

    return List.generate(maps.length, (i) {
      return HealthRecord.fromMap(maps[i]);
    });
  }

  // READ - Get a single health record by ID
  Future<HealthRecord?> getHealthRecordById(int id) async {
    final db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableHealthRecords,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return HealthRecord.fromMap(maps.first);
    }
    return null;
  }

  // READ - Get health records by date
  Future<List<HealthRecord>> getHealthRecordsByDate(String date) async {
    final db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableHealthRecords,
      where: '${DatabaseHelper.columnDate} = ?',
      whereArgs: [date],
    );

    return List.generate(maps.length, (i) {
      return HealthRecord.fromMap(maps[i]);
    });
  }

  // READ - Search health records by date range
  Future<List<HealthRecord>> searchHealthRecordsByDateRange(
    String startDate,
    String endDate,
  ) async {
    final db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableHealthRecords,
      where: '${DatabaseHelper.columnDate} BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: '${DatabaseHelper.columnDate} DESC',
    );

    return List.generate(maps.length, (i) {
      return HealthRecord.fromMap(maps[i]);
    });
  }

  // UPDATE - Update an existing health record
  Future<int> updateHealthRecord(HealthRecord record) async {
    final db = await _dbHelper.database;
    
    return await db.update(
      DatabaseHelper.tableHealthRecords,
      record.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [record.id],
    );
  }

  // DELETE - Delete a health record by ID
  Future<int> deleteHealthRecord(int id) async {
    final db = await _dbHelper.database;
    
    return await db.delete(
      DatabaseHelper.tableHealthRecords,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete all health records
  Future<int> deleteAllHealthRecords() async {
    final db = await _dbHelper.database;
    
    return await db.delete(DatabaseHelper.tableHealthRecords);
  }

  // Get total count of records
  Future<int> getRecordCount() async {
    final db = await _dbHelper.database;
    
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseHelper.tableHealthRecords}',
    );
    
    return result.first['count'] as int;
  }

  // Get records with pagination
  Future<List<HealthRecord>> getHealthRecordsPaginated(
    int limit,
    int offset,
  ) async {
    final db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableHealthRecords,
      orderBy: '${DatabaseHelper.columnDate} DESC',
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (i) {
      return HealthRecord.fromMap(maps[i]);
    });
  }
}

