part of 'device_bloc.dart';

class DeviceState {
  // Danh sách thiết bị hiện tại
  final List<Map<String, dynamic>> devices;

  DeviceState({this.devices = const []});

  // Hàm copyWith giúp tạo state mới dựa trên state cũ (để UI biết có thay đổi)
  DeviceState copyWith({List<Map<String, dynamic>>? devices}) {
    return DeviceState(
      devices: devices ?? this.devices,
    );
  }
}