import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';

import '../datasources/remote/device_mock_datasource.dart'; 
import '../datasources/local/device_local_datasource.dart';
import '../models/device_model.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  // Datasource lấy dữ liệu từ Server (hoặc Mock)
  final DeviceRemoteDataSource remoteDataSource; 
  // Datasource lấy dữ liệu từ máy (Local)
  final DeviceLocalDataSource localDataSource;

  DeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<DeviceEntity>> getUserDevices() async {
    try {
      // BƯỚC 1: Ưu tiên gọi Server/Mock lấy dữ liệu mới
      // (Ép kiểu về List<DeviceModel> để lưu được vào Local)
      final List<DeviceModel> remoteDevices = await remoteDataSource.getUserDevices();
      
      // [OPTIMIZED] Lấy dữ liệu cũ từ Local để merge (giữ lại tên Relay)
      final localDevices = await localDataSource.getLastDevices();
      final Map<String, List<String>> localRelayNamesMap = {
        for (var d in localDevices) d.id: d.relayNames
      };

      // Merge: Nếu remote chưa có tên (rỗng) nhưng Local có -> Lấy từ Local
      final mergedDevices = remoteDevices.map((remoteDevice) {
        final localNames = localRelayNamesMap[remoteDevice.id];
        if (localNames != null && localNames.isNotEmpty) {
             // Remote (Mock) thường trả về relayNames rỗng. 
             // Nếu Backend sau này trả về tên, ta có thể ưu tiên Backend hoặc Local tùy logic.
             // Ở đây ưu tiên Backend nếu có, nếu không thì lấy Local.
             final List<String> mergedNames = List<String>.from(remoteDevice.relayNames);
             
             // Nếu remote rỗng hoặc ngắn hơn, fill từ local
             for (int i = 0; i < localNames.length; i++) {
               if (i >= mergedNames.length) {
                 mergedNames.add(localNames[i]);
               } else if (mergedNames[i].isEmpty) {
                 mergedNames[i] = localNames[i];
               }
             }
             
             return DeviceModel(
                id: remoteDevice.id,
                name: remoteDevice.name,
                status: remoteDevice.status,
                relays: remoteDevice.relays,
                inputs: remoteDevice.inputs,
                temp: remoteDevice.temp,
                hum: remoteDevice.hum,
                relayNames: mergedNames, // Sử dụng tên đã merge
                timestamp: remoteDevice.timestamp
             );
        }
        return remoteDevice;
      }).toList();

      // BƯỚC 2: Nếu thành công -> Lưu đè vào Local ngay lập tức
      await localDataSource.cacheDevices(mergedDevices);
      
      return mergedDevices;
    } catch (e) {
      // BƯỚC 3: Nếu lỗi mạng hoặc Server chết -> Lấy dữ liệu cũ từ Local
      print("⚠️ Mất kết nối hoặc lỗi Server ($e). Đang lấy dữ liệu Offline...");
      
      try {
        final localDevices = await localDataSource.getLastDevices();
        
        if (localDevices.isNotEmpty) {
           return localDevices;
        }
        // Nếu Local cũng rỗng (App mới cài, chưa chạy lần nào)
        throw Exception("Không có kết nối mạng và chưa có dữ liệu lưu trữ.");
      } catch (localError) {
        throw Exception("Lỗi hệ thống: $localError");
      }
    }
  }


  @override
  Future<void> updateDevice(DeviceEntity device) async {
    try {
      // 1. Lấy danh sách cũ
      final existingDevices = await localDataSource.getLastDevices();
      
      // 2. Tìm và cập nhật thiết bị
      final updatedList = existingDevices.map((d) {
        if (d.id == device.id) {
          // Chuyển Entity -> Model để lưu
          return DeviceModel(
            id: device.id, 
            name: device.name, 
            status: device.status, 
            relays: device.relays, 
            inputs: device.inputs, 
            temp: device.temp, 
            hum: device.hum, 
            relayNames: device.relayNames, // Lưu tên relay
            timestamp: DateTime.now().millisecondsSinceEpoch
          );
        }
        return d;
      }).toList();

      // 3. Lưu lại vào cache
      await localDataSource.cacheDevices(updatedList);
    } catch (e) {
      // Handle error or rethrow
      rethrow;
    }
  }
}