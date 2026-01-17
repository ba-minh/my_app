import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String COMMAND_QUEUE_KEY = 'OFFLINE_COMMAND_QUEUE';

// Model lệnh chờ
class QueuedCommand {
  final String deviceId;
  final String action; // Ví dụ: "TOGGLE"
  final Map<String, dynamic> payload; // Ví dụ: {"relay": 1, "val": 0}
  final int timestamp;

  QueuedCommand({
    required this.deviceId,
    required this.action,
    required this.payload,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'device_id': deviceId,
    'action': action,
    'payload': payload,
    'timestamp': timestamp,
  };

  factory QueuedCommand.fromJson(Map<String, dynamic> json) => QueuedCommand(
    deviceId: json['device_id'],
    action: json['action'],
    payload: json['payload'],
    timestamp: json['timestamp'],
  );
}

abstract class CommandQueueLocalDataSource {
  Future<void> addCommand(QueuedCommand command);
  Future<List<QueuedCommand>> getQueue();
  Future<void> removeCommand(int timestamp);
}

class CommandQueueLocalDataSourceImpl implements CommandQueueLocalDataSource {
  final SharedPreferences sharedPreferences;

  CommandQueueLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> addCommand(QueuedCommand command) async {
    final queue = await getQueue();
    queue.add(command);
    await _save(queue);
  }

  @override
  Future<List<QueuedCommand>> getQueue() async {
    final jsonString = sharedPreferences.getString(COMMAND_QUEUE_KEY);
    if (jsonString != null) {
      final List<dynamic> list = json.decode(jsonString);
      return list.map((e) => QueuedCommand.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> removeCommand(int timestamp) async {
    final queue = await getQueue();
    queue.removeWhere((element) => element.timestamp == timestamp);
    await _save(queue);
  }

  Future<void> _save(List<QueuedCommand> queue) async {
    final str = json.encode(queue.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(COMMAND_QUEUE_KEY, str);
  }
}
// Chưa sử dụng