import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/remote/device_mock_datasource.dart'; // Import file mock vừa tạo

class DeviceRepositoryImpl implements DeviceRepository {
  // Chú ý: Khai báo kiểu là Interface (DeviceRemoteDataSource) để dễ thay đổi sau này
  final DeviceRemoteDataSource remoteDataSource;

  DeviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DeviceEntity>> getUserDevices() async {
    // Gọi xuống Datasource để lấy dữ liệu (đang là dữ liệu giả)
    return await remoteDataSource.getUserDevices();
  }
}