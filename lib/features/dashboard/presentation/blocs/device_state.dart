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

  // 👇 Lỗi một lần (One-shot error)
  final String? errorMessage;
  final int? errorTimestamp; // Để phân biệt các lỗi trùng nhau

  DeviceState({
    this.isLoading = false,
    this.userDevices = const [],
    this.uiSensors = const [],
    this.uiIODevices = const [],
    this.errorMessage,
    this.errorTimestamp,
  });

  // Hàm copyWith cập nhật từng phần
  DeviceState copyWith({
    bool? isLoading,
    List<DeviceEntity>? userDevices,
    List<Map<String, dynamic>>? uiSensors,
    List<Map<String, dynamic>>? uiIODevices,
    String? errorMessage,
    int? errorTimestamp,
  }) {
    return DeviceState(
      isLoading: isLoading ?? this.isLoading,
      userDevices: userDevices ?? this.userDevices,
      uiSensors: uiSensors ?? this.uiSensors,
      uiIODevices: uiIODevices ?? this.uiIODevices,
      errorMessage: errorMessage, // Nếu null được truyền vào thì RESET lỗi
      errorTimestamp: errorTimestamp ?? this.errorTimestamp,
    );
  }
}