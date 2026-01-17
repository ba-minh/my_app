import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class GetUserDevicesUseCase {
  final DeviceRepository repository;

  GetUserDevicesUseCase(this.repository);

  // Hàm thực thi (callable class)
  Future<List<DeviceEntity>> call() async {
    return await repository.getUserDevices();
  }
}