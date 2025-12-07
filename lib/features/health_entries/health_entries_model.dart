import 'package:course_work_1a/db/database_helper.dart';

class HealthRecord {
  final int? id;
  final String date;
  final int steps;
  final int calories;
  final int water; // in ml

  HealthRecord({
    this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.water,
  });

  // Convert HealthRecord to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnDate: date,
      DatabaseHelper.columnSteps: steps,
      DatabaseHelper.columnCalories: calories,
      DatabaseHelper.columnWater: water,
    };
  }

  // Create HealthRecord from Map (database row)
  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map[DatabaseHelper.columnId] as int?,
      date: map[DatabaseHelper.columnDate] as String,
      steps: map[DatabaseHelper.columnSteps] as int,
      calories: map[DatabaseHelper.columnCalories] as int,
      water: map[DatabaseHelper.columnWater] as int,
    );
  }

  // Create a copy with updated fields
  HealthRecord copyWith({
    int? id,
    String? date,
    int? steps,
    int? calories,
    int? water,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      water: water ?? this.water,
    );
  }

  @override
  String toString() {
    return 'HealthRecord(id: $id, date: $date, steps: $steps, calories: $calories, water: $water ml)';
  }
}

