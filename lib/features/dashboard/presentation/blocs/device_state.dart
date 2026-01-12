part of 'device_bloc.dart';

class DeviceState {
  // Trạng thái tải trang
  final bool isLoading;

  // Danh sách TỦ ĐIỆN (Dùng cho HomeTab) - Kiểu DeviceEntity
  final List<DeviceEntity> userDevices;
  
  // Danh sách 1: Cảm biến
  final List<Map<String, dynamic>> uiSensors;
  
  // Danh sách 2: Thiết bị đầu ra (IO)
  final List<Map<String, dynamic>> uiIODevices;

  DeviceState({
    this.isLoading = false,
    this.userDevices = const [],
    this.uiSensors = const [],
    this.uiIODevices = const [],
  });

  // Hàm copyWith cập nhật từng phần
  DeviceState copyWith({
    bool? isLoading,
    List<DeviceEntity>? userDevices,
    List<Map<String, dynamic>>? uiSensors,
    List<Map<String, dynamic>>? uiIODevices,
  }) {
    return DeviceState(
      isLoading: isLoading ?? this.isLoading,
      userDevices: userDevices ?? this.userDevices,
      uiSensors: uiSensors ?? this.uiSensors,
      uiIODevices: uiIODevices ?? this.uiIODevices,
    );
  }
}