part of 'device_bloc.dart';

abstract class DeviceEvent {}

// 1. Tải danh sách thiết bị (Home)
class LoadDevices extends DeviceEvent {}

// 2. Thêm thiết bị mới
class AddDeviceItem extends DeviceEvent {
  final Map<String, dynamic> deviceData;
  final String type; // 'cabinet', 'device', 'sensor'
  AddDeviceItem(this.deviceData, this.type);
}

// 3. Xóa thiết bị
class DeleteDeviceItem extends DeviceEvent {
  final int index;
  final String type;
  DeleteDeviceItem(this.index, this.type);
}

// 4. Cập nhật
class UpdateDeviceItem extends DeviceEvent {
  final int index;
  final Map<String, dynamic> newData;
  final String type;
  UpdateDeviceItem({required this.index, required this.newData, required this.type});
}

// 5. Toggle (Bật/Tắt)
class ToggleDeviceStatus extends DeviceEvent {
  final int index;
  ToggleDeviceStatus(this.index);
}

// 6. Reset
class ResetDeviceEvent extends DeviceEvent {}

// 👇 7. MỚI: CHỌN TỦ ĐIỆN ĐỂ XEM CHI TIẾT
// (Sự kiện này sẽ biến dữ liệu Entity thành UI)
class SelectDevice extends DeviceEvent {
  final DeviceEntity device;
  SelectDevice(this.device);
}