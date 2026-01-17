import '../../models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<List<DeviceModel>> getUserDevices();
}

class DeviceMockDataSourceImpl implements DeviceRemoteDataSource {
  @override
  Future<List<DeviceModel>> getUserDevices() async {
    // Giả lập trễ mạng 1 giây để test hiệu ứng Loading
    await Future.delayed(const Duration(seconds: 1));

    // Trả về dữ liệu giả y hệt cấu trúc trong PDF 
    return [
      const DeviceModel(
        id: "4234235423",
        name: "Tủ Bơm 1 (Vườn Lan)",
        status: 1, // Online
        relays: [0, 0, 0, 1, 1], // Relay 1 & 4 đang bật
        inputs: [0, 1, 0],       // Input 2 đang kích hoạt
        temp: [29.1, 30.0],
        hum: [64.2, 61.7],
        timestamp: 1762591262,
      ),
      const DeviceModel(
        id: "999888777",
        name: "Tủ Quạt (Nhà Kính)",
        status: 0, // Offline
        relays: [0, 0, 0, 0],
        inputs: [0, 0],
        temp: [], // Không có cảm biến thì để rỗng
        hum: [],
        timestamp: 1762590000,
      ),
    ];

    // 2. Thêm dòng này để giả vờ mạng bị lỗi / Server sập
    // throw Exception("Lỗi kết nối Server (Giả lập)");
  }
}