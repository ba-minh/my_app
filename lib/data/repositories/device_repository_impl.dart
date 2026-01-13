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
      
      // BƯỚC 2: Nếu thành công -> Lưu đè vào Local ngay lập tức
      await localDataSource.cacheDevices(remoteDevices);
      
      return remoteDevices;
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
}