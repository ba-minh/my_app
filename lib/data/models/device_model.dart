import '../../domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required String id,
    required String name,
    required int status,
    required List<int> relays,
    required List<int> inputs,
    required List<double> temp,
    required List<double> hum,
    List<String> relayNames = const [],
    required int timestamp,
  }) : super(
          id: id,
          name: name,
          status: status,
          relays: relays,
          inputs: inputs,
          temp: temp,
          hum: hum,
          relayNames: relayNames,
          timestamp: timestamp,
        );

  // Parse JSON từ Server trả về (Theo tài liệu PDF)
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['device_id'] ?? '',
      name: json['name'] ?? 'Tủ điều khiển ${json['device_id'] ?? ''}', // Tự đặt tên nếu server chưa trả về
      status: json['status'] ?? 0,
      // Chuyển đổi mảng dynamic sang List<int> an toàn
      relays: List<int>.from(json['relays'] ?? []), 
      inputs: List<int>.from(json['inputs'] ?? []),
      // Xử lý số thực an toàn (tránh lỗi int/double lẫn lộn)
      temp: (json['temp'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ?? [],

      hum: (json['hum'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ?? [],
      relayNames: (json['relay_names'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [],
      timestamp: json['timestamp'] ?? 0,
    );
  }

  // Chuyển ngược lại thành JSON (nếu cần gửi đi)
  Map<String, dynamic> toJson() {
    return {
      'device_id': id,
      'name': name,
      'status': status,
      'relays': relays,
      'inputs': inputs,
      'temp': temp,
      'hum': hum,
      'relay_names': relayNames,
      'timestamp': timestamp,
    };
  }
}