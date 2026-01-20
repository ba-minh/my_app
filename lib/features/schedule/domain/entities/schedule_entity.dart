import 'package:equatable/equatable.dart';

class ScheduleEntity extends Equatable {
  final String id;
  final String name;
  final String deviceId;
  final int relayIndex;
  final int hour;
  final int minute;
  final List<int> repeatDays; // 2=Mon, 8=Sun. Empty = One time.
  final bool action; // true: Turn ON, false: Turn OFF
  final bool isEnabled;

  const ScheduleEntity({
    required this.id,
    required this.name,
    required this.deviceId,
    required this.relayIndex,
    required this.hour,
    required this.minute,
    required this.repeatDays,
    required this.action,
    required this.isEnabled,
  });

  ScheduleEntity copyWith({
    String? id,
    String? name,
    String? deviceId,
    int? relayIndex,
    int? hour,
    int? minute,
    List<int>? repeatDays,
    bool? action,
    bool? isEnabled,
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      relayIndex: relayIndex ?? this.relayIndex,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeatDays: repeatDays ?? this.repeatDays,
      action: action ?? this.action,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        deviceId,
        relayIndex,
        hour,
        minute,
        repeatDays,
        action,
        isEnabled,
      ];
}
