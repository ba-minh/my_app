import '../entities/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> getSchedules(String deviceId);
  Future<void> addSchedule(ScheduleEntity schedule);
  Future<void> updateSchedule(ScheduleEntity schedule);
  Future<void> deleteSchedule(String id);
}
