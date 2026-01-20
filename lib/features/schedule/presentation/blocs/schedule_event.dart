import 'package:equatable/equatable.dart';
import '../../domain/entities/schedule_entity.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchedules extends ScheduleEvent {
  final String deviceId;
  const LoadSchedules(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

class AddSchedule extends ScheduleEvent {
  final ScheduleEntity schedule;
  const AddSchedule(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class UpdateSchedule extends ScheduleEvent {
  final ScheduleEntity schedule;
  const UpdateSchedule(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class DeleteSchedule extends ScheduleEvent {
  final String scheduleId;
  final String deviceId; // Needed to reload list
  const DeleteSchedule(this.scheduleId, this.deviceId);

  @override
  List<Object?> get props => [scheduleId, deviceId];
}
