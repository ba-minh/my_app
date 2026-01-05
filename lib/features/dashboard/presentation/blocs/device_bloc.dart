import 'package:flutter_bloc/flutter_bloc.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(DeviceState(devices: [])) {
    
    // 1. Xử lý sự kiện Thêm thiết bị
    on<AddDeviceEvent>((event, emit) {
      // Tạo một danh sách mới từ danh sách cũ (để tránh lỗi tham chiếu)
      final updatedList = List<Map<String, dynamic>>.from(state.devices);
      updatedList.add(event.newDevice);
      
      // Phát ra trạng thái mới -> UI sẽ tự cập nhật
      emit(state.copyWith(devices: updatedList));
    });

    // 2. Xử lý sự kiện Bật/Tắt
    on<ToggleDeviceEvent>((event, emit) {
      final updatedList = List<Map<String, dynamic>>.from(state.devices);
      
      // Cập nhật trạng thái isOn của thiết bị tại vị trí index
      updatedList[event.index] = {
        ...updatedList[event.index],
        'isOn': event.isOn,
      };

      emit(state.copyWith(devices: updatedList));
    });
  }
}