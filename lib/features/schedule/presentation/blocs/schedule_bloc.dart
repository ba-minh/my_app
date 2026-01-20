import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/schedule_repository.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository repository;

  ScheduleBloc({required this.repository}) : super(ScheduleInitial()) {
    on<LoadSchedules>(_onLoadSchedules);
    on<AddSchedule>(_onAddSchedule);
    on<UpdateSchedule>(_onUpdateSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
  }

  Future<void> _onLoadSchedules(
    LoadSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      final schedules = await repository.getSchedules(event.deviceId);
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onAddSchedule(
    AddSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await repository.addSchedule(event.schedule);
      // Reload schedules
      add(LoadSchedules(event.schedule.deviceId));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onUpdateSchedule(
    UpdateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await repository.updateSchedule(event.schedule);
      add(LoadSchedules(event.schedule.deviceId));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onDeleteSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await repository.deleteSchedule(event.scheduleId);
      add(LoadSchedules(event.deviceId));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
