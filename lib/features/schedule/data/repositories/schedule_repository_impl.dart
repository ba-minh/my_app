import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/schedule_entity.dart';
import '../datasources/schedule_local_datasource.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleLocalDatasource localDataSource;

  ScheduleRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ScheduleEntity>> getSchedules(String deviceId) async {
    return await localDataSource.getSchedules(deviceId);
  }

  @override
  Future<void> addSchedule(ScheduleEntity schedule) async {
    await localDataSource.addSchedule(schedule);
  }

  @override
  Future<void> updateSchedule(ScheduleEntity schedule) async {
    await localDataSource.updateSchedule(schedule);
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await localDataSource.deleteSchedule(id);
  }
}
