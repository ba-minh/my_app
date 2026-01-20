import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/schedule_entity.dart';

abstract class ScheduleLocalDatasource {
  Future<void> init();
  Future<List<ScheduleEntity>> getSchedules(String deviceId);
  Future<void> addSchedule(ScheduleEntity schedule);
  Future<void> updateSchedule(ScheduleEntity schedule);
  Future<void> deleteSchedule(String id);
}

class ScheduleLocalDatasourceImpl implements ScheduleLocalDatasource {
  static Database? _database;

  @override
  Future<void> init() async {
    if (_database != null) return;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'schedule.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE schedules (
            id TEXT PRIMARY KEY,
            name TEXT,
            deviceId TEXT,
            relayIndex INTEGER,
            hour INTEGER,
            minute INTEGER,
            repeatDays TEXT,
            action INTEGER,
            isEnabled INTEGER
          )
        ''');
      },
    );
  }

  Future<Database> get db async {
    if (_database == null) await init();
    return _database!;
  }

  @override
  Future<List<ScheduleEntity>> getSchedules(String deviceId) async {
    final finalDb = await db;
    final maps = await finalDb.query(
      'schedules',
      where: 'deviceId = ?',
      whereArgs: [deviceId],
    );

    return maps.map((map) {
      return ScheduleEntity(
        id: map['id'] as String,
        name: map['name'] as String,
        deviceId: map['deviceId'] as String,
        relayIndex: map['relayIndex'] as int,
        hour: map['hour'] as int,
        minute: map['minute'] as int,
        repeatDays: List<int>.from(jsonDecode(map['repeatDays'] as String)),
        action: (map['action'] as int) == 1,
        isEnabled: (map['isEnabled'] as int) == 1,
      );
    }).toList();
  }

  @override
  Future<void> addSchedule(ScheduleEntity schedule) async {
    final finalDb = await db;
    await finalDb.insert(
      'schedules',
      {
        'id': schedule.id,
        'name': schedule.name,
        'deviceId': schedule.deviceId,
        'relayIndex': schedule.relayIndex,
        'hour': schedule.hour,
        'minute': schedule.minute,
        'repeatDays': jsonEncode(schedule.repeatDays),
        'action': schedule.action ? 1 : 0,
        'isEnabled': schedule.isEnabled ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateSchedule(ScheduleEntity schedule) async {
    final finalDb = await db;
    await finalDb.update(
      'schedules',
      {
        'name': schedule.name,
        'deviceId': schedule.deviceId, // Should not change usually
        'relayIndex': schedule.relayIndex,
        'hour': schedule.hour,
        'minute': schedule.minute,
        'repeatDays': jsonEncode(schedule.repeatDays),
        'action': schedule.action ? 1 : 0,
        'isEnabled': schedule.isEnabled ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  @override
  Future<void> deleteSchedule(String id) async {
    final finalDb = await db;
    await finalDb.delete(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
