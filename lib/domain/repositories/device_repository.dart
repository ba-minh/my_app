import '../entities/device_entity.dart';

abstract class DeviceRepository {
  // Lấy danh sách thiết bị của User
  Future<List<DeviceEntity>> getUserDevices();
  
  // Cập nhật thông tin thiết bị (ví dụ: đổi tên Relay)
  Future<void> updateDevice(DeviceEntity device);
  
  // Sau này sẽ thêm hàm điều khiển (Control) ở đây
}