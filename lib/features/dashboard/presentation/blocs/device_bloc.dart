import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart'; 
import '../../../../domain/usecases/get_user_devices_usecase.dart'; 
import '../../../../domain/entities/device_entity.dart'; 

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final GetUserDevicesUseCase getUserDevicesUseCase;

  DeviceBloc({required this.getUserDevicesUseCase}) : super(DeviceState(isLoading: true)) {
    
    // 1. LOAD DANH SÁCH TỦ (HOME)
    on<LoadDevices>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final List<DeviceEntity> devicesFromRepo = await getUserDevicesUseCase();
        
        // ✅ Xóa dữ liệu giả cứng ở đây. 
        // Dữ liệu chi tiết sẽ được tạo khi gọi SelectDevice
        emit(state.copyWith(
          isLoading: false,
          userDevices: devicesFromRepo, 
          uiSensors: [],   // Để trống ban đầu
          uiIODevices: [], // Để trống ban đầu
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    // 👇 7. MỚI: XỬ LÝ KHI CHỌN TỦ (MAPPING DATA)
    on<SelectDevice>((event, emit) {
      final device = event.device;

      // A. Mapping Sensors (Nhiệt độ, Độ ẩm)
      final List<Map<String, dynamic>> mappedSensors = [];
      
      // Nếu temps = [28.6, 30.0] -> Chạy 2 vòng
      for (int i = 0; i < device.temps.length; i++) {
        mappedSensors.add({
          'title': 'Nhiệt độ (CB${i + 1})', // Tự đặt tên: CB1, CB2...
          'value': '${device.temps[i]}',
          'unit': '°C'
        });
      }

      // 👇 LOGIC MỚI: DUYỆT DANH SÁCH ĐỘ ẨM
      for (int i = 0; i < device.hums.length; i++) {
        mappedSensors.add({
          'title': 'Độ ẩm (CB${i + 1})',
          'value': '${device.hums[i]}',
          'unit': '%'
        });
      }

      // B. Mapping Relays (Đầu ra)
      // Chuyển mảng [1, 0, 0, 1] thành danh sách UI
      final List<Map<String, dynamic>> mappedIODevices = [];
      
      for (int i = 0; i < device.relays.length; i++) {
        final int status = device.relays[i]; // 1 hoặc 0
        mappedIODevices.add({
          'name': 'Đầu ra ${i + 1}', // Tự đặt tên: Đầu ra 1, 2...
          'isOn': status == 1,       // 1 là true (Bật), 0 là false (Tắt)
          'icon': Icons.bolt, // Icon mặc định
        });
      }

      // Cập nhật State
      emit(state.copyWith(
        uiSensors: mappedSensors,
        uiIODevices: mappedIODevices
      ));
    });

    // ... (Giữ nguyên các sự kiện Add/Delete/Update/Toggle/Reset khác bên dưới) ...
    // 2. AddDeviceItem
    on<AddDeviceItem>((event, emit) {
       if (event.type == 'cabinet') {
        final newCabinet = DeviceEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: event.deviceData['name'] ?? 'Tủ mới',
          status: 1, relays: [0, 0, 0, 0], inputs: [0, 0], temps: [0.0], hums: [0.0],
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        final updatedList = List<DeviceEntity>.from(state.userDevices);
        updatedList.add(newCabinet);
        emit(state.copyWith(userDevices: updatedList));
      } else if (event.type == 'device') {
        final updatedList = List<Map<String, dynamic>>.from(state.uiIODevices);
        updatedList.add(event.deviceData);
        emit(state.copyWith(uiIODevices: updatedList));
      } else {
        final updatedList = List<Map<String, dynamic>>.from(state.uiSensors);
        updatedList.add(event.deviceData);
        emit(state.copyWith(uiSensors: updatedList));
      }
    });

    // 3. DeleteDeviceItem
    on<DeleteDeviceItem>((event, emit) {
      if (event.type == 'cabinet') {
        final updatedList = List<DeviceEntity>.from(state.userDevices);
        if (event.index >= 0 && event.index < updatedList.length) {
          updatedList.removeAt(event.index);
          emit(state.copyWith(userDevices: updatedList));
        }
      } else if (event.type == 'device') {
        final updatedList = List<Map<String, dynamic>>.from(state.uiIODevices);
        if (event.index >= 0 && event.index < updatedList.length) {
          updatedList.removeAt(event.index);
          emit(state.copyWith(uiIODevices: updatedList));
        }
      } else {
        final updatedList = List<Map<String, dynamic>>.from(state.uiSensors);
        if (event.index >= 0 && event.index < updatedList.length) {
          updatedList.removeAt(event.index);
          emit(state.copyWith(uiSensors: updatedList));
        }
      }
    });

    // 4. UpdateDeviceItem
    on<UpdateDeviceItem>((event, emit) {
      if (event.type == 'device') {
        final updatedList = List<Map<String, dynamic>>.from(state.uiIODevices);
        updatedList[event.index] = event.newData;
        emit(state.copyWith(uiIODevices: updatedList));
      } else {
        final updatedList = List<Map<String, dynamic>>.from(state.uiSensors);
        updatedList[event.index] = event.newData;
        emit(state.copyWith(uiSensors: updatedList));
      }
    });

    // 5. ToggleDeviceStatus
    on<ToggleDeviceStatus>((event, emit) {
      final updatedList = List<Map<String, dynamic>>.from(state.uiIODevices);
      final currentDevice = updatedList[event.index];
      updatedList[event.index] = {
        ...currentDevice,
        'isOn': !(currentDevice['isOn'] ?? false),
      };
      emit(state.copyWith(uiIODevices: updatedList));
    });

    // 6. ResetDeviceEvent
    on<ResetDeviceEvent>((event, emit) {
      emit(DeviceState(isLoading: false, userDevices: [], uiSensors: [], uiIODevices: []));
    });
  }
}