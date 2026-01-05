part of 'device_bloc.dart';

abstract class DeviceEvent {}

// Sự kiện 1: Thêm thiết bị mới
class AddDeviceEvent extends DeviceEvent {
  final Map<String, dynamic> newDevice;
  AddDeviceEvent(this.newDevice);
}

// Sự kiện 2: Bật/Tắt thiết bị (Toggle)
class ToggleDeviceEvent extends DeviceEvent {
  final int index;
  final bool isOn; // Trạng thái mới
  ToggleDeviceEvent({required this.index, required this.isOn});
}