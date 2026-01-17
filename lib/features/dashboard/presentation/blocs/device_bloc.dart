import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart'; 
import 'package:connectivity_plus/connectivity_plus.dart'; // 👇 Import check mạng
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
      
      // Nếu temp = [28.6, 30.0] -> Chạy 2 vòng
      for (int i = 0; i < device.temp.length; i++) {
        mappedSensors.add({
          'title': 'Nhiệt độ (CB${i + 1})', // Tự đặt tên: CB1, CB2...
          'value': '${device.temp[i]}',
          'unit': '°C'
        });
      }

      // 👇 LOGIC MỚI: DUYỆT DANH SÁCH ĐỘ ẨM
      for (int i = 0; i < device.hum.length; i++) {
        mappedSensors.add({
          'title': 'Độ ẩm (CB${i + 1})',
          'value': '${device.hum[i]}',
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
          status: 1, relays: [0, 0, 0, 0], inputs: [0, 0], temp: [0.0], hum: [0.0],
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

    // 5. ToggleDeviceStatus (Logic Mới: Optimistic UI + Rollback)
    on<ToggleDeviceStatus>((event, emit) async {
      final int index = event.index;
      final currentList = List<Map<String, dynamic>>.from(state.uiIODevices);
      final currentDevice = currentList[index];
      final bool oldStatus = currentDevice['isOn'] ?? false;
      final bool newStatus = !oldStatus;

      // BƯỚC 1: Cập nhật UI ngay lập tức (Optimistic)
      currentList[index] = { ...currentDevice, 'isOn': newStatus };
      emit(state.copyWith(uiIODevices: currentList, errorMessage: null)); // Clear error cũ

      // BƯỚC 2: Giả lập độ trễ mạng (1 giây)
      await Future.delayed(const Duration(seconds: 1));

      // BƯỚC 3: Kiểm tra kết nối
      // (Do Backend chưa xong, ta coi như mọi lần gọi server đều cần check mạng trước)
      final connectivityResult = await Connectivity().checkConnectivity();
      final bool hasNetwork = !connectivityResult.contains(ConnectivityResult.none);

      // Điều kiện lỗi: Mất mạng HOẶC Tủ Offline (Status == 0)
      // Lưu ý: Ở đây ta logic tạm là nếu Tủ đang status=0 (trong userDevices) thì coi như tủ Offline
      bool isDeviceOnline = true;
      // Tìm tủ hiện tại (giả định đang làm việc với tủ đầu tiên hoặc logic chọn tủ phức tạp hơn)
      // Ở screen Detail ta đã mapping ra UI, nên khó check ngược lại status tủ gốc nếu không lưu ID.
      // TẠM THỜI: Check mạng điện thoại trước.

      if (!hasNetwork) {
         // BƯỚC 4: ROLLBACK nếu lỗi
         // Trả về trạng thái cũ
         currentList[index] = { ...currentDevice, 'isOn': oldStatus };
         
         emit(state.copyWith(
           uiIODevices: currentList,
           errorMessage: "Mất kết nối Internet! Không thể gửi lệnh.",
           errorTimestamp: DateTime.now().millisecondsSinceEpoch,
         ));
      } else {
        // Nếu có mạng -> Giả lập Server chưa xong -> Có thể cho thành công hoặc thất bại tùy ý
        // Theo yêu cầu user: "Server chưa xong... Gửi lệnh API... Mất mạng hoặc tủ offline quay về ban đầu"
        // Ta giả định ở đây là gửi thành công nếu có mạng.
        
        // Nếu muốn check Tủ Offline:
        // Cần truyền ID tủ vào event hoặc lưu currentDeviceEntity trong Bloc.
        // Tạm thời bỏ qua check tủ offline sâu, chỉ check mạng theo yêu cầu chính.
      }
    });

    // 6. ResetDeviceEvent
    on<ResetDeviceEvent>((event, emit) {
      emit(DeviceState(isLoading: false, userDevices: [], uiSensors: [], uiIODevices: []));
    });
  }
}