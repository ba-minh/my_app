import '../entities/device_entity.dart';

abstract class DeviceRepository {
  // Lấy danh sách thiết bị của User
  Future<List<DeviceEntity>> getUserDevices();
  
  // Sau này sẽ thêm hàm điều khiển (Control) ở đây
}