import '../../domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required String id,
    required String name,
    required int status,
    required List<int> relays,
    required List<int> inputs,
    required List<double> temps,
    required List<double> hums,
    required int timestamp,
  }) : super(
          id: id,
          name: name,
          status: status,
          relays: relays,
          inputs: inputs,
          temps: temps,
          hums: hums,
          timestamp: timestamp,
        );

  // Parse JSON từ Server trả về (Theo tài liệu PDF)
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['device_id'] ?? '',
      name: json['name'] ?? 'Tủ điều khiển ${json['device_id'] ?? ''}', // Tự đặt tên nếu server chưa trả về
      status: json['status'] ?? 0,
      // Chuyển đổi mảng dynamic sang List<int> an toàn
      relays: List<int>.from(json['relay'] ?? []), 
      inputs: List<int>.from(json['input'] ?? []),
      // Xử lý số thực an toàn (tránh lỗi int/double lẫn lộn)
      temps: (json['temp'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ?? [],

      hums: (json['hum'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ?? [],
      timestamp: json['timestamp'] ?? 0,
    );
  }

  // Chuyển ngược lại thành JSON (nếu cần gửi đi)
  Map<String, dynamic> toJson() {
    return {
      'device_id': id,
      'status': status,
      'relay': relays,
      'input': inputs,
      'temp': temps,
      'hum': hums,
      'timestamp': timestamp,
    };
  }
}