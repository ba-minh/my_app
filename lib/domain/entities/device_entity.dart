import 'package:equatable/equatable.dart';

class DeviceEntity extends Equatable {
  final String id;          // Mapping từ "device_id"
  final String name;        // Tên hiển thị (User tự đặt, mặc định lấy ID)
  final int status;         // 1: Online, 0: Offline (Mapping từ "status")
  final List<int> relays;   // Trạng thái các cổng ra (Mapping từ "relay": [1,0...])
  final List<int> inputs;   // Trạng thái các cổng vào (Mapping từ "input": [0,1...])
  final List<double> temps; // Danh sách nhiệt độ (thay vì temp)
  final List<double> hums;  // Danh sách độ ẩm (thay vì hum)
  final int timestamp;      // Thời gian cập nhật

  const DeviceEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.relays,
    required this.inputs,
    required this.temps,
    required this.hums,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, name, status, relays, inputs, temps, hums, timestamp];
}